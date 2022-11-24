#!/usr/bin/env python3

import platform
import shutil
import subprocess
import sys
import termios
import tty
from pathlib import Path
from subprocess import CompletedProcess
from typing import Dict, List


class Color:
    """
    class of color
    """

    PURPLE = "\033[95m"
    CYAN = "\033[96m"
    DARKCYAN = "\033[36m"
    BLUE = "\033[94m"
    GREEN = "\033[92m"
    YELLOW = "\033[93m"
    RED = "\033[91m"
    BOLD = "\033[1m"
    UNDERLINE = "\033[4m"
    END = "\033[0m"


def readchar():
    # copied from https://stackoverflow.com/questions/510357/how-to-read-a-single-character-from-the-user
    fd = sys.stdin.fileno()
    old_settings = termios.tcgetattr(fd)
    try:
        tty.setraw(sys.stdin.fileno())
        ch = sys.stdin.read(1)
    finally:
        termios.tcsetattr(fd, termios.TCSADRAIN, old_settings)
    return ch


def argv_fixer(argv: List[str]) -> List[str]:
    new_argv: List[str] = []

    while argv:
        arg = argv.pop()
        if "\n" in arg:
            new_argv.extend(arg.split("\n"))
        else:
            new_argv.append(arg)

    return new_argv


def create_trace(argv: List[str]) -> int:
    def rm_excute_permission(file: Path):
        mode: int = file.stat().st_mode & 0o777

        new_mode: int = 0
        for i in range(3):
            s_mode = (mode & (0o7 << (3 * i))) >> (3 * i)
            if s_mode in {1, 3, 5, 7}:
                s_mode -= 1
            new_mode += s_mode << (3 * i)

        if new_mode != mode:
            file.chmod(new_mode)
        return

    for arg in argv:
        path: Path = Path(arg)
        if len(path.suffix) <= 3 and path.is_file():
            trace_name: str = path.stem
        else:
            trace_name = path.name
        trace_name += " DELETED"

        trace_path: Path = path.with_name(trace_name)

        if not trace_path.exists():
            trace_path.touch(mode=0o644)
            shutil.copystat(path, trace_path)
            rm_excute_permission(trace_path)

    return 0


COMMANDS_DICT: Dict = {
    # command: (-ing 문자열, subprocess-arg, Function )
    "trash": ("trashing", ["trash-put", "--"], None),
    "delete": ("deleting", ["rm", "-rf", "--"], None),
    "rmdir": ("rmdir-ing", ["rmdir", "--"], None),
    "trash-with-trace-file": ("trashing", ["trash-put", "--"], create_trace),
}

if platform.system() == "Darwin":
    COMMANDS_DICT["trash"] = ("trashing", ["trash", "--"], None)


def main(command: str, argv: List[str]) -> int:
    def print_files(argv: List[str]):

        cwd: Path = Path().cwd()
        for file in argv:
            p_file = Path(file)
            if cwd == p_file.parent:
                print(f"\t{p_file.name}", file=sys.stderr)
            elif p_file.is_relative_to(cwd):
                print(f"\t{p_file.relative_to(cwd)}", file=sys.stderr)
            else:
                print(f"\t{file}", file=sys.stderr)

    if len(argv) == 0:
        return 0

    if command not in COMMANDS_DICT:
        return 1

    ing_str, exe_arg, func = COMMANDS_DICT[command]

    print(
        f"Confirm {Color.BLUE}{Color.BOLD}{ing_str}{Color.END} of:",
        file=sys.stderr,
    )
    print_files(argv)

    print("(y/Any)", file=sys.stderr)
    run: str = readchar()
    print(run)

    if run != "y":
        print(f"Not {ing_str} any files.", file=sys.stderr)
        print("Press any key to continue", file=sys.stderr)
        readchar()
        return 0

    if func:
        func(argv)

    exe_arg.extend(argv)
    proc: CompletedProcess = subprocess.run(exe_arg, check=False)

    return proc.returncode


if __name__ == "__main__":
    # Usage: <.py> <command> <files>
    # if len(sys.argv) <= 2 :
    #     sys.exit(1)

    sys.exit(main(sys.argv[1], argv_fixer(sys.argv[2:])))
