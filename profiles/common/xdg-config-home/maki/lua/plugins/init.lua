-- SPDX-License-Identifier: AGPL-3.0-or-later
-- SPDX-FileCopyrightText: 2022-2026 KIM Hyunjae

-- require("plugins.mode_thinking")
require("plugins.goal")
require("plugins.guard.cc_safety_net")
require("plugins.guard.secrets")
-- After guard.secrets: it calls `prev` first, so the hard path blocks stay in
-- front of the ssh prompt.
require("plugins.guard.ssh")
require("plugins.guard.build")
require("plugins.herdr")
require("plugins.wakelock")
