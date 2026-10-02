"""Merge existing upstream-owned OpenSpec skills against their recorded baselines."""

import argparse
import json
from pathlib import Path
import re
import subprocess
import tempfile

REPOSITORY_URL = "https://github.com/Fission-AI/OpenSpec"


def frontmatter(text):
    match = re.match(r"\A---\r?\n(.*?)\r?\n---(?:\r?\n|$)", text, re.S)
    if not match:
        raise ValueError("Missing skill frontmatter")
    return match.group(1)


def field(metadata, key):
    match = re.search(rf"(?m)^\s*{re.escape(key)}:\s*([^\r\n]+)", metadata)
    return match.group(1).strip().strip("\"'") if match else None


def git_show(repository, revision, name):
    path = f"{revision}:skills/{name}/SKILL.md"
    result = subprocess.run(
        ["git", "-C", str(repository), "show", path],
        check=False, capture_output=True,
    )
    if result.returncode:
        raise ValueError(f"Cannot read OpenSpec baseline {revision} for {name}: {result.stderr.decode(errors='replace').strip()}")
    return result.stdout


def merge(base, local, upstream):
    with tempfile.TemporaryDirectory(prefix="openspec-skill-merge-") as directory:
        root = Path(directory)
        local_file, base_file, upstream_file = (root / item for item in ("local", "base", "upstream"))
        local_file.write_bytes(local)
        base_file.write_bytes(base)
        upstream_file.write_bytes(upstream)
        result = subprocess.run(
            ["git", "merge-file", "--stdout", str(local_file), str(base_file), str(upstream_file)],
            check=False, capture_output=True,
        )
        if result.returncode > 1:
            raise RuntimeError(result.stderr.decode(errors="replace").strip() or "git merge-file failed")
        return result.stdout, result.returncode == 0


def refresh(repository, upstream, tag, revision):
    if not re.fullmatch(r"v?\d+\.\d+\.\d+", tag):
        raise ValueError("Expected a stable OpenSpec release tag")
    if not re.fullmatch(r"[0-9a-f]{40}", revision):
        raise ValueError("Expected the full upstream commit SHA")

    skills_root = repository / ".agents" / "skills" / "openspec"
    record_path = repository / "documentation" / "openspec-upstream.json"
    record = json.loads(record_path.read_text(encoding="utf-8")) if record_path.exists() else {}
    baselines = dict(record.get("skill_revisions", {}))
    legacy_revision = record.get("revision")
    pending = []
    outcomes = {}
    preserved_custom = []

    # Inspect and merge all candidates before writing any skill files.
    for target in sorted(skills_root.glob("openspec-*/SKILL.md")):
        if target.is_symlink() or target.parent.is_symlink():
            raise ValueError(f"Refusing linked skill: {target}")
        name = target.parent.name
        local = target.read_bytes()
        metadata = frontmatter(local.decode("utf-8"))
        if field(metadata, "author") != "openspec":
            preserved_custom.append(name)
            outcomes[name] = "preserved-custom"
            continue

        base_revision = baselines.get(name) or legacy_revision
        if not base_revision:
            raise ValueError(f"No recorded upstream baseline for {name}")
        source = upstream / "skills" / name / "SKILL.md"
        if not source.is_file() or source.is_symlink() or source.parent.is_symlink():
            outcomes[name] = "missing-upstream"
            baselines.setdefault(name, base_revision)
            continue
        incoming = source.read_bytes()
        upstream_metadata = frontmatter(incoming.decode("utf-8"))
        if field(upstream_metadata, "name") != name or field(upstream_metadata, "author") != "openspec":
            raise ValueError(f"Upstream skill identity mismatch: {name}")
        if not field(upstream_metadata, "description"):
            raise ValueError(f"Upstream description missing: {name}")

        base = git_show(upstream, base_revision, name)
        merged, clean = merge(base, local, incoming)
        if clean:
            pending.append((target, merged, name))
            baselines[name] = revision
            outcomes[name] = "updated" if merged != local else "unchanged"
        else:
            baselines.setdefault(name, base_revision)
            outcomes[name] = "conflict"

    for target, content, _ in pending:
        target.write_bytes(content)

    record.update({
        "repository": REPOSITORY_URL,
        "release": tag,
        "revision": revision,
        "source": "skills/<name>/SKILL.md",
        "skill_revisions": dict(sorted(baselines.items())),
        "updated_skills": [name for name, result in outcomes.items() if result == "updated"],
        "preserved_custom_skills": sorted(preserved_custom),
        "results": dict(sorted(outcomes.items())),
    })
    record_path.parent.mkdir(parents=True, exist_ok=True)
    record_path.write_text(json.dumps(record, indent=2) + "\n", encoding="utf-8")
    return record


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--repository", type=Path, default=Path.cwd())
    parser.add_argument("--upstream", type=Path, required=True)
    parser.add_argument("--tag", required=True)
    parser.add_argument("--revision", required=True)
    args = parser.parse_args()
    print(json.dumps(refresh(args.repository, args.upstream, args.tag, args.revision), indent=2))
