-- based on https://askubuntu.com/questions/806349/how-to-quick-input-current-date-time-with-a-quick-word
function LookupDate(input)
  local fmt
  if input == "" then
    fmt = "%Y-%m-%d" -- day
  elseif input == "t" then
    fmt = "%H:%M:%S" -- time
  elseif input == "i" then
    fmt = "%Y-%m-%dT%H:%M:%S%z" -- iso8601
    return os.date(fmt):gsub("([+-]%d%d)(%d%d)$", "%1:%2")
  elseif input == "w" then
    fmt = "%G-W%V-%u" -- weekday formats (iso 8601)
    -- elseif input == "u" then
    --   fmt = "%Y-%m-%dT%H:%M:%SZ" -- utc -- UTC time 이 출력 안됨. `os.datae()`에서
  end
  return os.date(fmt)
end

ime.register_command("dt", "LookupDate", "날짜·시간 입력")
