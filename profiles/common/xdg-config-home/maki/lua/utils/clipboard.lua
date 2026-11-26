-- SPDX-License-Identifier: AGPL-3.0-or-later
-- SPDX-FileCopyrightText: 2022-2026 KIM Hyunjae

-- Clipboard writes for commands. Maki exposes no clipboard in its Lua API: the
-- native one in the app serves Ctrl+V and Ctrl+C only. So this tries whatever
-- connection the machine actually has, in order: the Wayland clipboard daemon,
-- kitty's OSC 5522, then OSC 52 on the terminal itself.
--
-- Only wl-copy reports a status. OSC 5522 asks the terminal to answer on the
-- pty, which maki's renderer owns, and OSC 52 is fire-and-forget by design, so
-- the caller must report which backend ran rather than that the copy worked.
--
-- Every maki.* reference stays inside a function, so this file loads under a
-- plain `lua` for the base64 test.

local M = {}

local ALPHABET = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
local ESC = "\27"
local BEL = "\7"
local ST = "\27\\"

local function enc6(v)
  return ALPHABET:sub(v + 1, v + 1)
end

-- Pure arithmetic: Luau has no bitwise operators and no string.pack, and bit32
-- exists in neither plain lua 5.4 nor luajit.
function M.base64(s)
  local out = {}
  local n = #s
  local i = 1
  while i <= n do
    local b1 = s:byte(i)
    local b2 = s:byte(i + 1)
    local b3 = s:byte(i + 2)
    local v = b1 * 65536 + (b2 or 0) * 256 + (b3 or 0)
    out[#out + 1] = enc6(math.floor(v / 262144) % 64)
    out[#out + 1] = enc6(math.floor(v / 4096) % 64)
    out[#out + 1] = b2 and enc6(math.floor(v / 64) % 64) or "="
    out[#out + 1] = b3 and enc6(v % 64) or "="
    i = i + 3
  end
  return table.concat(out)
end

local function shell_quote(value)
  return "'" .. value:gsub("'", "'\\''") .. "'"
end

local function write_terminal(payload)
  local ok, err = maki.fs.write("/dev/tty", payload)
  if not ok then
    -- A job child is setsid'd and has no controlling terminal, so /dev/tty can
    -- be missing even though maki itself has one.
    ok, err = maki.fs.write("/dev/stdout", payload)
  end
  return ok, err
end

local function via_wl_copy(text)
  -- wl-copy forks a child that keeps serving the selection, and that child
  -- inherits whatever fd it is given. Leaving stdout and stderr attached would
  -- keep maki's job open until the clipboard changes owner, so both go to
  -- /dev/null and the exit status is the only signal we keep. stdin stays on
  -- the pipe: it is the clipboard payload.
  local cmd = "printf %s " .. shell_quote(text) .. " | wl-copy >/dev/null 2>&1"
  local id, err = maki.fn.jobstart(cmd, {
    scope = "plugin",
    on_exit = function(_, code)
      if code ~= 0 then
        maki.notify("clipboard: wl-copy exited with status " .. tostring(code), "error")
      end
    end,
  })
  if not id then
    return false, err
  end
  return true
end

-- OSC 5522 write: a start packet, one wdata packet per chunk of at most 4096
-- raw bytes, then a wdata packet with no payload to end transmission.
--
-- Padding is checked on the concatenation of the chunks, so chunks are cut at
-- 4092 raw bytes (a multiple of 3): every chunk but the last encodes without
-- padding, and the last carries the only padding.
local function via_kitty(text)
  local packets = { ESC .. "]5522;type=write" .. ST }
  local i = 1
  repeat
    local chunk = text:sub(i, i + 4091)
    i = i + 4092
    packets[#packets + 1] = ESC .. "]5522;type=wdata:mime=text/plain;" .. M.base64(chunk) .. ST
  until i > #text
  packets[#packets + 1] = ESC .. "]5522;type=wdata" .. ST
  return write_terminal(table.concat(packets))
end

local function via_osc52(text)
  return write_terminal(ESC .. "]52;c;" .. M.base64(text) .. BEL)
end

function M.copy(text)
  local wayland = maki.uv.os_getenv("WAYLAND_DISPLAY")
  if wayland and wayland ~= "" and maki.fn.executable("wl-copy") then
    local ok, err = via_wl_copy(text)
    if not ok then
      return nil, "wl-copy: " .. tostring(err)
    end
    return "wl-copy"
  end

  local kitty = maki.uv.os_getenv("KITTY_WINDOW_ID")
  if kitty and kitty ~= "" then
    local ok, err = via_kitty(text)
    if not ok then
      return nil, "OSC 5522: " .. tostring(err)
    end
    return "kitty"
  end

  local ok, err = via_osc52(text)
  if not ok then
    return nil, "OSC 52: " .. tostring(err)
  end
  return "osc52"
end

return M
