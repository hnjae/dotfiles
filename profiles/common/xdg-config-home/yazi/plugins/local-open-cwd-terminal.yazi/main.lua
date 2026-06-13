local current_cwd = ya.sync(function()
  return Url(cx.active.current.cwd)
end)

local function notify(level, content, timeout)
  ya.notify({
    title = "Open terminal",
    content = content,
    timeout = timeout,
    level = level,
  })
end

local function split_tmux(cwd)
  local status, err = Command("tmux"):arg({ "split-window", "-v", "-c", cwd }):status()
  if not status then
    return false, err
  end
  if not status.success then
    return false, "tmux split exited with code " .. tostring(status.code) .. "."
  end

  return true
end

local function terminal_launchers(cwd)
  return {
    { cmd = "xdg-terminal-exec", args = { "--dir=" .. cwd } },
    { cmd = os.getenv("TERMINAL") },
    { cmd = os.getenv("TERM_PROGRAM") },
    { cmd = "ghostty" },
    { cmd = "alacritty" },
    { cmd = "konsole" },
    { cmd = "kitty" },
    { cmd = "foot" },
    { cmd = "gnome-terminal" },
    { cmd = "xfce4-terminal" },
    { cmd = "x-terminal-emulator" },
  }
end

-- ERROR: DOES NOT WORK <2026-04-12>
local function open_terminal(cwd)
  local seen = {}
  local last_err = nil

  for _, launcher in ipairs(terminal_launchers(cwd)) do
    local cmd = launcher.cmd
    if cmd and cmd ~= "" and not seen[cmd] then
      seen[cmd] = true

      local args = { "-f", cmd }
      if launcher.args then
        for _, arg in ipairs(launcher.args) do
          args[#args + 1] = arg
        end
      end

      local child, err = Command("setsid"):arg(args):cwd(cwd):spawn()
      if child then
        return true
      end
      last_err = err

      local command = Command(cmd):cwd(cwd)
      if launcher.args then
        command:arg(launcher.args)
      end

      child, err = command:spawn()
      if child then
        return true
      end
      last_err = err
    end
  end

  return false, last_err
end

return {
  entry = function()
    local cwd = current_cwd()
    if not cwd then
      notify("warn", "No current directory.", 6)
      return
    end

    cwd = tostring(cwd)

    if os.getenv("TMUX") ~= nil then
      local ok, err = split_tmux(cwd)
      if ok then
        return
      end

      notify("warn", "tmux split failed, opening a new terminal instead: " .. tostring(err), 7)
    end

    local ok, err = open_terminal(cwd)
    if ok then
      return
    end

    notify("error", "Failed to open a terminal: " .. tostring(err), 8)
  end,
}
