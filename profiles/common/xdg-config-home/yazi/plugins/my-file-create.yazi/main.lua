local current_cwd = ya.sync(function()
  return Url(cx.active.current.cwd)
end)

local function warn(content)
  ya.notify({
    title = "Create file",
    content = content,
    timeout = 5,
    level = "warn",
  })
end

local function fail(content)
  ya.notify({
    title = "Create file",
    content = content,
    timeout = 7,
    level = "error",
  })
end

return {
  entry = function()
    local name, event = ya.input({
      title = "Create (file):",
      value = "",
      pos = { "top-center", y = 2, w = 50 },
    })

    if event ~= 1 or not name or name == "" then
      return
    end

    if name:match("[/\\]$") then
      warn("Directories are not allowed here. Use `d` instead.")
      return
    end

    local target = current_cwd():join(name)
    local parent = target.parent
    if not parent then
      fail("Couldn't determine the parent directory.")
      return
    end

    local parent_cha, parent_err = fs.cha(parent, false)
    if not parent_cha then
      if parent_err and parent_err.kind ~= "NotFound" then
        fail("Couldn't inspect the parent directory: " .. tostring(parent_err))
      else
        warn("The parent directory does not exist.")
      end
      return
    end
    if not parent_cha.is_dir then
      warn("The parent path is not a directory.")
      return
    end

    local cha, err = fs.cha(target, false)
    if cha then
      if cha.is_dir then
        warn("A directory with that name already exists.")
      else
        warn("A file with that name already exists.")
      end
      return
    end
    if err and err.kind ~= "NotFound" then
      fail("Couldn't inspect the target path: " .. tostring(err))
      return
    end

    local ok, write_err = fs.write(target, "")
    if not ok then
      fail("Failed to create the file: " .. tostring(write_err))
      return
    end

    ya.emit("reveal", { target })
  end,
}
