-- SPDX-License-Identifier: AGPL-3.0-or-later
-- SPDX-FileCopyrightText: 2026 KIM Hyunjae

-- Mirrors the discovery in maki's builtin `skill` tool, so the picker lists
-- what the model can load. maki has no API for that list: the tool's
-- description carries it as text.
local ListPicker = require("maki.list_picker")

local SKILL_FILE = "SKILL.md"
local PROJECT_SKILL_DIRS = {
  ".maki/skills",
  ".claude/skills",
  ".opencode/skills",
  ".agents/skills",
}
local GLOBAL_SKILL_DIRS = {
  ".claude/skills",
  ".config/opencode/skills",
  ".agents/skills",
}
local BUILTIN = {
  name = "maki-plugin-dev",
  description = "Write or modify maki plugins or init.lua config in Lua: custom tools, slash commands, keymaps, UI, providers. Authoring guide, real example, indexed maki Lua API reference. Load before any maki plugin work.",
}

local function parse_frontmatter(content)
  local rest = content:match("^%s*%-%-%-\n(.*)")
  if not rest then
    return {}, content
  end
  local stop = rest:find("\n%-%-%-")
  if not stop then
    return {}, content
  end
  local fm = maki.yaml.decode(rest:sub(1, stop))
  if type(fm) ~= "table" then
    fm = {}
  end
  return fm, rest:sub(stop + 4):match("^%s*(.-)%s*$")
end

local function skill_fields(fm, fallback)
  local name = type(fm.name) == "string" and fm.name or fallback
  local description = type(fm.description) == "string" and fm.description or ""
  return name, description
end

local function scan(dir, skills)
  local entries = maki.fs.dir(dir)
  if not entries then
    return
  end
  for _, entry in ipairs(entries) do
    if entry[2] == "directory" then
      local path = maki.fs.joinpath(dir, entry[1], SKILL_FILE)
      local content = maki.fs.read(path)
      if content then
        local fm, body = parse_frontmatter(content)
        if body and #body > 0 then
          local name, description = skill_fields(fm, entry[1])
          skills[name] = { name = name, description = description }
        end
      end
    end
  end
end

local function ancestors()
  local cwd = maki.uv.cwd()
  if not cwd then
    return {}
  end
  local dirs = { cwd }
  if maki.fs.metadata(maki.fs.joinpath(cwd, ".git")) then
    return dirs
  end
  for _, parent in ipairs(maki.fs.parents(cwd)) do
    dirs[#dirs + 1] = parent
    if maki.fs.metadata(maki.fs.joinpath(parent, ".git")) then
      break
    end
  end
  return dirs
end

local function discover()
  local skills = { [BUILTIN.name] = BUILTIN }

  local config = maki.env.config_dir()
  if config then
    scan(maki.fs.joinpath(config, "skills"), skills)
  end

  local home = maki.uv.os_homedir()
  if home then
    for _, rel in ipairs(GLOBAL_SKILL_DIRS) do
      scan(maki.fs.joinpath(home, rel), skills)
    end
  end

  for _, dir in ipairs(ancestors()) do
    for _, rel in ipairs(PROJECT_SKILL_DIRS) do
      scan(maki.fs.joinpath(dir, rel), skills)
    end
  end

  return skills
end

local function list()
  local skills = {}
  for _, skill in pairs(discover()) do
    skills[#skills + 1] = skill
  end
  table.sort(skills, function(a, b)
    return a.name < b.name
  end)
  return skills
end

local function insert(name)
  local st, err = maki.ui.input()
  if not st then
    maki.notify("/skills: " .. tostring(err), "error")
    return
  end
  local done, edit_err = maki.ui.input_edit({
    start = st.cursor,
    stop = st.cursor,
    text = string.format("Use the `%s` skill.", name),
    version = st.version,
    session_id = st.session_id,
  })
  if not done then
    maki.notify("/skills: " .. tostring(edit_err), "error")
  end
end

maki.api.register_command({
  name = "/skills",
  description = "Browse available skills and insert one into the prompt",
  handler = function()
    local items = {}
    for _, skill in ipairs(list()) do
      items[#items + 1] = {
        label = skill.name,
        detail = skill.description ~= "" and skill.description or nil,
      }
    end
    if #items == 0 then
      maki.notify("/skills: no skills found", "warn")
      return
    end

    local choice = ListPicker.open(items, {
      title = "Skills",
      footer = { { "<CR>", "use" }, { "<Esc>", "close" } },
      key = function(item)
        return item.label
      end,
    })
    if choice and choice.type == "choice" and choice.item then
      insert(choice.item.label)
    end
  end,
})

return { discover = discover, list = list, insert = insert }
