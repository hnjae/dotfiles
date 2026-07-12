#!/usr/bin/env python3

import logging
import os
import stat
import tempfile
from collections.abc import Iterable
from contextlib import suppress
from pathlib import Path

DesktopName = str | frozenset[str]


REMOVED_ASSOCIATIONS: dict[str, set[str]] = {
    "image/x-adobe-dng": {
        "org.gnome.Loupe.desktop",  # not supported 2026-05-17
        "com.interversehq.qView.desktop",  # poorly supported 2026-05-17
    },
    "image/heic-sequence": {
        "org.gnome.Loupe.desktop",  # not supported 2026-05-17
        "org.gimp.GIMP.desktop",  # not supported 2026-05-17
    },
    "image/svg+xml": {
        "org.kde.kwrite.desktop",  # Editors
        "dev.zed.Zed.desktop",  # Editors
        "nvim.desktop",  # Editors
    },
    "application/pdf": {
        "org.gimp.GIMP.desktop",
        "org.inkscape.Inkscape.desktop",
        "org.libreoffice.LibreOffice.draw.desktop",
    },
}
REMOVED_ASSOCIATIONS_BY_DESKTOP: dict[DesktopName, set[str]] = {
    "onlyoffice-desktopeditors.desktop": {
        "application/epub",
        "application/x-fictionbook+xml",
        "application/pdf",
        "text/markdown",
        "text/plain",
        # .desktop 에는 없으나 association 목록에 뜸:
        "application/yaml",  # <2026-06-21>
        "image/svg+xml",  #  <2026-05-10>
    },
    "com.collaboraoffice.Office.desktop": {
        "application/pdf",
    },
    frozenset(
        {
            # Browsers
            "app.zen_browser.zen.desktop",
            "brave-browser.desktop",
            "com.brave.Browser.desktop",
            "com.google.Chrome.desktop",
            "org.chromium.Chromium.desktop",
        }
    ): {
        "application/pdf",
        "image/gif",
        "image/jpeg",
        "image/png",
        "image/svg+xml",  # .desktop 에는 없으나 association 목록에 뜸. <2026-05-10>
        "image/webp",
    },
    frozenset(
        {
            # 동일 백엔드 사용 (qtimage/kdeimageformats):
            "org.kde.gwenview.desktop",
            "com.interversehq.qView.desktop",
        }
    ): {
        "image/apng",  # 2026-05-04 기준 렌더링 잘 안됨
        "image/x-adobe-dng",  # 2026-05-04 기준 렌더링 잘 안됨
        "image/svg+xml",  # 2026-05-04 기준 렌더링 잘 안됨
        "image/heic-sequence",  # not supported 2026-05-17
    },
    "org.kde.ark.desktop": {
        # .desktop 에는 없으나 association 목록에 뜸. <2026-05-10>
        "application/vnd.oasis.opendocument.text",
        "application/vnd.oasis.opendocument.spreadsheet",
        "application/vnd.oasis.opendocument.database",
    },
    "org.pwmt.zathura-pdf-mupdf.desktop": {
        "image/svg+xml",
        "image/jpeg",
        "image/png",
        "image/bmp",
        "image/x-bmp",
        "image/tiff",
        "image/tiff-fx;",
    },
    frozenset(
        {
            # 비슷한 류
            "org.pwmt.zathura-cb.desktop",
            "com.yacreader.YACReader.desktop",
        }
    ): {
        "application/vnd.oasis.opendocument.spreadsheet",
        "application/x-7z-compressed",
        "application/x-rar",
        "application/x-tar",
        "application/zip",
        "inode/directory",
    },
    "top.akizip.akizip": {
        # dolphin 의 Association 목록에 뜨나, 열면 zip 파일 취급도 못함. <2026-06-17>
        "application/vnd.oasis.opendocument.spreadsheet"
    },
    "net.puddletag.puddletag.desktop": {
        "inode/directory",
        "video/mp4",
        "video/x-m4v",
        "video/x-ms-asf",
        "video/x-ms-wmv",
    },
    "org.musicbrainz.Picard.desktop": {
        "video/x-ms-asf",
        "video/x-ms-wmv",  # .desktop 에는 없으나 association 목록에 뜸. <2026-05-14>
        "video/x-theora",
        "video/x-wmv",
    },
    "org.kde.okular.desktop": {
        "application/x-cbr",
        "application/x-cbt",
        "application/x-cbz",
        "image/bmp",
        "image/fax-g3",
        "image/g3fax",
        "image/gif",
        "image/jp2",
        "image/jpeg",
        "image/png",
        "image/tiff",
        "image/vnd.djvu",
        "image/x-adobe-dng",  # .desktop 에는 없으나 association 목록에 뜸. <2026-05-17>
        "image/x-bzeps",
        "image/x-dds",
        "image/x-eps",
        "image/x-exr",
        "image/x-gzeps",
        "image/x-hdr",
        "image/x-ico",
        "image/x-pcx",
        "image/x-portable-bitmap",
        "image/x-portable-graymap",
        "image/x-portable-pixmap",
        "image/x-psd",
        "image/x-rgb",
        "image/x-tga",
        "image/x-xbitmap",
        "image/x-xcf",
        "image/x-xpixmap",
        "text/plain",
        "video/x-mng",
    },
    "com.github.jeromerobert.pdfarranger.desktop": {
        "application/postscript",
        "image/bmp",
        "image/gif",
        "image/jp2",
        "image/jpeg",
        "image/jpg",
        "image/png",
        "image/tiff",
        "image/vnd.zbrush.pcx",
        "image/x-adobe-dng",  # .desktop 에는 없으나 association 목록에 뜸. <2026-05-17>
        "image/x-bmp",
        "image/x-gray",
        "image/x-ico",
        "image/x-icon",
        "image/x-pcx",
        "image/x-png",
        "image/x-portable-pixmap",
    },
    "com.github.flxzt.rnote.desktop": {
        "application/pdf",
        "image/jpeg",
        "image/png",
        "image/svg+xml",
    },
}

SECTION = "Removed Associations"
SECTION_HEADER = f"[{SECTION}]"
LOG_FORMAT = "[%(asctime)s] %(display_level)s: %(message)s"
LOG_DATE_FORMAT = "%Y-%m-%dT%H:%M:%S%z"
JOURNAL_LOG_FORMAT = "%(display_level)s: %(message)s"
LOG_LEVELS = {
    logging.CRITICAL: "CRIT",
    logging.ERROR: "ERR",
    logging.WARNING: "WARNING",
    logging.INFO: "INFO",
    logging.DEBUG: "DEBUG",
}
JOURNAL_LEVELS = {
    logging.CRITICAL: "<2>CRIT",
    logging.ERROR: "<3>ERR",
    logging.WARNING: "<4>WARNING",
    logging.INFO: "<6>INFO",
    logging.DEBUG: "<7>DEBUG",
}

LOGGER = logging.getLogger(__name__)


class LevelFormatter(logging.Formatter):
    def __init__(
        self, fmt: str, level_names: dict[int, str], datefmt: str | None = None
    ) -> None:
        super().__init__(fmt, datefmt=datefmt)
        self.level_names = level_names

    def format(self, record: logging.LogRecord) -> str:
        record.display_level = self.level_names.get(
            record.levelno, record.levelname
        )
        return super().format(record)


def configure_logging() -> None:
    handler = logging.StreamHandler()

    if is_journal_stream(handler.stream.fileno()):
        handler.setFormatter(
            LevelFormatter(JOURNAL_LOG_FORMAT, JOURNAL_LEVELS)
        )
        logging.basicConfig(level=logging.INFO, handlers=[handler])
        return

    handler.setFormatter(
        LevelFormatter(LOG_FORMAT, LOG_LEVELS, datefmt=LOG_DATE_FORMAT)
    )
    logging.basicConfig(
        level=logging.INFO,
        handlers=[handler],
    )


def is_journal_stream(fd: int) -> bool:
    journal_stream = os.environ.get("JOURNAL_STREAM")
    if journal_stream is None:
        return False

    try:
        journal_dev, journal_ino = (
            int(part) for part in journal_stream.split(":", 1)
        )
        fd_stat = os.fstat(fd)
    except (OSError, ValueError):
        return False

    return fd_stat.st_dev == journal_dev and fd_stat.st_ino == journal_ino


def config_home() -> Path:
    configured = os.environ.get("XDG_CONFIG_HOME")
    if configured:
        return Path(configured).expanduser()
    return Path.home() / ".config"


def is_section_header(line: str) -> bool:
    stripped = line.strip()
    return stripped.startswith("[") and stripped.endswith("]")


def section_name(line: str) -> str | None:
    if not is_section_header(line):
        return None
    return line.strip()[1:-1]


def entry_key(line: str) -> str | None:
    stripped = line.strip()
    if not stripped or stripped.startswith(("#", ";")) or "=" not in stripped:
        return None
    return stripped.split("=", 1)[0].strip()


def association_line(mime_type: str, desktop_ids: Iterable[str]) -> str:
    return f"{mime_type}={';'.join(sorted(desktop_ids))};\n"


def merged_removed_associations() -> dict[str, set[str]]:
    merged: dict[str, set[str]] = {
        mime_type: set(desktop_ids)
        for mime_type, desktop_ids in REMOVED_ASSOCIATIONS.items()
    }

    for desktop_key, mime_types in REMOVED_ASSOCIATIONS_BY_DESKTOP.items():
        desktop_names = (
            (desktop_key,)
            if isinstance(desktop_key, str)
            else tuple(desktop_key)
        )
        for mime_type in sorted(mime_types):
            merged.setdefault(mime_type, set()).update(desktop_names)

    return merged


def managed_association_lines() -> dict[str, str]:
    return {
        mime_type: association_line(mime_type, desktop_ids)
        for mime_type, desktop_ids in merged_removed_associations().items()
    }


def update_removed_associations(lines: list[str]) -> list[str]:
    desired = managed_association_lines()
    seen: set[str] = set()
    found_section = False
    in_section = False
    result: list[str] = []

    for line in lines:
        current_section = section_name(line)
        if current_section is not None:
            if in_section:
                append_missing_entries(result, desired, seen)
                in_section = False

            if current_section == SECTION:
                found_section = True
                in_section = True

            result.append(line)
            continue

        if in_section:
            key = entry_key(line)
            if key in desired:
                if key not in seen:
                    result.append(desired[key])
                    seen.add(key)
                continue

        result.append(line)

    if in_section:
        append_missing_entries(result, desired, seen)

    if not found_section:
        append_new_section(result, desired)

    return result


def append_missing_entries(
    result: list[str], desired: dict[str, str], seen: set[str]
) -> None:
    missing = [key for key in desired if key not in seen]
    if missing and result and not result[-1].endswith("\n"):
        result[-1] = f"{result[-1]}\n"

    for key in missing:
        result.append(desired[key])
        seen.add(key)


def append_new_section(result: list[str], desired: dict[str, str]) -> None:
    if result and result[-1] != "\n":
        if not result[-1].endswith("\n"):
            result[-1] = f"{result[-1]}\n"
        result.append("\n")

    result.append(f"{SECTION_HEADER}\n")
    result.extend(desired.values())


def write_atomically(path: Path, lines: list[str]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    mode = stat.S_IMODE(path.stat().st_mode) if path.exists() else 0o644
    fd, tmp_name = tempfile.mkstemp(
        dir=path.parent, prefix=f".{path.name}.", text=True
    )
    tmp_path = Path(tmp_name)

    try:
        with os.fdopen(fd, "w", encoding="utf-8", newline="") as tmp:
            tmp.writelines(lines)
        tmp_path.chmod(mode)
        tmp_path.replace(path)
    except Exception:
        with suppress(FileNotFoundError):
            tmp_path.unlink()
        raise


def main() -> None:
    configure_logging()

    path = config_home() / "mimeapps.list"
    LOGGER.info("Configuring removed MIME associations in %s", path)

    lines = (
        path.read_text(encoding="utf-8").splitlines(keepends=True)
        if path.exists()
        else []
    )
    updated = update_removed_associations(lines)

    if updated != lines:
        write_atomically(path, updated)
        LOGGER.info(
            "Updated %s with %d managed association(s)",
            path,
            len(merged_removed_associations()),
        )
    else:
        LOGGER.info("No changes needed for %s", path)


if __name__ == "__main__":
    main()
