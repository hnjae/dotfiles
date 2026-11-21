-- SPDX-License-Identifier: AGPL-3.0-or-later
-- SPDX-FileCopyrightText: 2022-2026 KIM Hyunjae

---@type LazySpec
return {
  [1] = "mini.pairs",
  optional = true,
  opts = {
    mappings = {
      ['"'] = false,
      ["'"] = false,
      ["`"] = false,
    },
  },
}
