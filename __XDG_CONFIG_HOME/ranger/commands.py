#!/usr/bin/env python
# -*- coding: utf-8 -*-

from __future__ import absolute_import, division, print_function

import codecs
import os
import re
from collections import deque
from pathlib import Path
from typing import Any, List, Optional

import ranger.api
from ranger.api.commands import Command
from ranger.core.linemode import LinemodeBase


class MkCD(Command):
    """
    :mkcd <dirname>

    Creates a directory with the name <dirname> and enters it.
    """

    def execute(self):
        dirname = os.path.join(self.fm.thisdir.path, os.path.expanduser(self.rest(1)))
        if not os.path.lexists(dirname):
            os.makedirs(dirname)

            match = re.search('^/|^~[^/]*/', dirname)
            if match:
                self.fm.cd(match.group(0))
                dirname = dirname[match.end(0):]

            for m in re.finditer('[^/]+', dirname):
                s = m.group(0)
                if s == '..' or (s.startswith('.') and not self.fm.settings['show_hidden']):
                    self.fm.cd(s)
                else:
                    ## We force ranger to load content before calling `scout`.
                    self.fm.thisdir.load_content(schedule=False)
                    self.fm.execute_console('scout -ae ^{}$'.format(s))
        else:
            self.fm.notify("file/directory exists!", bad=True)

# class delete(Command):
#     def execute(self):
#         self.fm.notify("Use trash instead!")
#         pass
class trash(Command):
    """:trash
    Tries to move the selection or the files passed in arguments (if any) to
    the trash, using rifle rules with label "trash".
    The arguments use a shell-like escaping.
    "Selection" is defined as all the "marked files" (by default, you
    can mark files with space or v). If there are no marked files,
    use the "current file" (where the cursor is)
    When attempting to trash non-empty directories or multiple
    marked files, it will require a confirmation.
    """

    allow_abbrev = False
    escape_macros_for_shell = True

    def execute(self):
        import shlex
        from functools import partial

        from ranger.container.file import File

        def is_directory_with_files(path):
            return os.path.isdir(path) \
                    and not os.path.islink(path) \
                    and len(os.listdir(path)) > 0

        if self.rest(1):
            file_names = shlex.split(self.rest(1))
            # Any 가 아니라 ranger.container.file.File 인데 어떻게 해야할지
            # 모르겠음
            files: List[Any] = [File(name) for name in file_names]
            many_files = \
                    (len(files) > 1 or is_directory_with_files(files[0].path))
        else:
            cwd = self.fm.thisdir
            tfile = self.fm.thisfile
            if not cwd or not tfile:
                self.fm.notify("Error: no file selected for deletion!",
                               bad=True)
                return

            files = self.fm.thistab.get_selection()
            # relative_path used for a user-friendly output in the confirmation.
            file_names = [f.relative_path for f in files]
            many_files = \
                    (cwd.marked_items or is_directory_with_files(tfile.path))

        confirm = self.fm.settings.confirm_on_delete

        # always ask
        # if confirm != 'never' and (confirm != 'multiple' or many_files):
        self.fm.ui.console.ask(
                "Confirm trash-ing of: %s (y/N)" % ', '.join(file_names),
                partial(self._question_callback, files),
                ('n', 'N', 'y', 'Y'),
                )
        # else:
        #     # no need for a confirmation, just delete
        #     self.fm.execute_file(files, label='trash')

    def tab(self, tabnum):
        return self._tab_directory_content()

    def _question_callback(self, files, answer):
        if answer in ('y', 'Y'):
            self.fm.execute_file(files, label='trash')


class TrashWithTrace(trash):
    """:TrashWithTrace <fname>

    Tries to move the selection or the files passed in arguments (if any) to
    the trash, using rifle rules with label "trash".
    The arguments use a shell-like escaping.
    "Selection" is defined as all the "marked files" (by default, you
    can mark files with space or v). If there are no marked files,
    use the "current file" (where the cursor is)
    When attempting to trash non-empty directories or multiple
    marked files, it will require a confirmation.

    Create New Empty File
    """
    def _question_callback(self, files, answer):
        if answer in ('y', 'Y'):
            self.fm.execute_file(files, label='trash')

            # 이렇게 하지말고 그냥 ranger 내부 touch 기능 불어일으킬 수 있을까?
            for file in files:
                fname = os.path.join(
                        self.fm.thisdir.path,
                        f"{file.basename_without_extension} DELETED"
                        )
                if not os.path.lexists(fname):
                    open(fname, 'a').close()
                    Path(fname).touch(mode=644)
                else:
                    self.fm.notify("file/directory exists!", bad=True)



class yank(Command):
    """:yank [name|dir|path|stem|paren]

    Copies the file's name (default), directory or path into both the primary X
    selection and the clipboard.
    """

    modes = {
        '': 'basename',
        'stem': 'basename_without_extension',
        'name': 'basename',
        'dir': 'dirname',
        'path': 'path',
    }
    manual_modes = {'paren'}

    def execute(self):
        import subprocess

        def clipboards():
            from ranger.ext.get_executables import get_executables
            clipboard_managers = {
                'xclip': [
                    ['xclip'],
                    ['xclip', '-selection', 'clipboard'],
                ],
                'xsel': [
                    ['xsel'],
                    ['xsel', '-b'],
                ],
                'wl-copy': [
                    ['wl-copy'],
                ],
                'pbcopy': [
                    ['pbcopy'],
                ],
            }
            gui_type: Optional[str] = os.environ.get('XDG_SESSION_TYPE')
            executables = get_executables()
            if gui_type == "x11":
                for manager in ['xsel', 'xclip']:
                    if manager in executables:
                        return clipboard_managers[manager]
            elif gui_type == "wayland":
                manager = 'wl-copy'
                if manager in executables:
                    return clipboard_managers[manager]
            else:
                manager = 'pbcopy'
                if manager in executables:
                    return clipboard_managers[manager]

            return []

        clipboard_commands = clipboards()

        if self.arg(1) == 'paren':
            selection = [self._parse_paren(name) for name in self.get_selection_attr('basename')]
        else:
            mode = self.modes[self.arg(1)]
            selection = self.get_selection_attr(mode)

        new_clipboard_contents = "\n".join(selection)
        for command in clipboard_commands:
            with subprocess.Popen(
                command, universal_newlines=True, stdin=subprocess.PIPE
            ) as process:
                process.communicate(input=new_clipboard_contents)

    def get_selection_attr(self, attr):
        return [getattr(item, attr) for item in
                self.fm.thistab.get_selection()]

    def tab(self, tabnum):
        return (
            self.start(1) + mode for mode
            in sorted(self.modes.keys())
            if mode
        )

    # names = self.get_selection_attr('basename')
    @staticmethod
    def _parse_paren(string: str):
        start, end = None, None
        for idx, char in enumerate(reversed(string)):
            if end is None and char == ")":
                end = len(string) - idx - 1
            elif end is not None and char == "(":
                start = len(string) - idx - 1
                break

        if start is not None and end is not None:
            return string[start+1:end]
        return ""




# @ranger.api.register_linemode
# class MyLinemode(LinemodeBase):
#         name = "sizeshortmtime"
#
#     def filetitle(self, fobj, metadata):
#                 return codecs.encode(fobj.relative_path, "rot_13")
#
#     def infostring(self, fobj, metadata):
#                 raise NotImplementedError
