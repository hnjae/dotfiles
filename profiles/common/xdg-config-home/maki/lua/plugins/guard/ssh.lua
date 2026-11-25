-- SPDX-License-Identifier: AGPL-3.0-or-later
-- SPDX-FileCopyrightText: 2022-2026 KIM Hyunjae

-- Ask before an `ssh` call that is not the pre-approved `agent@` form.
--
-- Bash default is "allow", so an `ssh` line runs the moment the model writes
-- it, and a deny rule would answer for the user instead of asking. This layer
-- raises the prompt for every destination but the trusted one.
--
-- The command is split at the shell separators, so `ssh` is recognised where
-- the shell would start a command: after `;`, `&&`, `|`, `(`, or a backtick,
-- and behind a wrapper such as `timeout 5`, `env FOO=1`, or `bash -c`. The
-- split ignores quoting, so a quoted semicolon can cut one command in two:
-- that costs a prompt, never a silent call.

local ALLOWED_USER = "agent"

-- Run the command that follows them, and keep looking for its name.
local WRAPPERS = {
  ["command"] = true,
  ["env"] = true,
  ["exec"] = true,
  ["nice"] = true,
  ["nohup"] = true,
  ["setsid"] = true,
  ["stdbuf"] = true,
  ["time"] = true,
  ["timeout"] = true,
  ["xargs"] = true,
}

-- Run the command that follows them as well, but their own name is the one
-- the shell sees, so the next word is a command word too.
local SHELLS = {
  ["bash"] = true,
  ["dash"] = true,
  ["eval"] = true,
  ["ksh"] = true,
  ["sh"] = true,
  ["zsh"] = true,
}

local function is_separator(word)
  return #word == 1 and word:find("[;|&()<>\n`]") ~= nil
end

local function unquote(word)
  return (word:gsub("^['\"]+", ""):gsub("['\"]+$", ""))
end

-- The trusted form carries the destination and nothing else. An option such as
-- `-o ProxyCommand=...` runs a local command, and `-F` swaps the config.
local function plain_destination(args)
  if #args < 1 then
    return false
  end
  for _, arg in ipairs(args) do
    if arg:sub(1, 1) == "-" then
      return false
    end
  end
  local prefix = ALLOWED_USER .. "@"
  return args[1]:sub(1, #prefix) == prefix and #args[1] > #prefix
end

-- Returns how many ssh calls the line holds, and whether every one of them is
-- the trusted form.
local function find_ssh(command)
  local text = command:gsub("([;|&()<>\n`])", " %1 ")
  local words = {}
  for word in text:gmatch("%S+") do
    words[#words + 1] = word
  end

  local calls, trusted = 0, true
  local at_command = true
  local i = 1
  while i <= #words do
    local word = unquote(words[i])
    if is_separator(word) then
      at_command = true
    elseif at_command and SHELLS[word] then
      -- The next word is still a command word.
    elseif
      at_command
      and (
        WRAPPERS[word]
        or word:sub(1, 1) == "-"
        or word:match("^%d+$")
        or word:match("^[%a_][%w_]*=")
      )
    then
      -- A wrapper, its options, a duration, or a `VAR=value` prefix.
    elseif at_command then
      local name = word:match("([^/]+)$") or word
      if name == "ssh" then
        calls = calls + 1
        local args = {}
        local j = i + 1
        while j <= #words and not is_separator(unquote(words[j])) do
          args[#args + 1] = unquote(words[j])
          j = j + 1
        end
        if not plain_destination(args) then
          trusted = false
        end
      end
      at_command = false
    end
    i = i + 1
  end
  return calls, trusted
end

-- `prev` runs first: the layers below hold the hard blocks (a key under
-- `~/.ssh`, a secret store), and those must answer instead of the prompt.
maki.api.set_slot("tool.bash.input", function(prev, input, ctx)
  local out, reason = prev(input, ctx)
  if out == nil or reason ~= nil or type(out.command) ~= "string" then
    return out, reason
  end
  local calls, trusted = find_ssh(out.command)
  if calls > 0 and not trusted then
    local ask = ("Only `ssh %s@host` is pre-approved."):format(ALLOWED_USER)
    return out, { ask = ask }
  end
  return out, reason
end)
