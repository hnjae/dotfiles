local hovered_item = ya.sync(function()
  local hovered = cx.active.current.hovered
  if not hovered then
    return nil
  end

  local target = Url(hovered.url)
  local launch_cwd = hovered.cha.is_dir and Url(target) or target.parent

  return {
    url = target,
    is_dir = hovered.cha.is_dir,
    launch_cwd = launch_cwd and Url(launch_cwd) or Url(cx.active.current.cwd),
  }
end)

local function notify(level, content, timeout)
  ya.notify({
    title = "Open in split",
    content = content,
    timeout = timeout,
    level = level,
  })
end

local function split_flag(direction)
  if direction == "right" then
    return "-h"
  end
  return "-v"
end

local function shell_command(is_dir)
  if is_dir then
    return [[exec yazi "$YAZI_SPLIT_TARGET"]]
  end

  return [[exec "${VISUAL:-${EDITOR:-nvim}}" -- "$YAZI_SPLIT_TARGET"]]
end

return {
  entry = function(_, job)
    local hovered = hovered_item()
    if not hovered then
      notify("warn", "No hovered entry.", 6)
      return
    end

    if os.getenv("TMUX") == nil then
      local term_program = os.getenv("TERM_PROGRAM")
      if term_program == "ghostty" then
        notify("warn", "Ghostty split panes are not controllable from CLI yet. Run Yazi inside tmux for this binding.", 8)
      else
        notify("warn", "This split-open binding currently requires tmux.", 7)
      end
      return
    end

    local direction = job.args[1] == "right" and "right" or "down"
    local status, err = Command("tmux")
      :arg({
        "split-window",
        split_flag(direction),
        "-c",
        tostring(hovered.launch_cwd),
        "-e",
        "YAZI_SPLIT_TARGET=" .. tostring(hovered.url),
        shell_command(hovered.is_dir),
      })
      :status()

    if not status then
      notify("error", "Failed to start tmux split: " .. tostring(err), 8)
      return
    end
    if not status.success then
      notify("error", "tmux split exited with code " .. tostring(status.code) .. ".", 8)
    end
  end,
}
