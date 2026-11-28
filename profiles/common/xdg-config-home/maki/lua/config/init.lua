-- SPDX-License-Identifier: AGPL-3.0-or-later
-- SPDX-FileCopyrightText: 2022-2026 KIM Hyunjae

-- `options` goes first: it is the only file that calls `maki.setup`.
require("config.options")
require("config.keymaps")
require("config.autocmds")
require("config.commands")
