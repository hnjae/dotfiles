-- SPDX-License-Identifier: AGPL-3.0-or-later
-- SPDX-FileCopyrightText: 2022-2026 KIM Hyunjae

local clip = require("utils.clipboard")

-- The newest message the user saw the model say. `display_text` nil shows the
-- content and "" hides it, so "" marks a nudge or a compaction note, not
-- something worth copying.
local function last_assistant_text()
  local messages, err = maki.session.messages()
  if not messages then
    return nil, err
  end

  for i = #messages, 1, -1 do
    local message = messages[i]
    if
      message.role == "assistant"
      and (message.kind == nil or message.kind == "turn")
      and message.display_text ~= ""
    then
      local parts = {}
      for _, block in ipairs(message.content or {}) do
        if block.type == "text" then
          parts[#parts + 1] = block.text
        end
      end
      local text = table.concat(parts)
      text = text:gsub("%s+$", "")
      if text ~= "" then
        return text
      end
    end
  end
  return nil
end

maki.api.register_command({
  name = "/copy",
  description = "Copy the last assistant message to the clipboard",
  handler = function()
    local text, err = last_assistant_text()
    if err then
      maki.notify("/copy: " .. tostring(err), "error")
      return
    end
    if not text then
      maki.notify("/copy: no assistant text to copy", "warn")
      return
    end

    local backend, copy_err = clip.copy(text)
    if not backend then
      maki.notify("/copy: " .. tostring(copy_err), "error")
      return
    end
    -- The backend is named because a clipboard write has no other visible
    -- effect, and two of the three cannot report success.
    maki.ui.flash(string.format("Copied %d chars via %s", #text, backend))
  end,
})
