#!/usr/bin/env python3

import sys
from typing import List
import subprocess
from subprocess import CompletedProcess



def main(id: str, argv: List) -> int:
    if not argv:
        return 0

    path:str = " ".join(argv).strip()

    arg = [
        "lf", "-remote", f'send {id} cd "{path}"'
    ]
    proc: CompletedProcess = subprocess.run(arg, check=False)
    print(arg)
    return proc.returncode

if __name__ == "__main__":
    # usage cd.py <id> <path>
    # print(sys.argv)
    sys.exit(main(sys.argv[1], sys.argv[2:]))
