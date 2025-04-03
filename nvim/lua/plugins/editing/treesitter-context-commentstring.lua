--[[
  NOTE:
    neovim's built-in commenting:
      - `:h commenting`
      - neovim 빌트인은 `gb` 같은 키맵을 제공하지 않는다.
      - <https://github.com/neovim/neovim/pull/28176>
]]
---@type LazySpec
return {
  [1] = "nvim-treesitter/nvim-treesitter",
  optional = true,
  specs = {
    {
      [1] = "JoosepAlviste/nvim-ts-context-commentstring",
      lazy = true,
      event = "VeryLazy", -- neovim 빌트인 커맨드에서 사용하기 위해
      dependencies = {
        "nvim-treesitter/nvim-treesitter",
      },
      opts = {
        enable_autocmd = false,
      },
      main = "ts_context_commentstring",
      config = function(plugin, opts)
        require(plugin.main).setup(opts)

        local get_option = vim.filetype.get_option
        vim.filetype.get_option = function(filetype, option)
          return option == "commentstring"
              and require("ts_context_commentstring.internal").calculate_commentstring()
            or get_option(filetype, option)
        end
      end,
    },
  },
}
