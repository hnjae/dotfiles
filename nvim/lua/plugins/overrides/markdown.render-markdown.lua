--[[
  NOTE:
    overriding `lang.markdown` from LazyExtra
--]]
---@type LazySpec
return {
  [1] = "render-markdown.nvim",
  optional = true,
  enabled = true,
  ---@type render.md.UserConfig
  opts = {
    html = {
      comment = {
        conceal = false,
      },
    },
    heading = {
      border = false,
    },
    bullet = {
      enabled = true,
      -- icons = { "●", "○", "◆", "◇" },
      icons = { "" },

      -- nf-cod:     nf-fa:  nf-md: 󰧟 󰧞 , ascii: - *
    },
    checkbox = {
      enabled = true,
    },
    link = {
      custom = {
        -- disable default customs
        web = { pattern = "a0140afd-512d-4e5a-a238-39bed15ea458" },
        discord = { pattern = "ad8fc1b2-41e6-4048-ba7a-459d88821caf" },
        github = { pattern = "19c7baa6-7644-493d-9582-e8fa6974ed92" },
        gitlab = { pattern = "d6e3b715-bd5a-4083-ba4f-1e5780977069" },
        google = { pattern = "2a428722-0c6e-4e60-a678-1c73f02c42d3" },
        neovim = { pattern = "38a4d3d4-ff75-4776-a059-a7117ed2c307" },
        reddit = { pattern = "7fbd68c6-6900-4a56-a5f9-1a424e5a190e" },
        stackoverflow = { pattern = "ee4ae8c2-45c3-48e1-ba2f-9533059366c2" },
        wikipedia = { pattern = "9940b06d-695e-4ed9-a9fd-3be980fc6874" },
        youtube = { pattern = "a5fdcfb2-d268-42a8-93c5-704b443914ee" },

        -- web = { pattern = "^http:", icon = "󱞐 " },
        -- webs = { pattern = "^https:", icon = "󰖟 " },
      },
    },
    code = {
      position = "right", -- Determines where language icon is rendered.
      border = "thick", -- ``` 부분도 색칠
      style = "full",
      highlight_inline = "markdownCode",

      -- left_margin = 0,
      -- highlight = "Normal",
      -- highlight_border = "Normal",
      -- highlight_fallback = "Normal",
    },
    win_options = {
      conceallevel = {
        -- default = vim.o.conceallevel,
        default = 0,
        rendered = 2, -- 2: concleal space, empty line
      },
    },
  },
  specs = {
    {
      [1] = "lazydev.nvim",
      optional = true,
      opts = {
        library = { "render-markdown.nvim" },
      },
    },
  },
}
