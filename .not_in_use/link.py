#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sys
import subprocess
from pathlib import Path
from typing import Iterable
import shutil
import os

def iter_package() -> Iterable[str]:
    """ Yield stow package. """
    for path in Path.cwd().iterdir():
        if path.is_dir():
            yield path.name

STOW_TARGET = {
    # "$XDG_CONFIG_HOME" = os.environ.get("XDG_CONFIG_HOME"),
}

def get_target():
    xdg_config_home = os.environ.get("XDG_CONFIG_HOME")
    if not xdg_config_home:
        xdg_config_home = str(Path(os.environ["HOME"]).joinpath(".config"))

# STOW_ARG = ("stow", "-v",)
# stow -v --stow --target="$HOME/.config" "XDG_CONFIG_HOME"
def main():
    if not shutil.which("stow"):
        print("stow is not in $PATH.")
        return 1

    for pack in iter_package():
        arg: List[str] = [
            "stow",
            "-v",
            "-t",
        ]

if __name__ == "__main__":
    sys.exit(main())
