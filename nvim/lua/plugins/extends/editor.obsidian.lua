local format = require("lazyvim.util.format")
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
    {
      [1] = "<C-A-CR>",
      [2] = "<cmd>ObsidianFollowLink vsplit<CR>",
      desc = "follow-link-vsplit",
      ft = "markdown",
    },
    -- { [1] = "<CR>", [2] = "<cmd>ObsidianFollowLink<CR>", desc = "follow-link", ft = "markdown" },
    {
      [1] = "<CR>",
      [2] = function()
        return require("obsidian").util.smart_action()
      end,
      desc = "smart-action",
      ft = "markdown",
      expr = true,
    },
    {
      [1] = "<A-CR>",
      [2] = "<cmd>ObsidianFollowLink vsplit<CR>",
      desc = "follow-link-vsplit",
      ft = "markdown",
    },
    {
      [1] = "<C-CR>",
      [2] = "<cmd>ObsidianFollowLink<CR>",
      desc = "follow-link",
      ft = "markdown",
    },

    -- {"<leader>t", "", desc = "+test"},
    -- { "<leader>tt", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Run File (Neotest)" },
    -- { "<leader>tT", function() require("neotest").run.run(vim.uv.cwd()) end, desc = "Run All Test Files (Neotest)" },
    -- { "<leader>tr", function() require("neotest").run.run() end, desc = "Run Nearest (Neotest)" },
    -- { "<leader>tl", function() require("neotest").run.run_last() end, desc = "Run Last (Neotest)" },
    -- { "<leader>ts", function() require("neotest").summary.toggle() end, desc = "Toggle Summary (Neotest)" },
    -- { "<leader>to", function() require("neotest").output.open({ enter = true, auto_close = true }) end, desc = "Show Output (Neotest)" },
    -- { "<leader>tO", function() require("neotest").output_panel.toggle() end, desc = "Toggle Output Panel (Neotest)" },
    -- { "<leader>tS", function() require("neotest").run.stop() end, desc = "Stop (Neotest)" },
    -- { "<leader>tw", function() require("neotest").watch.toggle(vim.fn.expand("%")) end, desc = "Toggle Watch (Neotest)" },

    -- { "<leader>t", "", desc = "+obsidian" },
    -- { "<leader>tt", false, ft = "markdown" },
    -- { "<leader>tT", false, ft = "markdown" },
    -- { "<leader>tr", false, ft = "markdown" },
    -- { "<leader>tl", false, ft = "markdown" },
    -- { "<leader>ts", false, ft = "markdown" },
    -- { "<leader>to", false, ft = "markdown" },
    -- { "<leader>tO", false, ft = "markdown" },
    -- { "<leader>tS", false, ft = "markdown" },
    -- { "<leader>tw", false, ft = "markdown" },

    -- <leader>t: neotest
    { [1] = "<leader>tt", [2] = "<cmd>ObsidianToday<CR>", desc = "today", ft = "markdown" },
    { [1] = "<leader>tm", [2] = "<cmd>ObsidianTomorrow<CR>", desc = "tomorrow", ft = "markdown" },
    {
      [1] = "<leader>ty",
      [2] = "<cmd>ObsidianYesterday<CR>",
      desc = "yesterday",
      ft = "markdown",
    },
    { [1] = "<leader>tT", [2] = "<cmd>ObsidianTemplate<CR>", desc = "template", ft = "markdown" },
    { [1] = "<leader>tr", [2] = "<cmd>ObsidianRename<CR>", desc = "rename", ft = "markdown" },
    {
      [1] = "<leader>tj",
      [2] = "<cmd>ObsidianDailies<CR>",
      desc = "select-journals (dailies)",
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
      [1] = "<leader>tX",
      [2] = "<cmd>ObsidianOpen<CR>",
      desc = "open-in-obsidian",
      ft = "markdown",
    },
    -- [2] = "<cmd>ObsidianToggleCheckbox<CR>",
    {
      [1] = "<leader>td",
      [2] = function()
        return require("obsidian").util.toggle_checkbox({ " ", "/", "x" })
      end,
      desc = "toggle-checkbox",
      ft = "markdown",
    },
    {
      [1] = "<leader>tD",
      [2] = function()
        return require("obsidian").util.toggle_checkbox({ "x" })
      end,
      desc = "checkbox-done",
      ft = "markdown",
    },
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
      template = "journal.md",
      alias_format = nil,
      -- default_tags = {},
    },
    new_notes_location = "notes_subdir",
    -- notes_subdir = vim.NIL,
    notes_subdir = "/",
    templates = {
      folder = "templates",
      date_format = "%Y-%m-%d",
      time_format = "%H:%M:%S",
      substitutions = {
        ["time:YYYY-MM-DD[T]HH:MM:SSZ"] = function()
          return vim.fn.strftime("%Y-%m-%dT%H:%M:%S%z")
        end,
        ["time:GGGG-[W]WW-E"] = function()
          return vim.fn.strftime("%G-W%V-%u")
        end,
        ["time:GGGG-DDDD"] = function()
          return vim.fn.strftime("%G-%j")
        end,
        ["time:GGGG-[W]WW"] = function()
          return vim.fn.strftime("%G-W%V")
        end,
        ["date:dddd"] = function()
          return vim.fn.strftime("%A")
        end,
      },
    },
    disable_frontmatter = true,
    -- https://github.com/Vinzent03/obsidian-advanced-uri
    use_advanced_uri = false,
    note_id_func = function(title)
      return title
    end,
    attachments = {
      img_folder = "attachments/",
      -- img_name_func = function ()
      --     return string.format("%s-", os.time())
      -- end
    },

    -- neovim config
    mappings = {
      -- override lazyvim's mapping
      ["<leader>sg"] = {
        action = "<cmd>ObsidianSearch<CR>",
        opts = {
          desc = "obsidian-search (ripgrep)",
        },
      },
      ["<leader><leader>"] = {
        action = "<cmd>ObsidianQuickSwitch<CR>",
        opts = {
          desc = "obsidian-quick-switch",
        },
      },
      ["<leader>ff"] = {
        action = "<cmd>ObsidianQuickSwitch<CR>",
        opts = {
          desc = "obsidian-quick-switch",
        },
      },
    },
    ui = {
      enable = false,
      -- checkoxes = {
      --   [" "] = { char = "󰄱", hl_group = "ObsidianTodo" },
      --   ["x"] = { char = "", hl_group = "ObsidianDone" },
      --   ["/"] = { char = "", hl_group = "ObsidianRightArrow" },
      -- },
    },
    completion = {
      nvim_cmp = true,
      blink = false,
    },
    picker = {
      name = "fzf-lua", -- 그냥 vim.ui.select 사용하는 옵션은 없나?
    },
    follow_url_func = function(url)
      -- vim.fn.jobstart({ "xdg-open", url })
      vim.ui.open(url)
    end,
    follow_img_func = function(img)
      -- vim.fn.jobstart({ "xdg-open", img })
      vim.ui.open(img)
    end,
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
              -- icon = "", -- nf-seti-markdown
              icon = "󰧑", -- nf-md-brain
              color = "purple",
            },
            {
              pattern = "obsidian",
              icon = "󰧑", -- nf-md-brain
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
          checked = {
            -- icon = " 󰄲 ", -- nf-mdcheckbox_marked
            icon = "  ", -- nf-fa-check_circle
            highlight = "markdownH1",
          },
          unchecked = {
            -- icon = " 󰄱 ", -- nf-md -checkbox_blnak_outline
            icon = "  ", -- nf-fa-circle
            highlight = "markdownBold",
          },
          custom = {
            -- override defaults
            todo = {
              raw = "[☺]",
              rendered = "[☺]",
            },
            in_progress = {
              raw = "[/]",
              -- rendered = " 󰄮 ", -- nf-md-checkbox-blank
              rendered = "  ", -- nf-fa-circle_dot
              highlight = "markdownBold",
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
              highlight = "GitSignsAdd",
              scope_highlight = nil,
            },
            scheduled = {
              raw = "[>]",
              rendered = "  ", --nf-fa_mail_forward
              highlight = "DiagnosticVirtualTextInfo",
              scope_highlight = nil,
            },
            important = {
              raw = "[!]",
              rendered = "  ",
              highlight = "DiagnosticVirtualTextWarn",
              scope_highlight = nil,
            },
            question = {
              raw = "[?]",
              rendered = "  ",
              highlight = "DiagnosticVirtualTextWarn",
              scope_highlight = nil,
            },
            star = {
              raw = "[*]",
              rendered = "  ",
              highlight = "DiagnosticVirtualTextWarn",
              scope_highlight = nil,
            },
            note = {
              raw = "[n]",
              rendered = " 󰐃 ",
              highlight = "DiagnosticVirtualTextError",
              scope_highlight = nil,
            },
            location = {
              raw = "[l]",
              rendered = "  ",
              highlight = "CmpItemKindKeyword",
              scope_highlight = nil,
            },
            information = {
              raw = "[i]",
              rendered = "  ",
              highlight = "DiagnosticVirtualTextInfo",
              scope_highlight = nil,
            },
            idea = {
              raw = "[I]",
              rendered = "  ",
              highlight = "DiagnosticVirtualTextWarn",
              scope_highlight = nil,
            },
            amount = {
              raw = "[S]",
              rendered = "  ",
              highlight = "GitSignsAdd",
              scope_highlight = nil,
            },
            pro = {
              raw = "[p]",
              rendered = "  ",
              highlight = "DiagnosticVirtualTextInfo",
              scope_highlight = nil,
            },
            con = {
              raw = "[c]",
              rendered = "  ",
              highlight = "DiagnosticVirtualTextError",
              scope_highlight = nil,
            },
            bookmark = {
              raw = "[b]",
              rendered = "  ",
              highlight = "DiagnosticVirtualTextError",
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
              highlight = "DiagnosticVirtualTextInfo",
              scope_highlight = nil,
            },
            down = {
              raw = "[d]",
              rendered = " 󰔳 ",
              highlight = "DiagnosticVirtualTextError",
              scope_highlight = nil,
            },
            win = {
              raw = "[w]",
              rendered = "  ",
              highlight = "CmpItemKindKeyword",
              scope_highlight = nil,
            },
            key = {
              raw = "[k]",
              rendered = "  ",
              highlight = "DiagnosticVirtualTextWarn",
              scope_highlight = nil,
            },
            fire = {
              raw = "[f]",
              rendered = "  ",
              highlight = "DiagnosticVirtualTextError",
              scope_highlight = nil,
            },
          },
        },
      },
    },
  },
}
