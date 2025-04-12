--[[
  NOTE:
    overriding `lang.markdown` from LazyExtra
--]]
---@type LazySpec
return {
  [1] = "render-markdown.nvim",
  optional = true,
  enabled = true,
  opts = {
    html = {
      comment = {
        conceal = false,
      },
    },
    heading = {
      border = "thin",
    },
    checkbox = {
      enabled = false,
    },
    bullet = {
      enabled = true,
      -- icons = { "●", "○", "◆", "◇" },
    },
    link = {
      custom = {
        -- disable default customs
        google = { pattern = "2a428722-0c6e-4e60-a678-1c73f02c42d3" },
        neovim = { pattern = "38a4d3d4-ff75-4776-a059-a7117ed2c307" },
        reddit = { pattern = "7fbd68c6-6900-4a56-a5f9-1a424e5a190e" },
        discord = { pattern = "cdd9cb4a-d2f2-44e4-866c-99703790f532" },

        web = { pattern = "^http:", icon = "󱞐 " },
        webs = { pattern = "^https:", icon = "󰖟 " },

        github = { pattern = "github%.com", icon = "󰊤 " },
        gitlab = { pattern = "gitlab%.com", icon = "󰮠 " },
        stackoverflow = { pattern = "stackoverflow%.com", icon = "󰓌 " },
        wikipedia = { pattern = "wikipedia%.org", icon = "󰖬 " },
        youtube = { pattern = "youtube%.com", icon = "󰗃 " },
      },
    },
    code = {
      position = "right",
      border = "thick", -- ``` 부분도 색칠
      style = "full",
      highlight_inline = "markdownCode",
    },
    win_options = {
      conceallevel = {
        -- default = vim.o.conceallevel,
        default = 0,
        rendered = 0, -- 2: concleal space, empty line
      },
    },
  },
}
