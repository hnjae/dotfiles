function dash(input)
  local fmt
  if input == "em" then
    return "—" -- em-dash
  elseif input == "en" then
    return "–" -- en-dash
  elseif input == "f" then
    return "‒" -- figure dash
  end

  return "–" -- en-dash (range of value)
end

ime.register_command("d", "dash", "em·en·figure dash")
