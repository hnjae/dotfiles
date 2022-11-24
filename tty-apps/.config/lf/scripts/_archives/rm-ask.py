#!/usr/bin/env python3

import sys
from typing import List
import tty, termios
import subprocess
import shutil

def readchar():
    # copied from https://github.com/magmax/python-readchar
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


def main(argv: List) -> int:
    if len(argv) == 0:
        return 0

    print("Confirm deleting of:", file=sys.stderr)
    for file in argv:
        print(f"\t“{file}”", file=sys.stderr)

    print("(y/Any)", file=sys.stderr)
    run: str = readchar()
    print(run)

    if run != "y":
        print("Not deleting any files.", file=sys.stderr)
        return 0

    proc_arg = [ "rm", "-r" , "--" ]
    proc_arg.extend(argv)
    proc = subprocess.run(proc_arg, check=False)
    return proc.returncode

    # for arg in argv:
    #     shutil.rmtree(arg)

if __name__ == "__main__":
    sys.exit(main(argv_fixer(sys.argv[1:])))
