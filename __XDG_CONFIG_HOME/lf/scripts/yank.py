#!/usr/bin/env python3

import sys
import os
import shutil
from typing import List, Optional, Set, Callable, Dict
import subprocess
from subprocess import CompletedProcess
import platform
from pathlib import Path


class Clipboard():
    """

    """

    @staticmethod
    def clips(strings: str):
        def get_clipboard_argvs() -> List[List[str]]:
            """
            return list of clipboard argv
            """
            x11_commands = {
                'xclip': [
                    ['xclip', '-selection', 'clipboard'],
                ],
                'xsel': [
                    ['xsel', '-b'],
                ],
            }

            if platform.system() == "Darwin":
                return [ ["pbcopy"] ]
                # return [["echo",  "rrst", "|", "pbcopy" ]]

            session_type: Optional[str] = os.environ.get('XDG_SESSION_TYPE')
            if session_type == "x11":
                for interface in {'xsel', 'xclip'}:
                    if shutil.which(interface) is not None:
                        return x11_commands[interface]

            elif session_type == "wayland":
                interface = 'wl-copy'
                if shutil.which(interface) is not None:
                    uid: Optional[int] = os.getuid()
                    return [
                        ['wl-copy', '--seat', seat]
                        for seat in Clipboard._get_seats(uid)
                    ]

            return []

        for command in get_clipboard_argvs():
            command.append(strings)
            subprocess.run(
                command, check=True
            )

    @staticmethod
    def _get_seats(uid: Optional[int] = None) -> Set[str]:
        """
        Return wayland's seats of user(uid).

        if uid is not provided, it will return all seats on system.

        :uid: uid
        :return: set of seat

        $ loginctl
        SESSION  UID USER    SEAT  TTY
                2 1000 hyunjae seat0 tty2
        """

        proc: CompletedProcess = subprocess.run(
            ["loginctl", "list-sessions"],
            capture_output=True,
            check=True
        )

        seats: Set[str] = set()
        # TODO: system locale 에서 UTF-8 인지 읽을 것 <2022-06-01, Hyunjae Kim>
        for raw_data in proc.stdout.decode(encoding='UTF-8').split('\n')[1:-3]:
            # data: "       2 1000 hyunjae seat0 tty2"
            data = raw_data.strip().split(' ')
            if uid is None or int(data[1]) == uid:
                seats.add(data[3])
        return seats


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
            return string[start+1:end]
        return ""

    yank_modes: Dict[str, Callable] = {
        'stem': lambda p: p.stem,
        'name': lambda p: p.name,
        'dir': lambda p: str(p.parent),
        'path': lambda p: str(p.absolute()),
        'paren': lambda p: _parse_paren(p.name),
    }

    if mode not in yank_modes:
        raise NotImplementedError

    string:str = yank_modes[mode](path)
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
