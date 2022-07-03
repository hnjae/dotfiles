#!/usr/bin/env python3

import sys
from pathlib import Path
import os
from typing import List, Optional

def argv_fixer(argv: List[str]) -> List[str]:
    new_argv: List[str] = []

    while argv:
        arg = argv.pop()
        if "\n" in arg:
            new_argv.extend(arg.split("\n"))
        else:
            new_argv.append(arg)

    return new_argv

def main(command: str, argv: Optional[List[str]] = None) -> int:
    def get_lf_files_list() -> Path:
        """
        :returns: Path of ${XDG_DATA_HOME:-$HOME/.local/share}/lf/files
        """
        if 'XDG_DATA_HOME' in os.environ:
            xdg_data_home = os.environ['XDG_DATA_HOME']
        else:
            xdg_data_home = os.environ['HOME']
            xdg_data_home = Path(xdg_data_home).joinpath(".local", "share")

        return Path(xdg_data_home).joinpath('lf', 'files')

    def get_unique_name(path: Path) -> Path:
        """
        :returns: unique name of path
        """

        for i in range(10000):
            if not path.exists():
                return path

            path = path.with_name(f"{path.name}_{i}")

        raise FileExistsError

    try:
        with open(get_lf_files_list(), mode='r', encoding='UTF-8') as f:
            # skip first line
            f.readline()
            paths: List[Path] = [Path(file) for file in f.read().splitlines()]

        cwd: Path = Path.cwd()
        for path in paths:
            if command == "symlink-absolute":
                new_path: Path = get_unique_name(cwd.joinpath(path.name))
                new_path.symlink_to(os.path.abspath(path))
            elif command == "symlink-relative":
                # TODO: cwd 혹은, path 가 symlink 안에 있으면 말썽이다.
                # 애초에 받을 때 뭘로 받았는지 확인할 것. <2022-07-02, Hyunjae Kim>
                new_path: Path = get_unique_name(cwd.joinpath(path.name))
                new_path.symlink_to(os.path.relpath(path, start=cwd))
            # elif command == "mv-to-newfold" and argv and len(argv) == 1:
            #     newfold = Path(argv[0])
            #     if not newfold.exists():
            #         Path(argv[0]).mkdir(mode=0o755, parents=True, exist_ok=False)
            #     if not newfold.is_dir():
            #         raise Exception
            #     new_path: Path = get_unique_name(newfold.joinpath(path.name))
            #     os.rename(path, new_path)
            #     pass

            # TODO: hardlink <2022-06-05, Hyunjae Kim>
            else:
                raise NotImplementedError
    except Exception as exc:
        print(exc)
        # wait for user input. for user to see the error
        input("")
        return 1

    return 0

if __name__ == "__main__":
    # Usage: <.py> <command>

    sys.exit(main(sys.argv[1], argv_fixer(sys.argv[2:])))
