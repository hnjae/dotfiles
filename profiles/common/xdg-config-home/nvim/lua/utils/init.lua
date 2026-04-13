local M = {}

M.use_icons = not (os.getenv("XDG_SESSION_TYPE") == "tty" and os.getenv("SSH_TTY") == nil)

return M
