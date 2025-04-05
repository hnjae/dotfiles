local M = {}

M.is_console = os.getenv("XDG_SESSION_TYPE") == "tty"

return M
