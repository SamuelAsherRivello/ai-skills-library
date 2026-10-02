import importlib.util
import json
from pathlib import Path
import subprocess
import tempfile
import unittest

SCRIPT = Path(__file__).with_name("update_openspec_skills.py")
spec = importlib.util.spec_from_file_location("update_openspec_skills", SCRIPT)
module = importlib.util.module_from_spec(spec)
spec.loader.exec_module(module)


def skill(name, body, author="openspec"):
    return f"---\nname: {name}\ndescription: {name} skill\nauthor: {author}\n---\n{body}".encode()


class RefreshTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.root = Path(self.temp.name)
        self.repo = self.root / "repo"
        self.upstream = self.root / "upstream"
        self.repo.mkdir()
        self.upstream.mkdir()
        self.skills = self.repo / ".agents/skills/openspec"
        self.skills.mkdir(parents=True)
        (self.repo / "documentation").mkdir()
        self.run_git(self.upstream, "init", "-q")
        self.run_git(self.upstream, "config", "user.email", "test@example.com")
        self.run_git(self.upstream, "config", "user.name", "Test")

    def tearDown(self):
        self.temp.cleanup()

    def run_git(self, cwd, *args):
        return subprocess.run(["git", "-C", str(cwd), *args], check=True, capture_output=True).stdout.decode().strip()

    def write(self, root, relative, content):
        path = root / relative
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_bytes(content)
        return path

    def commit_upstream(self, files, message):
        for name, content in files.items():
            self.write(self.upstream, f"skills/{name}/SKILL.md", content)
        self.run_git(self.upstream, "add", ".")
        self.run_git(self.upstream, "commit", "-m", message)
        return self.run_git(self.upstream, "rev-parse", "HEAD")

    def record(self, revision, per_skill=True):
        record = {
            "repository": module.REPOSITORY_URL,
            "release": "v1.0.0",
            "source": "skills/<name>/SKILL.md",
        }
        if per_skill:
            record["skill_revisions"] = {name: revision for name in ("openspec-one", "openspec-two")}
        else:
            record["revision"] = revision
        (self.repo / "documentation/openspec-upstream.json").write_text(json.dumps(record), encoding="utf-8")

    def test_clean_merge_preserves_non_overlapping_customization_and_advances_baseline(self):
        base = skill("openspec-one", "line one\nline two\nline three\n")
        old = self.commit_upstream({"openspec-one": base}, "baseline")
        local = skill("openspec-one", "line one\nline two\nline three\n\nLocal guidance.\n")
        new = skill("openspec-one", "line one upstream\nline two\nline three\n")
        new_revision = self.commit_upstream({"openspec-one": new}, "upstream update")
        self.write(self.repo, ".agents/skills/openspec/openspec-one/SKILL.md", local)
        self.record(old, per_skill=False)

        result = module.refresh(self.repo, self.upstream, "v1.1.0", new_revision)
        merged = (self.skills / "openspec-one/SKILL.md").read_bytes()
        self.assertIn(b"line one upstream", merged)
        self.assertIn(b"Local guidance.", merged)
        self.assertEqual(result["skill_revisions"]["openspec-one"], new_revision)
        self.assertEqual(result["results"]["openspec-one"], "updated")

    def test_conflict_holds_that_skill_base_while_another_skill_advances(self):
        base_one = skill("openspec-one", "same line\nkeep\n")
        base_two = skill("openspec-two", "first\nsecond\nthird\n")
        old = self.commit_upstream({"openspec-one": base_one, "openspec-two": base_two}, "baseline")
        new_one = skill("openspec-one", "upstream line\nkeep\n")
        new_two = skill("openspec-two", "first upstream\nsecond\nthird\n")
        new_revision = self.commit_upstream({"openspec-one": new_one, "openspec-two": new_two}, "upstream update")
        local_one = skill("openspec-one", "local line\nkeep\n")
        local_two = skill("openspec-two", "first\nsecond\nthird\n\nLocal note.\n")
        self.write(self.repo, ".agents/skills/openspec/openspec-one/SKILL.md", local_one)
        self.write(self.repo, ".agents/skills/openspec/openspec-two/SKILL.md", local_two)
        self.record(old)

        result = module.refresh(self.repo, self.upstream, "v1.1.0", new_revision)
        self.assertEqual((self.skills / "openspec-one/SKILL.md").read_bytes(), local_one)
        self.assertEqual(result["skill_revisions"]["openspec-one"], old)
        self.assertEqual(result["results"]["openspec-one"], "conflict")
        self.assertEqual(result["skill_revisions"]["openspec-two"], new_revision)
        self.assertIn(b"first upstream", (self.skills / "openspec-two/SKILL.md").read_bytes())
        self.assertIn(b"Local note.", (self.skills / "openspec-two/SKILL.md").read_bytes())

    def test_custom_skill_and_new_upstream_skill_are_not_modified_or_added(self):
        base = skill("openspec-one", "body\n")
        old = self.commit_upstream({"openspec-one": base}, "baseline")
        new_revision = self.commit_upstream({"openspec-one": skill("openspec-one", "new body\n"), "openspec-added": skill("openspec-added", "new")}, "update")
        custom = skill("openspec-custom", "mine\n", author="local")
        self.write(self.repo, ".agents/skills/openspec/openspec-one/SKILL.md", base)
        self.write(self.repo, ".agents/skills/openspec/openspec-custom/SKILL.md", custom)
        self.record(old)

        result = module.refresh(self.repo, self.upstream, "v1.1.0", new_revision)
        self.assertEqual((self.skills / "openspec-custom/SKILL.md").read_bytes(), custom)
        self.assertFalse((self.skills / "openspec-added").exists())
        self.assertEqual(result["results"]["openspec-custom"], "preserved-custom")


if __name__ == "__main__":
    unittest.main()
