-- noice 의 require("noice").api.status.command.get 로 어느정도 대체 가능?

local mapping = {
  startStopRecording = "q",
  playMacro = "Q",
  deleteAllMacros = require("val").prefix.close .. "q",
  editMacro = "cq",
  yankMacro = "yq",
  addBreakPoint = "##",
}

---@type LazySpec
return {
  [1] = "chrisgrieser/nvim-recorder",
  lazy = true,
  enabled = true,
  keys = {
    { [1] = mapping.startStopRecording, desc = "macro" },
    { [1] = mapping.playMacro, desc = "play-macry" },
    { [1] = mapping.deleteAllMacros, desc = "delete-all-macros" },
    { [1] = mapping.editMacro, desc = "edit-macro" },
    { [1] = mapping.yankMacro, desc = "yank-macro" },
    { [1] = mapping.addBreakPoint, desc = "add-break-point" },
  },
  opts = {
    mapping = mapping,
    useNerdfontIcons = false, -- which-key description scope를 더럽힘
    -- require("utils").enable_icon,
    -- lessNotifications = true,
  },
}
