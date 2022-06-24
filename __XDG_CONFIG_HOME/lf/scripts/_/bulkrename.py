#!/usr/bin/env python3

import sys
from pathlib import Path
import os
from typing import List, Optional
import shutil
import subprocess
from subprocess import CompletedProcess
import tempfile


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


def lf_send():
    lf_id: Optional[str] = os.environ.get("id")
    if lf_id is None:
        return

    lf_send_arg: List[str] = [
        'lf', '-remote', f"\"send {lf_id} load\""
    ]
    subprocess.run(lf_send_arg, check=False)
    lf_send_arg.pop()
    lf_send_arg.append(f"\"send {lf_id} unselect\"")
    subprocess.run(lf_send_arg, check=False)

    # lf_send_arg.pop()
    # lf_send_arg.append(f"\"send {lf_id} echomsg {msg}\"")
    # subprocess.run(lf_send_arg, check=False)

    return


def main(paths: List[Path]) -> int:
    def get_editor() -> str:
        for editor in [
            os.environ.get("EDITOR"),
            "nvim",
            "vim",
            "vi",
            "nano",
            "gedit",
            "kate",
            "kwrite"
        ]:
            if editor and shutil.which(editor) is not None:
                return editor

        raise Exception

    if not paths:
        return 0

    with tempfile.TemporaryFile(mode='w', encoding="UTF-8", prefix="bulkrename") as paths_file:
        # TODO: check '\n' in path <2022-06-05, Hyunjae Kim>
        for path in paths:
            paths_file.write(f"{path}")

    # proc: CompletedProcess = subprocess.run(vimv_arg, check=False)
    # print(vimv_stderr)
    # lf_send()

    return 0


if __name__ == "__main__":
    # Usage: <bulkrename.py> <files>
    sys.exit(main([Path(arg) for arg in sys.argv[1:]]))
