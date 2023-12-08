return {
  "nvim-lualine/lualine.nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  lazy = false,
  priority = 1, -- default 50
  opts = function()
    --@type theme string
    local theme = "auto"
    if vim.g.colors_name == "vscode" and vim.opt_local.background:get() == "dark" then
      -- NOTE: vscode's lualine theme sucks
      theme = "codedark"
    end


    local status_luasnip, luasnip = pcall(require, "luasnip")
    local luasnip_opt = {
      function()
        if luasnip.locally_jumpable() then
          return "JUMPABLE"
        else
          return ""
        end
      end,
      icon = "",
      cond = function()
        return status_luasnip
      end,
      color = 'Pmenu',
      -- Automatically updates active buffer color to match color of other components (will be overidden if buffers_color is set)
      use_mode_colors = false,
    }

    local buffers_opt = {
      'buffers',
      mode = 4, -- show buffer name + buffer number
      buffers_color = {
        active = 'BufferCurrent',
        inactive = 'BufferInactive',
      },
      -- symbols = {
      --   modified = ' '
      -- }
    }

    local spell_opt = {
      function()
        -- for _, lang in ipairs(vim.opt_local.spelllang:get()) do
        -- end
        return "on"
      end,
      icon = "󰓆",
      cond = function()
        return vim.opt_local.spell:get()
      end,
    }

    local encoding_opt = {
      "encoding",
      cond = function()
        return vim.opt_local.encoding:get() ~= "utf-8"
      end,
    }

    local fileformat_opt = {
      "fileformat",
      cond = function()
        return vim.opt_local.fileformat:get() ~= "unix"
      end,
    }

    local lsp_opt = {
      -- Lsp server name .
      function()
        local msg = "No Active LSP"
        -- local buf_ft = vim.api.nvim_buf_get_option(0, 'filetype')
        -- local buf_ft = vim.opt_local.filetype:get()

        local clients = vim.lsp.get_active_clients({ bufnr = 0 })
        if next(clients) == nil then
          return msg
        end

        -- local ft_clients = {}
        -- local num_ft_clients = 0
        --@type string
        local modified_msg = ""
        local is_first_client = true
        for _, client in ipairs(clients) do

          local client_name = nil
          if client.name:sub(-16, -1) == "_language_server" then
            client_name = client.name:sub(1, -17) .. "_ls"
          -- elseif client.name:sub(-2, -1) == "ls" and client.name:sub(-3,-3) ~= "_" then
            -- TODO: use regex <2023-06-09>
            -- client_name = client.name:sub(1,-3) .. "_ls"
          else
            client_name = client.name
          end

          if is_first_client then
            modified_msg = client_name
            is_first_client = false
          else
            modified_msg = modified_msg .. ", " .. client_name
          end
        end

        if modified_msg ~= "" then
          return modified_msg
        end

        return msg
      end,
      icon = "",
      cond = function()
        return (next(vim.lsp.get_active_clients()) ~= nil)
      end,
      -- color = { fg = '#ffffff', gui = 'bold' },
    }

    local opt_extensions = {
      {
        sections = {
          lualine_a = {
            {
              function()
                return " "
              end,
            },
          },
          lualine_c = { "filename" },
          lualine_x = { "filetype" },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
        inactive_sections = {
          lualine_c = { "filename" },
          lualine_x = { "location" },
        },
        filetypes = { "help" },
      },
      {
        sections = {
          lualine_a = {
            {
              function()
                return " "
              end,
            },
          },
          lualine_c = { "filetype" },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
        inactive_sections = {
          lualine_c = { "filetype" },
          lualine_x = { "location" },
        },
        filetypes = {
          "tagbar",
          "dbui",
          "dbout",
          "startify",
          "toggleterm",
          "alpha",
          -- symbols-outline
          "Outline",
        },
      },
      {
        sections = {
          lualine_a = {
            {
              function()
                return " "
              end,
            },
          },
          lualine_c = {
            {
              function()
                return vim.fn.fnamemodify(vim.fn.getcwd(), ":~")
              end,
            },
          },
        },
        inactive_sections = {
          lualine_c = { "filetype" },
        },
        filetypes = { "NvimTree" },
      },
      {
        sections = {
          lualine_a = { "mode" },
          lualine_c = {
            {
              function()
                return " " .. vim.fn.FugitiveHead()
              end,
            },
          },
          lualine_x = { "filetype" },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
        inactive_sections = {
          -- lualine_c = { 'filetype' },
          lualine_c = {
            {
              function()
                return " " .. vim.fn.FugitiveHead()
              end,
            },
          },
          lualine_x = { "location" },
        },
        filetypes = { "fugitive" },
      },
      "quickfix",
      -- 'nvim-dap-ui',
    }

    local opts = {
      options = {
        icons_enabled = true,
        theme = theme,
        -- component_separators = { left = '', right = '' },
        component_separators = { left = "|", right = "|" },
        section_separators = { left = "", right = "" },
        disabled_filetypes = {},     -- Filetypes to disable lualine for.
        always_divide_middle = true, -- When set to true, left sections i.e. 'a','b' and 'c'
        -- can't take over the entire statusline even
        -- if neither of 'x', 'y' or 'z' are present.
        globalstatus = false, -- enable global statusline (have a single statusline
        -- at bottom of neovim instead of one for  every window).
        -- This feature is only available in neovim 0.7 and higher.
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "diagnostics", "branch", "diff" },
        lualine_c = { "filename" },
        lualine_x = { spell_opt, lsp_opt, encoding_opt, fileformat_opt, "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
        -- lualine_y = {},
        -- lualine_z = {  'progress', 'location' }
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { "filename" },
        lualine_x = { "location" },
        lualine_y = {},
        lualine_z = {},
      },
      tabline = {
        lualine_a = { luasnip_opt, },
        -- lualine_b = {  },
        -- lualine_c = { 'filename' },
        -- lualine_c = {tabline.tabline_buffers },
        -- lualine_x = {tabline.tabline_tabs},
        lualine_y = { buffers_opt },
        lualine_z = { "tabs" },
      },
      extensions = opt_extensions,
    }

    return opts
  end,
}
