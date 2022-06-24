#!/usr/bin/env python3

import subprocess
import os
from ranger.api.commands import Command
from ranger.ext.get_executables import get_executables


class FZFSelect(Command):
    """
    :fzf_select
    Find a file using fzf.
    With a prefix argument to select only directories.

    See: https://github.com/junegunn/fzf
    """

    def execute(self):

        if 'fzf' not in get_executables():
            self.fm.notify('Could not find fzf in the PATH.', bad=True)
            return

        fd = None
        if 'fdfind' in get_executables():
            fd = 'fdfind'
        elif 'fd' in get_executables():
            fd = 'fd'

        if fd:
            hidden = ('--hidden' if self.fm.settings.show_hidden else '')
            exclude:str = "--no-ignore-vcs --exclude '.git' " \
                "--exclude '*.py[co]' --exclude '__pycache__'"
            only_directories = ('--type directory' if self.quantifier else '')
            fzf_default_command = f'{fd} --follow {hidden} " \
                    f"{exclude} {only_directories} --color=always'
        else:
            hidden = ('-false' if self.fm.settings.show_hidden else r"-path '*/\.*' -prune")
            exclude = r"\( -name '\.git' -o -iname '\.*py[co]' -o -fstype 'dev' -o -fstype 'proc' \) -prune"
            only_directories = ('-type d' if self.quantifier else '')
            fzf_default_command = f'find -L . -mindepth 1 {hidden}" \
                    f" -o {exclude} -o {only_directories} -print | cut -b3-'

        env = os.environ.copy()
        env['FZF_DEFAULT_COMMAND'] = fzf_default_command
        env['FZF_DEFAULT_OPTS'] = '--height=40% --layout=reverse --ansi --preview="{}"'.format('''
            (
                batcat --color=always {} ||
                bat --color=always {} ||
                cat {} ||
                tree -ahpCL 3 -I '.git' -I '*.py[co]' -I '__pycache__' {}
            ) 2>/dev/null | head -n 100
        ''')

        fzf = self.fm.execute_command('fzf --no-multi', env=env,
                                      universal_newlines=True, stdout=subprocess.PIPE)
        stdout, _ = fzf.communicate()
        if fzf.returncode == 0:
            selected = os.path.abspath(stdout.strip())
            if os.path.isdir(selected):
                self.fm.cd(selected)
            else:
                self.fm.select_file(selected)

#-------------------------------
class FZFCD(Command):
    """
    :fzf_select
    Find a file using fzf.
    With a prefix argument to select only directories.

    See: https://github.com/junegunn/fzf
    """

    def execute(self):

        if 'fzf' not in get_executables():
            self.fm.notify('Could not find fzf in the PATH.', bad=True)
            return

        fd_exe = None
        if 'fdfind' in get_executables():
            fd_exe = 'fdfind'
        elif 'fd' in get_executables():
            fd_exe = 'fd'
        fd_exe = 'fd'

        if fd_exe:
            hidden = ('--hidden' if self.fm.settings.show_hidden else '')
            exclude:str = "--no-ignore-vcs --exclude '.git' " \
                    "--exclude '*.py[co]' --exclude '__pycache__'"
            fzf_default_command = f'{fd_exe} --type d --follow {hidden} {exclude} --color=always'
        else:
            self.fm.notify('Could not find fd|fdfind in the PATH.', bad=True)
            return

        env = os.environ.copy()
        env['FZF_DEFAULT_COMMAND'] = fzf_default_command
        env['FZF_DEFAULT_OPTS'] = '--height=40% --layout=reverse --ansi --preview="{}"'.format('''
            (
                tree -ahpCL 3 -I '.git' -I '*.py[co]' -I '__pycache__' {} ||
                bat --color=always {}
            ) 2>/dev/null | head -n 100
        ''')

        fzf = self.fm.execute_command('fzf --no-multi', env=env,
                                      universal_newlines=True,
                                      stdout=subprocess.PIPE)
        stdout, _ = fzf.communicate()
        if fzf.returncode == 0:
            selected = os.path.abspath(stdout.strip())
            if os.path.isdir(selected):
                self.fm.cd(selected)
            else:
                self.fm.select_file(selected)


# vim: set fileencoding=utf-8
