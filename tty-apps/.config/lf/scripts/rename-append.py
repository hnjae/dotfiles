#!/usr/bin/env python3

from typing import Optional, Iterable, List
import subprocess
import sys
import os
from pathlib import Path

def lf_send(id_: str, command: str):
    lf_send_arg = ["lf", "-remote", f"send {id_} {command}"]
    subprocess.run(lf_send_arg, check=True)

    # lf_send_arg.pop()
    # lf_send_arg.append(f"\"send {lf_id} echomsg {msg}\"")
    # subprocess.run(lf_send_arg, check=False)

    return


def main(argv: List[str]) -> int:
    id_: str = argv[0]
    file: Path = Path(argv[1])

    if file.is_dir():
        lf_send(id_, "push :rename<enter>")
        return 0

    command_raw: List[str] = ["push :rename<enter>"]
    command_raw.extend([ "<c-b>" for _ in range(len(file.suffix)) ])
    lf_send(id_, "".join(command_raw))
    return 0

if __name__ == "__main__":
    # Usage:
    # <rename.py> <lf id> <file>
    # Use shell-async in lf
    sys.exit(main(sys.argv[1:]))
