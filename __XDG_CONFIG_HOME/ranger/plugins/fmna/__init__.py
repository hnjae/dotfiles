#!/usr/bin/env python3

import subprocess
import os
from ranger.api.commands import Command
from ranger.ext.get_executables import get_executables


class FMNa(Command):
    def execute(self):
        from ranger.ext.get_executables import get_executables
        import subprocess
        if 'fmna' not in get_executables():
            self.fm.notify('Could not find fmna in the PATH.', bad=True)
            return

        proc = self.fm.execute_command('fmna', universal_newlines=True, stdout=subprocess.PIPE)

        stdout, _ = proc.communicate()
        if proc.returncode == 0:
            pass
            selected = os.path.abspath(stdout.strip())
            if os.path.isdir(selected):
                self.fm.cd(selected)
            else:
                self.fm.select_file(selected)
        return
