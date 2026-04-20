---@type LazySpec[]
return {
  {
    [1] = "snacks.nvim",
    optional = true,
    opts = function()
      local group = vim.api.nvim_create_augroup("visual_snacks_highlights", { clear = true })
      local snacks_hl_override = function()
        -- HACK: Hidden files are linked to NonText by default, which is too dim in gruvbox-material and various themes <2026-04-18>
        vim.api.nvim_set_hl(0, "SnacksPickerPathHidden", { link = "Comment", force = true })
      end

      vim.api.nvim_create_autocmd("ColorScheme", {
        group = group,
        callback = snacks_hl_override,
      })

      LazyVim.on_load("snacks.nvim", snacks_hl_override)
    end,
  },
  {
    [1] = "snacks.nvim",
    optional = true,
    ---@type snacks.Config
    opts = {
      styles = {
        terminal = {
          wo = {
            -- Snacks windows default to SnacksNormal -> NormalFloat.
            -- Keep the terminal on the editor background instead.
            winhighlight = table.concat({
              "Normal:Normal",
              "NormalNC:Normal",
              "WinBar:SnacksWinBar",
              "WinBarNC:SnacksWinBarNC",
              "FloatTitle:SnacksTitle",
              "FloatFooter:SnacksFooter",
              "WinSeparator:SnacksWinSeparator",
            }, ","),
          },
        },
      },
    },
  },
}
