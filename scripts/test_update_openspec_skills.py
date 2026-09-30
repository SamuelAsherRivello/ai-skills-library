import tempfile
from pathlib import Path
import unittest

from update_openspec_skills import refresh


def skill(name, body, author="openspec"):
    return f"---\nname: {name}\ndescription: A test skill\nmetadata:\n  author: {author}\n---\n{body}\n"


class RefreshTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.repo = Path(self.temp.name) / "repo"
        self.upstream = Path(self.temp.name) / "upstream"

    def write(self, root, relative, content):
        path = root / relative
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_text(content, encoding="utf-8")
        return path

    def run_refresh(self):
        return refresh(self.repo, self.upstream, "v1.13.2", "a" * 40)

    def test_only_existing_upstream_skills_change_and_repeat_is_identical(self):
        target = self.write(self.repo, ".agents/skills/openspec-apply-change/SKILL.md", skill("openspec-apply-change", "old"))
        custom = self.write(self.repo, ".agents/skills/openspec-grill-me/SKILL.md", skill("openspec-grill-me", "custom", "local"))
        display = self.write(self.repo, ".agents/skills/openspec-apply-change/agents/openai.yaml", "interface: custom\n")
        source = self.write(self.upstream, "skills/openspec-apply-change/SKILL.md", skill("openspec-apply-change", "new"))
        self.write(self.upstream, "skills/openspec-new-change/SKILL.md", skill("openspec-new-change", "new command"))
        self.write(self.upstream, "skills/openspec-grill-me/SKILL.md", skill("openspec-grill-me", "upstream collision"))
        original_custom = custom.read_bytes()
        result = self.run_refresh()
        self.assertEqual(target.read_bytes(), source.read_bytes())
        self.assertEqual(custom.read_bytes(), original_custom)
        self.assertEqual(display.read_text(), "interface: custom\n")
        self.assertFalse((self.repo / ".agents/skills/openspec-new-change").exists())
        self.assertEqual(result["updated_skills"], ["openspec-apply-change"])
        record = self.repo / "documentation/openspec-upstream.json"
        first_record = record.read_bytes()
        self.run_refresh()
        self.assertEqual(record.read_bytes(), first_record)

    def test_missing_or_invalid_upstream_fails_before_any_write(self):
        first = self.write(self.repo, ".agents/skills/openspec-apply-change/SKILL.md", skill("openspec-apply-change", "old"))
        self.write(self.repo, ".agents/skills/openspec-propose/SKILL.md", skill("openspec-propose", "old"))
        self.write(self.upstream, "skills/openspec-apply-change/SKILL.md", skill("openspec-apply-change", "new"))
        original = first.read_bytes()
        with self.assertRaisesRegex(ValueError, "missing or linked"):
            self.run_refresh()
        self.assertEqual(first.read_bytes(), original)
        self.write(self.upstream, "skills/openspec-propose/SKILL.md", skill("openspec-wrong", "new"))
        with self.assertRaisesRegex(ValueError, "identity mismatch"):
            self.run_refresh()
        self.assertEqual(first.read_bytes(), original)


if __name__ == "__main__":
    unittest.main()
