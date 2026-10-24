import importlib.util
import json
from pathlib import Path
import re
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
        self.skills = self.repo / ".agents/skills/ai-skills-openspec"
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
        local = skill("ai-skills-openspec-one", "line one\nline two\nline three\n\nLocal guidance.\n")
        new = skill("openspec-one", "line one upstream\nline two\nline three\n")
        new_revision = self.commit_upstream({"openspec-one": new}, "upstream update")
        self.write(self.skills, "ai-skills-openspec-one/SKILL.md", local)
        self.record(old, per_skill=False)

        result = module.refresh(self.repo, self.upstream, "v1.1.0", new_revision)
        merged = (self.skills / "ai-skills-openspec-one/SKILL.md").read_bytes()
        self.assertIn(b"line one upstream", merged)
        self.assertIn(b"Local guidance.", merged)
        self.assertIn(b"name: ai-skills-openspec-one\n", merged)
        self.assertEqual(result["skill_revisions"]["ai-skills-openspec-one"], new_revision)
        self.assertEqual(result["upstream_names"]["ai-skills-openspec-one"], "openspec-one")
        self.assertEqual(result["results"]["ai-skills-openspec-one"], "updated")

    def test_conflict_holds_that_skill_base_while_another_skill_advances(self):
        base_one = skill("openspec-one", "same line\nkeep\n")
        base_two = skill("openspec-two", "first\nsecond\nthird\n")
        old = self.commit_upstream({"openspec-one": base_one, "openspec-two": base_two}, "baseline")
        new_one = skill("openspec-one", "upstream line\nkeep\n")
        new_two = skill("openspec-two", "first upstream\nsecond\nthird\n")
        new_revision = self.commit_upstream({"openspec-one": new_one, "openspec-two": new_two}, "upstream update")
        local_one = skill("ai-skills-openspec-one", "local line\nkeep\n")
        local_two = skill("ai-skills-openspec-two", "first\nsecond\nthird\n\nLocal note.\n")
        self.write(self.skills, "ai-skills-openspec-one/SKILL.md", local_one)
        self.write(self.skills, "ai-skills-openspec-two/SKILL.md", local_two)
        self.record(old)

        result = module.refresh(self.repo, self.upstream, "v1.1.0", new_revision)
        self.assertEqual((self.skills / "ai-skills-openspec-one/SKILL.md").read_bytes(), local_one)
        self.assertEqual(result["skill_revisions"]["ai-skills-openspec-one"], old)
        self.assertNotIn("openspec-one", result["skill_revisions"])
        self.assertEqual(result["results"]["ai-skills-openspec-one"], "conflict")
        self.assertEqual(result["skill_revisions"]["ai-skills-openspec-two"], new_revision)
        self.assertIn(b"first upstream", (self.skills / "ai-skills-openspec-two/SKILL.md").read_bytes())
        self.assertIn(b"Local note.", (self.skills / "ai-skills-openspec-two/SKILL.md").read_bytes())

    def test_custom_skill_and_new_upstream_skill_are_not_modified_or_added(self):
        base = skill("openspec-one", "body\n")
        old = self.commit_upstream({"openspec-one": base}, "baseline")
        new_revision = self.commit_upstream({"openspec-one": skill("openspec-one", "new body\n"), "openspec-added": skill("openspec-added", "new")}, "update")
        custom = skill("ai-skills-openspec-custom", "mine\n", author="local")
        self.write(self.skills, "ai-skills-openspec-one/SKILL.md", skill("ai-skills-openspec-one", "body\n"))
        self.write(self.skills, "ai-skills-openspec-custom/SKILL.md", custom)
        self.record(old)

        result = module.refresh(self.repo, self.upstream, "v1.1.0", new_revision)
        self.assertEqual((self.skills / "ai-skills-openspec-custom/SKILL.md").read_bytes(), custom)
        self.assertFalse((self.skills / "openspec-added").exists())
        self.assertFalse((self.skills / "ai-skills-openspec-added").exists())
        self.assertFalse((self.skills / "openspec-one").exists())
        self.assertEqual(result["results"]["ai-skills-openspec-custom"], "preserved-custom")

    def test_incoming_references_are_localized_and_second_refresh_is_unchanged(self):
        body = "Run $openspec-two.\n\nRead [title](../openspec-title-management.md).\n\n"
        old = self.commit_upstream({"openspec-one": skill("openspec-one", body)}, "baseline")
        self.write(self.skills, "ai-skills-openspec-one/SKILL.md",
                   skill("ai-skills-openspec-one", body.replace("$openspec-two", "$ai-skills-openspec-two")))
        self.write(self.skills, "ai-skills-openspec-two/SKILL.md",
                   skill("ai-skills-openspec-two", "Custom helper.\n", author="local"))
        self.write(self.skills, "ai-skills-openspec-title-management/SKILL.md",
                   skill("ai-skills-openspec-title-management", "Custom title helper.\n", author="local"))
        self.record(old)
        incoming = body + "Then use /openspec-two or [helper](../openspec-two/SKILL.md).\n"
        new = self.commit_upstream({"openspec-one": skill("openspec-one", incoming)}, "new instructions")

        module.refresh(self.repo, self.upstream, "v1.1.0", new)
        path = self.skills / "ai-skills-openspec-one/SKILL.md"
        merged = path.read_bytes()
        self.assertIn(b"name: ai-skills-openspec-one\n", merged)
        self.assertIn(b"$ai-skills-openspec-two", merged)
        self.assertIn(b"/ai-skills-openspec-two", merged)
        self.assertIn(b"../ai-skills-openspec-two/SKILL.md", merged)
        self.assertIn(b"../openspec-title-management.md", merged)
        self.assertNotIn(b"ai-skills-ai-skills-", merged)
        result = module.refresh(self.repo, self.upstream, "v1.1.0", new)
        self.assertEqual(path.read_bytes(), merged)
        self.assertEqual(result["results"]["ai-skills-openspec-one"], "unchanged")

    def test_missing_upstream_preserves_local_content_and_baseline(self):
        old = self.commit_upstream({"openspec-other": skill("openspec-other", "body\n")}, "baseline")
        local = skill("ai-skills-openspec-one", "Local wrapper.\n")
        path = self.write(self.skills, "ai-skills-openspec-one/SKILL.md", local)
        self.record(old)
        result = module.refresh(self.repo, self.upstream, "v1.1.0", old)
        self.assertEqual(path.read_bytes(), local)
        self.assertEqual(result["results"]["ai-skills-openspec-one"], "missing-upstream")
        self.assertEqual(result["skill_revisions"]["ai-skills-openspec-one"], old)

    def test_empty_suite_fails_without_rewriting_provenance(self):
        record_path = self.repo / "documentation/openspec-upstream.json"
        self.record("a" * 40)
        before = record_path.read_bytes()
        with self.assertRaisesRegex(ValueError, "No namespaced OpenSpec skills"):
            module.refresh(self.repo, self.upstream, "v1.1.0", "b" * 40)
        self.assertEqual(record_path.read_bytes(), before)


class RepositoryNamespaceTests(unittest.TestCase):
    def test_catalog_metadata_and_upstream_mapping_cover_the_18_skills(self):
        repo = SCRIPT.parent.parent
        root = repo / ".agents/skills/ai-skills-openspec"
        skills = sorted(root.glob("ai-skills-openspec-*/SKILL.md"))
        self.assertEqual(len(skills), 18)
        self.assertFalse(list(root.glob("openspec-*/SKILL.md")))
        self.assertFalse((repo / ".agents/skills/openspec").exists())
        record = json.loads((repo / "documentation/openspec-upstream.json").read_text(encoding="utf-8"))
        names = {path.parent.name for path in skills}
        self.assertEqual(set(record["upstream_names"]), names)
        for path in skills:
            name = path.parent.name
            with self.subTest(skill=name):
                self.assertLess(len(name), 64)
                self.assertEqual(module.field(module.frontmatter(path.read_text(encoding="utf-8")), "name"), name)
                self.assertEqual(record["upstream_names"][name], name.removeprefix("ai-skills-"))
                ui = path.parent / "agents/openai.yaml"
                if ui.exists():
                    self.assertIn("$" + name, ui.read_text(encoding="utf-8"))
        catalog = (root / "README.md").read_text(encoding="utf-8")
        links = re.findall(r"\]\(\./([a-z0-9-]+)/SKILL\.md\)", catalog)
        self.assertEqual(len(links), 18)
        self.assertEqual(set(links), names)
        self.assertTrue(set(record["skill_revisions"]).issubset(names))


if __name__ == "__main__":
    unittest.main()
