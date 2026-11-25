-- SPDX-License-Identifier: AGPL-3.0-or-later
-- SPDX-FileCopyrightText: 2022-2026 KIM Hyunjae

-- Ask before a build-instruction file changes.
--
-- `just`, `cargo`, `make`, and the JS package managers run whatever these
-- files name, and a write inside cwd never prompts, so an allow rule for the
-- command leaves the model free to write the file first. Gating the input
-- keeps `just build` and `just format` prompt-free, while a new recipe, a
-- `build.rs`, or a lifecycle script costs one approval.
--
-- Only the file-write tools are wrapped, by their `path` field. The basename
-- decides, so the file is guarded wherever it sits.

local GUARDED_BASENAMES = {
  ["justfile"] = true,
  ["Justfile"] = true,
  [".justfile"] = true,
  ["makefile"] = true,
  ["Makefile"] = true,
  ["GNUmakefile"] = true,
  ["build.rs"] = true,
  ["Cargo.toml"] = true,
  ["package.json"] = true,
}

-- Suffixes for the files whose basename says nothing on its own.
local GUARDED_SUFFIXES = {
  ".just",
  ".cargo/config",
  ".cargo/config.toml",
}

local function guarded(path)
  local name = path:match("([^/]+)$") or path
  if GUARDED_BASENAMES[name] then
    return name
  end
  for _, suffix in ipairs(GUARDED_SUFFIXES) do
    if path:sub(-#suffix) == suffix then
      return suffix
    end
  end
  return nil
end

-- `ask` raises the permission prompt even under an allow rule or YOLO mode.
local function gate(prev, input, ctx)
  local path = input.path
  if type(path) == "string" then
    local hit = guarded(path)
    if hit then
      local reason = ("%s is read and run by the build tools; check the diff."):format(hit)
      return nil, { ask = reason }
    end
  end
  return prev(input, ctx)
end

for _, tool in ipairs({ "write", "edit", "multiedit", "edit_lines", "insert_lines" }) do
  maki.api.set_slot("tool." .. tool .. ".input", gate)
end
