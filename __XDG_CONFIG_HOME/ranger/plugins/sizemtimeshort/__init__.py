# vim: set fileencoding=utf-8

from ranger.api import register_linemode
from ranger.core.linemode import LinemodeBase
from ranger.ext.human_readable import human_readable
from datetime import datetime
from ranger.ext import spawn

@register_linemode
class SizeMtimeShortLinemode(LinemodeBase):
    name = "sizemtimeshort"

    def filetitle(self, fobj, _):
        return fobj.relative_path

    def infostring(self, fobj, _):
        if fobj.stat is None:
            return '?'
        return "%s %s" % (
                human_readable(fobj.size),
                datetime.fromtimestamp(
                    fobj.stat.st_mtime
                    ).strftime("%y-%m-%d")
                )
