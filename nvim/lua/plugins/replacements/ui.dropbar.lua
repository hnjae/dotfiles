--[[
  - NOTE:
    - <https://github.com/Bekaboo/dropbar.nvim>
    - LazyVim 의 경우 lualine 에서 관련 내용을 제거 해야 중복되지 않는다.
]]

---@type LazySpec[]
return {
  {
    [1] = "Bekaboo/dropbar.nvim",
    version = "*", -- follows sementaic versioning
    dependencies = { { [1] = "LazyVim", optional = true } }, -- to load icons

    lazy = true,
    event = "LspAttach",

    opts = function(_, opts)
      -- use function to get the current config
      return vim.tbl_deep_extend("keep", opts, {
        icons = {
          kinds = {
            -- symbols = vim.deepcopy(LazyVim.config.icons.kinds),
            symbols = LazyVim.config.icons.kinds,
          },
        },
      })
    end,
  },
  {
    [1] = "lualine.nvim",
    optional = true,
    opts = function(_, opts)
      -- HACK: lualine_c 의 마지막 elements 가 LazyVim.lualine.pretty_path() 인지 어떻게 아나? <2025-04-07>
      table.remove(opts.sections.lualine_c, 5)
    end,
  },
}
