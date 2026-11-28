-- SPDX-License-Identifier: AGPL-3.0-or-later
-- SPDX-FileCopyrightText: 2026 KIM Hyunjae

-- Saved prompts live in `~/.agents/prompts`, next to the other agents' files,
-- and are read on every run: a new snippet needs no `/reload` and no Lua edit.
-- The file name is the name, the first line is the picker hint, and the whole
-- file is what lands in the input.
local ListPicker = require("maki.list_picker")

local EXTENSIONS = { md = true, markdown = true, txt = true }

local function prompts_dir()
  local home = maki.uv.os_homedir()
  if not home then
    return nil, "no home directory"
  end
  return maki.fs.joinpath(home, ".agents", "prompts")
end

local function first_line(text)
  for line in text:gmatch("[^\n]+") do
    local trimmed = line:match("^%s*(.-)%s*$")
    if trimmed ~= "" then
      return (trimmed:gsub("^#+%s*", ""))
    end
  end
  return ""
end

-- Sorted by name, and one snippet per stem, so `a.md` and `a.txt` cannot both
-- claim the same row.
local function load()
  local dir, err = prompts_dir()
  if not dir then
    return {}, err
  end
  local entries, dir_err = maki.fs.dir(dir)
  if not entries then
    return {}, dir_err
  end

  local snippets = {}
  local seen = {}
  for _, entry in ipairs(entries) do
    local name, kind = entry[1], entry[2]
    local stem, ext = name:match("^(.*)%.([^.]+)$")
    if
      stem
      and seen[stem] == nil
      and EXTENSIONS[ext:lower()]
      and (kind == "file" or kind == "link")
    then
      local text = maki.fs.read(maki.fs.joinpath(dir, name))
      if text then
        text = text:gsub("%s+$", "")
        if text ~= "" then
          seen[stem] = true
          snippets[#snippets + 1] = { name = stem, detail = first_line(text), text = text }
        end
      end
    end
  end
  table.sort(snippets, function(a, b)
    return a.name < b.name
  end)
  return snippets
end

local function insert(text)
  local st, err = maki.ui.input()
  if not st then
    maki.notify("/prompt: " .. tostring(err), "error")
    return
  end
  local done, edit_err = maki.ui.input_edit({
    start = st.cursor,
    stop = st.cursor,
    text = text,
    version = st.version,
    session_id = st.session_id,
  })
  if not done then
    maki.notify("/prompt: " .. tostring(edit_err), "error")
  end
end

maki.api.register_command({
  name = "/prompt",
  description = "Insert a saved prompt from ~/.agents/prompts",
  nargs = "*",
  handler = function(opts)
    local snippets, err = load()
    if err then
      maki.notify("/prompt: " .. tostring(err), "error")
      return
    end
    local dir = select(1, prompts_dir())
    if #snippets == 0 then
      maki.notify("/prompt: no snippets in " .. tostring(dir), "warn")
      return
    end

    -- `/prompt <name>` skips the picker, so a memorized name is one word away.
    local query = table.concat(opts.fargs or {}, " ")
    if query ~= "" then
      for _, snippet in ipairs(snippets) do
        if snippet.name == query then
          insert(snippet.text)
          return
        end
      end
    end

    local items = {}
    local by_label = {}
    for _, snippet in ipairs(snippets) do
      by_label[snippet.name] = snippet
      items[#items + 1] = {
        label = snippet.name,
        detail = snippet.detail ~= "" and snippet.detail or nil,
      }
    end

    local choice = ListPicker.open(items, {
      title = "Prompt",
      footer = { { "<CR>", "insert" }, { "<Esc>", "close" } },
      key = function(item)
        return item.label
      end,
    })
    if choice and choice.type == "choice" and choice.item then
      local snippet = by_label[choice.item.label]
      if snippet then
        insert(snippet.text)
      end
    end
  end,
})

return { load = load, insert = insert }
