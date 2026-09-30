"""Refresh existing upstream-owned skills from an official OpenSpec checkout."""

import argparse
import json
from pathlib import Path
import re


def frontmatter(text):
    match = re.match(r"\A---\r?\n(.*?)\r?\n---(?:\r?\n|$)", text, re.S)
    if not match:
        raise ValueError("Missing skill frontmatter")
    return match.group(1)


def field(metadata, key):
    match = re.search(rf"(?m)^\s*{re.escape(key)}:\s*([^\r\n]+)", metadata)
    return match.group(1).strip().strip("\"'") if match else None


def refresh(repository, upstream, tag, revision):
    if not re.fullmatch(r"v?\d+\.\d+\.\d+", tag):
        raise ValueError("Expected a stable OpenSpec release tag")
    if not re.fullmatch(r"[0-9a-f]{40}", revision):
        raise ValueError("Expected the full upstream commit SHA")
    skills = repository / ".agents" / "skills"
    updates = []
    preserved = []
    # Validate every candidate before writing any files. Never create a skill.
    for target in sorted(skills.glob("openspec-*/SKILL.md")):
        if target.is_symlink() or target.parent.is_symlink():
            raise ValueError(f"Refusing linked skill: {target}")
        name = target.parent.name
        existing = frontmatter(target.read_text(encoding="utf-8"))
        if field(existing, "author") != "openspec":
            preserved.append(name)
            continue
        source = upstream / "skills" / name / "SKILL.md"
        if not source.is_file() or source.is_symlink() or source.parent.is_symlink():
            raise ValueError(f"Upstream skill is missing or linked: {name}")
        content = source.read_bytes()
        metadata = frontmatter(content.decode("utf-8"))
        if field(metadata, "name") != name or field(metadata, "author") != "openspec":
            raise ValueError(f"Upstream skill identity mismatch: {name}")
        if not field(metadata, "description"):
            raise ValueError(f"Upstream description missing: {name}")
        updates.append((target, content))
    if not updates:
        raise ValueError("No existing upstream-owned OpenSpec skills found")
    for target, content in updates:
        target.write_bytes(content)
    record = {
        "repository": "https://github.com/Fission-AI/OpenSpec",
        "release": tag,
        "revision": revision,
        "source": "skills/<name>/SKILL.md",
        "updated_skills": [target.parent.name for target, _ in updates],
        "preserved_custom_skills": preserved,
    }
    record_path = repository / "documentation" / "openspec-upstream.json"
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
