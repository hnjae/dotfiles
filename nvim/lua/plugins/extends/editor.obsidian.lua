-- <https://github.com/obsidian-nvim/obsidian.nvim>

---@type LazySpec
return {
  [1] = "obsidian-nvim/obsidian.nvim",
  version = false,
  -- [1] = "epwalsh/obsidian.nvim",
  -- version("*"),

  cond = not vim.g.vscode,

  lazy = true,
  ft = "markdown",
  dependencies = {
    "nvim-lua/plenary.nvim",

    "fzf-lua", -- default picker
  },
  keys = {
    -- <leader>t: neotest
    { [1] = "<leader>tt", [2] = "<cmd>ObsidianToday<CR>", desc = "today", ft = "markdown" },
    { [1] = "<leader>tT", [2] = "<cmd>ObsidianTomorrow<CR>", desc = "tomorrow", ft = "markdown" },
    { [1] = "<leader>tY", [2] = "<cmd>ObsidianYesterday<CR>", desc = "yesterday", ft = "markdown" },
    {
      [1] = "<leader>td",
      [2] = "<cmd>ObsidianDailies<CR>",
      desc = "select-dailies",
      ft = "markdown",
    },
    { [1] = "<leader>tg", [2] = "<cmd>ObsidianTags<CR>", desc = "select-tags", ft = "markdown" },
    {
      [1] = "<leader>tb",
      [2] = "<cmd>ObsidianBacklinks<CR>",
      desc = "select-backlinks",
      ft = "markdown",
    },
    {
      [1] = "<leader>ts",
      [2] = "<cmd>ObsidianQuickSwitch<CR>",
      desc = "quick-switch",
      ft = "markdown",
    },
    {
      [1] = "<leader>tX",
      [2] = "<cmd>ObsidianOpen<CR>",
      desc = "open-in-obsidian",
      ft = "markdown",
    },
    {
      [1] = "<leader>so",
      [2] = "<cmd>ObsidianSearch<CR>",
      desc = "obsidian-search",
      ft = "markdown",
    },
    -- { [1] = "<leader>tx", [2] = "<cmd>ObsidianSearch<CR>", desc = "obsidian-search", ft = "markdown" },
  },

  opts = {
    -- match obsidian
    workspaces = {
      {
        name = "home",
        path = "~/Documents/obsidian/home",
      },
    },
    daily_notes = {
      folder = "journals",
      date_format = "%Y-%m-%d",
      template = nil,
      alias_format = nil,
      -- default_tags = {},
    },
    new_notes_location = nil,
    notes_subdir = vim.NIL,
    templates = {
      --   folder = vim.NIL,
      date_format = "%Y-%m-%d",
      time_format = "%H:%M",
    },
    disable_frontmatter = true,
    -- https://github.com/Vinzent03/obsidian-advanced-uri
    use_advanced_uri = false,
    note_id_func = function(title)
      return title
    end,

    -- neovim config
    ui = {
      enable = false,
    },
    completion = {
      nvim_cmp = true,
      blink = false,
    },
    picker = {
      name = "fzf-lua", -- 그냥 vim.ui.select 사용하는 옵션은 없나?
    },
  },
  config = function(_, opts)
    require("obsidian").setup(opts)

    for _, command in ipairs({ "ObsidianNew" }) do
      vim.api.nvim_del_user_command(command)
    end
  end,
  specs = {
    {
      [1] = "which-key.nvim",
      optional = true,
      opts = {
        icons = {
          rules = {
            {
              plugin = "obsidian.nvim",
              icon = "", -- nf-seti-markdown
              color = "purple",
            },
          },
        },
        spec = {
          -- {
          --   [1] = "<leader>t",
          --   mode = { "n" },
          --   group = "obsidian",
          --   ft = "markdown",
          --   icon = {
          --     icon = "", -- nf-seti-markdown
          --     color = "purple",
          --   },
          -- },
        },
      },
    },
    {
      [1] = "render-markdown.nvim",
      optional = true,
      opts = {
        preset = "obsidian",
        -- custom = {
        --     todo = { raw = '[-]', rendered = '󰥔 ', highlight = 'RenderMarkdownTodo', scope_highlight = nil },
        -- },
        checkbox = {
          enabled = true,
          unchecked = {
            icon = " 󰄱 ", -- nf-md -checkbox_blnak_outline
          },
          checked = {
            icon = " 󰄲 ", -- nf-mdcheckbox_marked
          },
          custom = {
            -- override defaults
            todo = {
              raw = "[☺]",
              rendered = "[☺]",
            },
            in_progress = {
              raw = "[/]",
              rendered = " 󰄮 ", -- nf-md-checkbox-blank
              highlight = "RenderMarkdownTodo",
              scope_highlight = nil,
            },
            canceled = {
              raw = "[-]",
              rendered = " 󱋭 ",
              highlight = "RenderMarkdownTodo",
              scope_highlight = nil,
            },
            rescheduled = {
              raw = "[<]",
              rendered = " 󰃮 ", --nf-md-calendar
              highlight = "RenderMarkdownTodo",
              scope_highlight = nil,
            },
            scheduled = {
              raw = "[>]",
              rendered = "  ", --nf-fa_mail_forward
              highlight = "RenderMarkdownTodo",
              scope_highlight = nil,
            },
            important = {
              raw = "[!]",
              rendered = "  ",
              highlight = "RenderMarkdownTodo",
              scope_highlight = nil,
            },
            question = {
              raw = "[?]",
              rendered = "  ",
              highlight = "RenderMarkdownTodo",
              scope_highlight = nil,
            },
            star = {
              raw = "[*]",
              rendered = "  ",
              highlight = "RenderMarkdownTodo",
              scope_highlight = nil,
            },
            note = {
              raw = "[n]",
              rendered = " 󰐃 ",
              highlight = "RenderMarkdownTodo",
              scope_highlight = nil,
            },
            location = {
              raw = "[l]",
              rendered = "  ",
              highlight = "RenderMarkdownTodo",
              scope_highlight = nil,
            },
            information = {
              raw = "[i]",
              rendered = "  ",
              highlight = "RenderMarkdownTodo",
              scope_highlight = nil,
            },
            idea = {
              raw = "[I]",
              rendered = "  ",
              highlight = "RenderMarkdownTodo",
              scope_highlight = nil,
            },
            amount = {
              raw = "[S]",
              rendered = "  ",
              highlight = "RenderMarkdownTodo",
              scope_highlight = nil,
            },
            pro = {
              raw = "[p]",
              rendered = "  ",
              highlight = "RenderMarkdownTodo",
              scope_highlight = nil,
            },
            con = {
              raw = "[c]",
              rendered = "  ",
              highlight = "RenderMarkdownTodo",
              scope_highlight = nil,
            },
            bookmark = {
              raw = "[b]",
              rendered = "  ",
              highlight = "RenderMarkdownTodo",
              scope_highlight = nil,
            },
            quote = {
              raw = '["]',
              rendered = "  ",
              highlight = "RenderMarkdownTodo",
              scope_highlight = nil,
            },
            up = {
              raw = "[u]",
              rendered = " 󰔵 ",
              highlight = "RenderMarkdownTodo",
              scope_highlight = nil,
            },
            down = {
              raw = "[d]",
              rendered = " 󰔳 ",
              highlight = "RenderMarkdownTodo",
              scope_highlight = nil,
            },
            win = {
              raw = "[w]",
              rendered = "  ",
              highlight = "RenderMarkdownTodo",
              scope_highlight = nil,
            },
            key = {
              raw = "[k]",
              rendered = "  ",
              highlight = "RenderMarkdownTodo",
              scope_highlight = nil,
            },
            fire = {
              raw = "[f]",
              rendered = "  ",
              highlight = "RenderMarkdownTodo",
              scope_highlight = nil,
            },
          },
        },
      },
    },
  },
}
