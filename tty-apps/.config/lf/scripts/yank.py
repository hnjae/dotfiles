#!/usr/bin/env python3

import locale
import os
import platform
import shutil
import subprocess
import sys
from pathlib import Path
from subprocess import CompletedProcess
from typing import Any, Callable, Dict, List, Optional, Set


class Clipboard:
    """ """

    @staticmethod
    def clips(string: str):
        def get_clipboard_argvs() -> List[List[Any]]:
            # If List starts with True, it will communicate with stdin
            """
            return list of clipboard argv
            """
            x11_commands = {
                "xsel": [
                    [True, "xsel", "-ib"],
                ],
                # "xclip": [
                #     [True, "xclip", "-selection", "clipboard"],
                # ],
            }

            # if platform.system() == "Darwin":
            #     return [["pbcopy", string]]

            session_type: Optional[str] = os.environ.get("XDG_SESSION_TYPE")
            if session_type is None:
                return []

            if session_type.lower() == "x11":
                for interface in ["xsel", "xclip"]:
                    if shutil.which(interface) is None:
                        continue
                    return x11_commands[interface]

            elif session_type == "wayland":
                interface = "wl-copy"
                if shutil.which(interface) is not None:
                    # uid: Optional[int] = os.getuid()
                    return [
                        [False, "wl-copy", string]
                        # [False, "wl-copy", "--seat", seat, string]
                        # for seat in Clipboard._get_seats(uid)
                    ]

            return []

        for command in get_clipboard_argvs():
            if command[0]:
                with subprocess.Popen(
                    command[1:], stdin=subprocess.PIPE
                ) as proc:
                    proc.communicate(
                        input=bytes(
                            string, encoding=locale.getpreferredencoding()
                        )
                    )
            else:
                subprocess.run(command[1:], check=True)

    # @staticmethod
    # def _get_seats(uid: Optional[int] = None) -> Set[str]:
    #     """
    #     Return wayland's seats of user(uid).
    #
    #     if uid is not provided, it will return all seats on system.
    #
    #     :uid: uid
    #     :return: set of seat
    #
    #     $ loginctl
    #     SESSION  UID USER    SEAT  TTY
    #             2 1000 hyunjae seat0 tty2
    #     """
    #
    #     proc: CompletedProcess = subprocess.run(
    #         ["loginctl", "list-sessions"],
    #         capture_output=True,
    #         check=True,
    #         encoding=locale.getpreferredencoding(),
    #     )
    #
    #     seats: Set[str] = set()
    #     for raw_data in proc.stdout.split("\n")[1:-3]:
    #         # data: "       2 1000 hyunjae seat0 tty2"
    #         data = raw_data.strip().split(" ")
    #         if uid is None or int(data[1]) == uid:
    #             seats.add(data[3])
    #     return seats


def yank(mode: str, path: Path) -> str:
    def _parse_paren(string: str):
        start, end = None, None
        for idx, char in enumerate(reversed(string)):
            if end is None and char == ")":
                end = len(string) - idx - 1
            elif end is not None and char == "(":
                start = len(string) - idx - 1
                break

        if start is not None and end is not None:
            return string[start + 1 : end]
        return ""

    yank_modes: Dict[str, Callable] = {
        "stem": lambda p: p.stem,
        "name": lambda p: p.name,
        "dir": lambda p: str(p.parent),
        "path": lambda p: str(p.absolute()),
        "paren": lambda p: _parse_paren(p.name),
    }

    if mode not in yank_modes:
        raise NotImplementedError

    string: str = yank_modes[mode](path)
    Clipboard.clips(string)

    return string


def main(argv: List[str]) -> int:
    if len(argv) != 2:
        return 1

    try:
        cliped_string = yank(argv[0], Path(argv[1]))
        print(f"Saved to clipboard: {cliped_string}")
    except Exception:
        return 1
    return 0


if __name__ == "__main__":
    # sys.exit(main(argv_fixer(sys.argv[1:])))
    # Usage: <type> <strings>
    sys.exit(main(sys.argv[1:]))
