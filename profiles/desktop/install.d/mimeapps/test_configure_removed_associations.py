import logging
import os
import stat
import tempfile
import unittest
from pathlib import Path
from unittest.mock import patch

import configure_removed_associations as subject

PRESERVED_MODE = 0o600


class MimeappsTestCase(unittest.TestCase):
    def check_equal(self, actual: object, expected: object) -> None:
        if actual != expected:
            self.fail(f"{actual!r} != {expected!r}")


class UpdateRemovedAssociationsTest(MimeappsTestCase):
    SAMPLE_REMOVED_ASSOCIATIONS = {
        "image/png": {"org.pwmt.zathura.desktop"},
        "image/x-adobe-dng": {"org.kde.okular.desktop"},
    }

    def setUp(self) -> None:
        self._patcher = patch.dict(
            subject.__dict__,
            {
                "REMOVED_ASSOCIATIONS": self.SAMPLE_REMOVED_ASSOCIATIONS,
                "REMOVED_ASSOCIATIONS_BY_DESKTOP": {},
            },
        )
        self._patcher.start()

    def tearDown(self) -> None:
        self._patcher.stop()

    def test_creates_removed_associations_section(self) -> None:
        self.check_equal(
            subject.update_removed_associations([]),
            [
                "[Removed Associations]\n",
                "image/png=org.pwmt.zathura.desktop;\n",
                "image/x-adobe-dng=org.kde.okular.desktop;\n",
            ],
        )

    def test_adds_desktop_based_associations(self) -> None:
        with patch.dict(
            subject.__dict__,
            {
                "REMOVED_ASSOCIATIONS_BY_DESKTOP": {
                    "net.puddletag.puddletag.desktop": {
                        "image/x-adobe-dng",
                        "video/mp4",
                    },
                    "org.pwmt.zathura.desktop": {"image/png"},
                },
            },
        ):
            self.check_equal(
                subject.update_removed_associations([]),
                [
                    "[Removed Associations]\n",
                    "image/png=org.pwmt.zathura.desktop;\n",
                    "image/x-adobe-dng=net.puddletag.puddletag.desktop;org.kde.okular.desktop;\n",
                    "video/mp4=net.puddletag.puddletag.desktop;\n",
                ],
            )

    def test_adds_frozenset_desktop_based_associations(self) -> None:
        with patch.dict(
            subject.__dict__,
            {
                "REMOVED_ASSOCIATIONS_BY_DESKTOP": {
                    frozenset(
                        {
                            "group1.desktop",
                            "group2.desktop",
                        }
                    ): {"image/new", "image/png"},
                },
            },
        ):
            self.check_equal(
                subject.update_removed_associations([]),
                [
                    "[Removed Associations]\n",
                    "image/png=group1.desktop;group2.desktop;org.pwmt.zathura.desktop;\n",
                    "image/x-adobe-dng=org.kde.okular.desktop;\n",
                    "image/new=group1.desktop;group2.desktop;\n",
                ],
            )

    def test_replaces_only_managed_removed_associations(self) -> None:
        lines = [
            "[Added Associations]\n",
            "image/png=viewer.desktop;\n",
            "\n",
            "[Removed Associations]\n",
            "# keep this comment\n",
            "image/png=old.desktop;\n",
            "application/pdf=some.desktop;\n",
            "image/x-adobe-dng=old.desktop;other.desktop;\n",
            "\n",
            "[Default Applications]\n",
            "image/png=viewer.desktop;\n",
        ]

        self.check_equal(
            subject.update_removed_associations(lines),
            [
                "[Added Associations]\n",
                "image/png=viewer.desktop;\n",
                "\n",
                "[Removed Associations]\n",
                "# keep this comment\n",
                "image/png=org.pwmt.zathura.desktop;\n",
                "application/pdf=some.desktop;\n",
                "image/x-adobe-dng=org.kde.okular.desktop;\n",
                "\n",
                "[Default Applications]\n",
                "image/png=viewer.desktop;\n",
            ],
        )

    def test_appends_missing_managed_entries_to_existing_section(self) -> None:
        lines = [
            "[Removed Associations]\n",
            "application/pdf=some.desktop;\n",
        ]

        self.check_equal(
            subject.update_removed_associations(lines),
            [
                "[Removed Associations]\n",
                "application/pdf=some.desktop;\n",
                "image/png=org.pwmt.zathura.desktop;\n",
                "image/x-adobe-dng=org.kde.okular.desktop;\n",
            ],
        )

    def test_handles_section_without_trailing_newline(self) -> None:
        lines = [
            "[Removed Associations]\n",
            "application/pdf=some.desktop;",
        ]

        self.check_equal(
            subject.update_removed_associations(lines),
            [
                "[Removed Associations]\n",
                "application/pdf=some.desktop;\n",
                "image/png=org.pwmt.zathura.desktop;\n",
                "image/x-adobe-dng=org.kde.okular.desktop;\n",
            ],
        )

    def test_deduplicates_managed_entries(self) -> None:
        lines = [
            "[Removed Associations]\n",
            "image/png=old.desktop;\n",
            "image/png=older.desktop;\n",
            "image/x-adobe-dng=old.desktop;\n",
        ]

        self.check_equal(
            subject.update_removed_associations(lines),
            [
                "[Removed Associations]\n",
                "image/png=org.pwmt.zathura.desktop;\n",
                "image/x-adobe-dng=org.kde.okular.desktop;\n",
            ],
        )


class WriteAtomicallyTest(MimeappsTestCase):
    def test_preserves_existing_file_mode(self) -> None:
        with tempfile.TemporaryDirectory() as tmp:
            path = Path(tmp) / "mimeapps.list"
            path.write_text("[Removed Associations]\n", encoding="utf-8")
            path.chmod(PRESERVED_MODE)

            subject.write_atomically(path, ["[Removed Associations]\n"])

            self.check_equal(stat.S_IMODE(path.stat().st_mode), PRESERVED_MODE)


class LevelFormatterTest(MimeappsTestCase):
    def test_normal_error_level_uses_err(self) -> None:
        formatter = subject.LevelFormatter(
            "%(display_level)s: %(message)s", subject.LOG_LEVELS
        )
        record = logging.LogRecord(
            "test",
            logging.ERROR,
            __file__,
            0,
            "message",
            (),
            None,
        )

        self.check_equal(formatter.format(record), "ERR: message")

    def test_journal_error_level_uses_priority_and_err(self) -> None:
        formatter = subject.LevelFormatter(
            "%(display_level)s: %(message)s", subject.JOURNAL_LEVELS
        )
        record = logging.LogRecord(
            "test",
            logging.ERROR,
            __file__,
            0,
            "message",
            (),
            None,
        )

        self.check_equal(formatter.format(record), "<3>ERR: message")


class JournalStreamTest(MimeappsTestCase):
    def test_matches_current_file_descriptor(self) -> None:
        with tempfile.TemporaryFile() as stream:
            stream_stat = os.fstat(stream.fileno())
            journal_stream = f"{stream_stat.st_dev}:{stream_stat.st_ino}"

            with patch.dict(os.environ, {"JOURNAL_STREAM": journal_stream}):
                self.check_equal(
                    subject.is_journal_stream(stream.fileno()), expected=True
                )

    def test_rejects_stale_environment_value(self) -> None:
        with (
            tempfile.TemporaryFile() as stream,
            patch.dict(os.environ, {"JOURNAL_STREAM": "1:2"}),
        ):
            self.check_equal(
                subject.is_journal_stream(stream.fileno()), expected=False
            )

    def test_rejects_malformed_environment_value(self) -> None:
        with (
            tempfile.TemporaryFile() as stream,
            patch.dict(os.environ, {"JOURNAL_STREAM": "not-a-stream"}),
        ):
            self.check_equal(
                subject.is_journal_stream(stream.fileno()), expected=False
            )


if __name__ == "__main__":
    unittest.main()
