-- noice 의 require("noice").api.status.command.get 로 어느정도 대체 가능?

local mapping = {
  startStopRecording = "q",
  playMacro = "Q",
  deleteAllMacros = require("globals").prefix.close .. "q",
  editMacro = "cq",
  yankMacro = "yq",
  addBreakPoint = "##",
}

---@type LazySpec
return {
  [1] = "chrisgrieser/nvim-recorder",
  lazy = true,
  enabled = false,
  keys = {
    { [1] = mapping.startStopRecording, desc = "macro" },
    { [1] = mapping.playMacro, desc = "play-macry" },
    { [1] = mapping.deleteAllMacros, desc = "delete-all-macros" },
    { [1] = mapping.editMacro, desc = "edit-macro" },
    { [1] = mapping.yankMacro, desc = "yank-macro" },
    { [1] = mapping.addBreakPoint, desc = "add-break-point" },
  },
  dependencies = {},
  opts = {
    mapping = mapping,
    useNerdfontIcons = false, -- which-key description scope를 더럽힘
    -- require("utils").enable_icon,
    -- lessNotifications = true,
  },
  specs = {
    {
      [1] = "nvim-lualine/lualine.nvim",
      optional = true,
      opts = function(_, opts)
        local modules = require("lualine_require").lazy_require({
          recorder = "recorder",
        })
        local component = {
          [1] = modules.recorder.recordingStatus,
        }

        if
          not require("lazy.core.config").plugins["nvim-recorder"].opts.useNerdfontIcons
          and require("utils").enable_icon
        then
          local icon = " " -- nf-cod-record
          component.fmt = function(str)
            if str ~= "" then
              return icon .. str
            end

            return str
          end
        end

        if opts.tabline == nil then
          opts.tabline = {}
        end
        if opts.tabline.lualine_x == nil then
          opts.tabline.lualine_x = {}
        end

        table.insert(opts.tabline.lualine_x, {
          component = component,
        })
      end,
    },
  },
}
