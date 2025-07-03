function Uuid()
  local handle = io.popen("uuid7")
  if handle then
    local result = handle:read("*a") -- Read all output
    handle:close()
    -- Trim potential newline characters
    return result:match("^%s*(.-)%s*$")
  end
  return nil -- Command failed or not found
end

ime.register_command("ud", "uuid", "UUID")
