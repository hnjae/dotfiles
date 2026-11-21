-- SPDX-License-Identifier: AGPL-3.0-or-later
-- SPDX-FileCopyrightText: 2022-2026 KIM Hyunjae

-- Replaces LazyExtra lang.git's cmp-git (nvim-cmp only)

---@type LazySpec
return {
  [1] = "blink.cmp",
  optional = true,
  dependencies = { "Kaiser-Yang/blink-cmp-git" },
  ---@type blink.cmp.Config
  opts = {
    sources = {
      per_filetype = {
        gitcommit = { inherit_defaults = true, "git" },
        octo = { inherit_defaults = true, "git" },
      },
      providers = {
        git = {
          name = "Git",
          module = "blink-cmp-git",
        },
      },
    },
  },
}
