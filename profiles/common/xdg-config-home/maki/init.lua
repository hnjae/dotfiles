-- SPDX-License-Identifier: AGPL-3.0-or-later
-- SPDX-FileCopyrightText: 2022-2026 KIM Hyunjae

-- Load order matters only where a comment says so.

require("config.options")
require("config.keymaps")
require("config.autocmds")
require("config.commands")

require("prompts.conventions")
-- require("prompts.emphasis")
require("prompts.i_have_adhd")
require("prompts.shell_visibility")

require("plugins.guard.cc_safety_net")
require("plugins.guard.secrets")
-- After guard.secrets: it calls `prev` first, so the hard path blocks stay in
-- front of the ssh prompt.
require("plugins.guard.ssh")
require("plugins.guard.build")
require("plugins.herdr")
require("plugins.wakelock")
