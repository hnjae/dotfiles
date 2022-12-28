local M = {}
M.setup = function()
  local status_ok, lualine = pcall(require, "lualine")
  if not status_ok then
    return
  end

  local encoding_opt = {
    "encoding",
    cond = function()
      return vim.opt_local.encoding:get() ~= "utf-8"
    end
  }
  local fileformat_opt = {
    "fileformat",
    cond = function()
      return vim.opt_local.fileformat:get() ~= "unix"
    end
  }

  local ime = {
    -- ime status
    function()

      local fcitx5_status = vim.fn.system("fcitx5-remote")
      if fcitx5_status == 1 then
        return "🇺🇸"
      end

      return fcitx5_status
    end,
    icon = '',
    cond = function()
      return next(vim.lsp.get_active_clients()) ~= nil
    end
    -- color = { fg = '#ffffff', gui = 'bold' },
  }

  -- A = vim.fn.call(coc#status())
  -- local coc = {
  --   -- Lsp server name
  --   function()
  --     eturn vim.api.nvim_call_function("coc#status", {})
        -- -- set statusline^=%{coc#status()}
  --     -- return "stst"
  --   end,
  --   icon = '',
  --   cond = function()
  --     return _IS_PLUGIN("coc.nvim") ~= nil
  --   end
  --   -- color = { fg = '#ffffff', gui = 'bold' },
  -- }

  local has_lspconfig, _ = pcall(require, "lspconfig")
  local lsp = {
    -- Lsp server name .
    function()
      local msg = 'No Active Lsp'
      -- local buf_ft = vim.api.nvim_buf_get_option(0, 'filetype')
      local buf_ft = vim.opt_local.filetype:get()
      local clients = vim.lsp.get_active_clients()
      if next(clients) == nil then
        return msg
      end

      -- local ft_clients = {}
      -- local num_ft_clients = 0
      local modified_msg = ""
      local is_first_client = true
      for _, client in ipairs(clients) do
        local filetypes = client.config.filetypes
        if (
            (filetypes and vim.fn.index(filetypes, buf_ft) ~= -1)
                or (buf_ft == "java" and client.name == "jdt.ls")
            ) then
          if is_first_client then
            modified_msg = client.name
            is_first_client = false
          else
            modified_msg = modified_msg ..  ", " .. client.name
          end
        end
      end

      if modified_msg ~= "" then
        return modified_msg
      end

      return msg
    end,
    icon = '',
    cond = function()
      return has_lspconfig and (next(vim.lsp.get_active_clients()) ~= nil)
    end
    -- color = { fg = '#ffffff', gui = 'bold' },
  }


  -- local theme = {
  --   normal = {
  --     a = { fg = colors.white, bg = colors.black },
  --     b = { fg = colors.white, bg = colors.grey },
  --     c = { fg = colors.black, bg = colors.white },
  --     z = { fg = colors.white, bg = colors.black },
  --   },
  --   insert = { a = { fg = colors.black, bg = colors.light_green } },
  --   visual = { a = { fg = colors.black, bg = colors.orange } },
  --   replace = { a = { fg = colors.black, bg = colors.green } },
  -- }

  local get_theme = function()
    local background = vim.opt_local.background:get()
    if vim.g.colors_name == "vscode" and background == "dark" then
      -- vscode's lualine theme sucks
      return "codedark"
    end
    return "auto"
  end


  lualine.setup {
    options = {
      icons_enabled = true,
      -- theme = 'codedark',
      theme = get_theme(),
      -- theme = 'vscode',
      -- component_separators = { left = '', right = '' },
      component_separators = { left = '|', right = '|' },
      -- component_separators = { left = '', right = '' },
      section_separators = { left = '', right = '' },
      disabled_filetypes = {}, -- Filetypes to disable lualine for.
      always_divide_middle = true, -- When set to true, left sections i.e. 'a','b' and 'c'
      -- can't take over the entire statusline even
      -- if neither of 'x', 'y' or 'z' are present.
      globalstatus = false, -- enable global statusline (have a single statusline
      -- at bottom of neovim instead of one for  every window).
      -- This feature is only available in neovim 0.7 and higher.
    },
    sections = {
      lualine_a = { 'mode',  },
      lualine_b = { 'diagnostics', 'branch', 'diff'  },
      lualine_c = { 'filename' },
      lualine_x = { lsp, encoding_opt, fileformat_opt, "filetype" },
      lualine_y = { 'progress' },
      lualine_z = { 'location' }
      -- lualine_y = {},
      -- lualine_z = {  'progress', 'location' }
    },
    inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = { 'filename' },
      lualine_x = { 'location' },
      lualine_y = {},
      lualine_z = {}
    },
    tabline = {
      -- lualine_a = { "buffers" },
      -- lualine_b = { 'branch' },
      -- lualine_c = {tabline.tabline_buffers },
      -- lualine_x = {tabline.tabline_tabs},
      -- lualine_y = {},
      -- lualine_z = { "tabs" }
    },
    extensions = {}
  }

end
return M
