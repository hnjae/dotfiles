from __future__ import annotations

import hashlib
import json
from pathlib import Path
import subprocess
import sys
import tempfile
import unittest


SCRIPT = Path(__file__).parents[1] / "scripts" / "docs_manifest.py"


class DocsManifestTests(unittest.TestCase):
    def make_project(self, root: Path) -> Path:
        project = root / "project"
        (project / "docs" / "spec").mkdir(parents=True)
        (project / "docs" / "architecture").mkdir()
        return project

    def run_manifest(
        self, *args: str | Path
    ) -> subprocess.CompletedProcess[str]:
        return subprocess.run(
            [sys.executable, str(SCRIPT), *(str(arg) for arg in args)],
            check=False,
            capture_output=True,
            text=True,
        )

    def test_snapshot_inventories_files_without_following_symlinks(
        self,
    ) -> None:
        with tempfile.TemporaryDirectory() as temporary_directory:
            root = Path(temporary_directory)
            project = self.make_project(root)
            contents = b"# Product contract\n"
            (project / "docs" / "spec" / "product.md").write_bytes(contents)
            outside = root / "outside.md"
            outside.write_text("not review evidence", encoding="utf-8")
            (project / "docs" / "architecture" / "outside.md").symlink_to(
                outside
            )

            result = self.run_manifest("snapshot", project)

            self.assertEqual(result.returncode, 0, result.stderr)
            manifest = json.loads(result.stdout)
            entries = {entry["path"]: entry for entry in manifest["entries"]}
            self.assertEqual(manifest["schema_version"], 1)
            self.assertEqual(entries["docs/spec/product.md"]["type"], "file")
            self.assertEqual(
                entries["docs/spec/product.md"]["sha256"],
                hashlib.sha256(contents).hexdigest(),
            )
            self.assertEqual(
                entries["docs/architecture/outside.md"]["type"], "symlink"
            )
            self.assertNotIn(str(outside), result.stdout)
            self.assertNotIn("not review evidence", result.stdout)

    def test_compare_reports_content_drift_with_stable_machine_output(
        self,
    ) -> None:
        with tempfile.TemporaryDirectory() as temporary_directory:
            root = Path(temporary_directory)
            project = self.make_project(root)
            document = project / "docs" / "spec" / "product.md"
            document.write_text("before\n", encoding="utf-8")
            snapshot = self.run_manifest("snapshot", project)
            self.assertEqual(snapshot.returncode, 0, snapshot.stderr)
            expected_manifest = root / "expected.json"
            expected_manifest.write_text(snapshot.stdout, encoding="utf-8")

            equal_result = self.run_manifest(
                "compare", project, expected_manifest
            )
            self.assertEqual(equal_result.returncode, 0, equal_result.stderr)
            self.assertTrue(json.loads(equal_result.stdout)["equal"])

            document.write_text("after\n", encoding="utf-8")

            result = self.run_manifest("compare", project, expected_manifest)

            self.assertEqual(result.returncode, 1, result.stderr)
            comparison = json.loads(result.stdout)
            self.assertFalse(comparison["equal"])
            self.assertEqual(comparison["added"], [])
            self.assertEqual(comparison["removed"], [])
            self.assertEqual(
                [change["path"] for change in comparison["changed"]],
                ["docs/spec/product.md"],
            )
            self.assertIn("sha256", comparison["changed"][0]["fields"])

    def test_snapshot_rejects_a_symlinked_required_root(self) -> None:
        with tempfile.TemporaryDirectory() as temporary_directory:
            root = Path(temporary_directory)
            project = root / "project"
            (project / "docs").mkdir(parents=True)
            outside = root / "outside"
            outside.mkdir()
            (project / "docs" / "spec").symlink_to(
                outside, target_is_directory=True
            )
            (project / "docs" / "architecture").mkdir()

            result = self.run_manifest("snapshot", project)

            self.assertEqual(result.returncode, 2)
            error = json.loads(result.stderr)
            self.assertEqual(error["error"], "invalid_root")


if __name__ == "__main__":
    unittest.main()
