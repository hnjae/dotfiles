#!/usr/bin/env python3

import sys
from pathlib import Path
import os
from typing import List, Optional, Iterable
import shutil
import subprocess
from subprocess import CompletedProcess

def argv_to_paths(argv: List[str]) -> List[Path]:
    new_argv: List[Path] = []

    while argv:
        arg = argv.pop()
        if "\n" in arg:
            for arg_i in arg.split("\n"):
                if not arg_i:
                    continue
                new_argv.append(Path(arg_i))
        elif arg:
            new_argv.append(Path(arg))

    return new_argv

def lf_send(commands: Iterable[str]):
    lf_id: Optional[str] = os.environ.get("id")
    if lf_id is None:
        return

    for command in commands:
        lf_send_arg = ["lf", "-remote", f"send {lf_id} {command}"]
        subprocess.run(lf_send_arg, check=False)

    # lf_send_arg.pop()
    # lf_send_arg.append(f"\"send {lf_id} echomsg {msg}\"")
    # subprocess.run(lf_send_arg, check=False)

    return

def main(paths: List[Path]) -> int:
    if not paths:
        return 0

    bulkrename_arg: List[str] = ["bulkrename"]
    cwd:Path = Path().cwd()

    for path in paths:
        # path is fullpath (provided by lf)
        if cwd == path.parent:
            bulkrename_arg.append(path.name)
        else:
            bulkrename_arg.append(os.path.relpath(path, start=cwd))

    proc: CompletedProcess = subprocess.run(bulkrename_arg, stderr=subprocess.PIPE, check=False)
    msg = proc.stderr.decode(encoding='UTF-8').strip()
    lf_send(["load", "unselect", "reload", f"echo {msg}"])

    return proc.returncode

if __name__ == "__main__":
    # Usage: <.py> <files>

    RENAMER = 'bulkrename'
    if shutil.which(RENAMER) is None:
        print("{RENAMER} is not installed.", file=sys.stderr)
        sys.exit(1)

    sys.exit( main(argv_to_paths(sys.argv[1:])))
