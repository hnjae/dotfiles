-- SPDX-License-Identifier: AGPL-3.0-or-later
-- SPDX-FileCopyrightText: 2022-2026 KIM Hyunjae

---@type LazySpec
return {
  [1] = "nvim-ts-autotag",
  optional = true,
  opts = {
    per_filetype = {
      ["markdown"] = {
        enable_close = false,
      },
    },
  },
}
