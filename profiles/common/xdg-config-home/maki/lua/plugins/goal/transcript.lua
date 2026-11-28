-- SPDX-License-Identifier: AGPL-3.0-or-later
-- SPDX-FileCopyrightText: 2026 KIM Hyunjae

-- Turn a maki.session.messages() transcript into a bounded text block for
-- the completion auditor. Pure Lua: the caller passes the JSON encoder.

local M = {}

local function escape(value)
  return (tostring(value):gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;"))
end

-- Move an index back to the start of a UTF-8 sequence.
local function boundary(text, index)
  while index > 1 and index <= #text do
    local byte = text:byte(index)
    if byte < 0x80 or byte >= 0xC0 then
      break
    end
    index = index - 1
  end
  return index
end

local function cut(text, limit)
  if limit <= 0 then
    return ""
  end
  if #text <= limit then
    return text
  end
  if limit <= 20 then
    return text:sub(1, boundary(text, limit) - 1)
  end
  local head_stop = math.floor(limit * 0.6)
  head_stop = boundary(text, head_stop)
  local tail_start = #text - (limit - head_stop - 8) + 1
  tail_start = boundary(text, tail_start)
  return text:sub(1, head_stop - 1) .. "\n…[cut]…\n" .. text:sub(tail_start)
end

local function flatten(value, depth)
  if type(value) == "string" then
    return value
  end
  if type(value) ~= "table" then
    return tostring(value)
  end
  if depth > 5 then
    return "[table]"
  end
  if type(value.text) == "string" then
    return value.text
  end
  local parts = {}
  for _, item in ipairs(value) do
    parts[#parts + 1] = flatten(item, depth + 1)
  end
  if #parts == 0 then
    local keys = {}
    for key in pairs(value) do
      keys[#keys + 1] = tostring(key)
    end
    table.sort(keys)
    return "{" .. table.concat(keys, ",") .. "}"
  end
  return table.concat(parts, "\n")
end

local function encode_input(encoder, input)
  if encoder then
    local ok, encoded = pcall(encoder, input)
    if ok and type(encoded) == "string" then
      return encoded
    end
  end
  return flatten(input, 0)
end

local function render_block(block, options)
  if type(block) ~= "table" then
    return nil
  end
  if block.type == "text" and type(block.text) == "string" then
    return escape(block.text)
  end
  if block.type == "tool_use" then
    return "[tool_use "
      .. escape(block.name or "?")
      .. "] "
      .. escape(encode_input(options.encode, block.input))
  end
  if block.type == "tool_result" then
    local label = block.is_error and "[tool_result error]" or "[tool_result]"
    return label .. " " .. escape(cut(flatten(block.content, 0), options.max_tool_chars))
  end
  if block.type == "image" then
    return "[image]"
  end
  return nil
end

local function render_message(message, options)
  local lines = {}
  local header = "[" .. tostring(message.role or "?")
  if message.kind and message.kind ~= "turn" then
    header = header .. " " .. tostring(message.kind)
  end
  header = header .. "]"
  lines[#lines + 1] = header
  for _, block in ipairs(message.content or {}) do
    local rendered = render_block(block, options)
    if rendered and rendered ~= "" then
      lines[#lines + 1] = rendered
    end
  end
  if #lines == 1 then
    return ""
  end
  return table.concat(lines, "\n")
end

function M.render(messages, options)
  options = options or {}
  local max_chars = options.max_chars or 40000
  local max_messages = options.max_messages or 40
  local render_options = {
    encode = options.encode,
    max_tool_chars = options.max_tool_chars or 2000,
  }
  local parts = {}
  local used = 0
  local count = 0
  for index = #messages, 1, -1 do
    if count >= max_messages or used >= max_chars then
      break
    end
    local rendered = render_message(messages[index], render_options)
    if rendered ~= "" then
      rendered = cut(rendered, max_chars - used)
      if rendered == "" then
        break
      end
      table.insert(parts, 1, rendered)
      used = used + #rendered + 1
      count = count + 1
    end
  end
  return "<transcript>\n" .. table.concat(parts, "\n") .. "\n</transcript>"
end

M._cut = cut
M._flatten = flatten

return M
