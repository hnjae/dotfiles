function Uuid()
  local handle = io.popen("uuidgen")
  if handle then
    local result = handle:read("*a") -- Read all output
    handle:close()
    -- Trim potential newline characters
    return result:match("^%s*(.-)%s*$")
  end
  return nil -- Command failed or not found
end

ime.register_command("ud4", "uuid4", "UUIDv4")
