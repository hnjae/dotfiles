-- UI

local lualine_spec =  {
  'nvim-lualine/lualine.nvim',
  dependencies={
    'kyazdani42/nvim-web-devicons',
  },
  lazy=false,
  priority=1,
}

lualine_spec.config = function()
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
      -- NOTE: vscode's lualine theme sucks
      return "codedark"
    end
    return "auto"
  end


  require("lualine").setup {
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

local tabline_spec =  {
  'kdheepak/tabline.nvim',
  lazy=false,
  priority=1,
  config=function()
    require("tabline").setup {
      -- Defaults configuration options
      enable = true,
      options = {
        -- If lualine is installed tabline will use separators configured in lualine by default.
        -- These options can be used to override those settings.
        -- section_separators = {'', ''},
        -- component_separators = {'', ''},
        -- section_separators = {'', ''},
        -- component_separators = {'', ''},
        -- max_bufferline_percent = 66, -- set to nil by default, and it uses vim.o.columns * 2/3
        -- show_tabs_always = false, -- this shows tabs only when there are more than one tab or if the first tab is named
        -- show_devicons = true, -- this shows devicons in buffer section
        -- show_bufnr = false, -- this appends [bufnr] to buffer section,
        -- show_filename_only = false, -- shows base filename only instead of relative path in filename
        -- modified_icon = "+ ", -- change the default modified icon
        -- modified_italic = false, -- set to true by default; this determines whether the filename turns italic if modified
        -- show_tabs_only = true, -- this shows only tabs instead of tabs + buffers
      }
    }
    -- vim.cmd[[
    --   set guioptions-=e " Use showtabline in gui vim
    --   set sessionoptions+=tabpages,globals " store tabpages and globals in session
    -- ]]
    end
}



return {
  lualine_spec,
  tabline_spec,
  {
    'akinsho/bufferline.nvim',
    tag = "v3.1.0",
    dependencies = { 'kyazdani42/nvim-web-devicons' }
  },
  -----------------------------------------------------------------------------
  -- 
  -----------------------------------------------------------------------------
  {
    'rcarriga/nvim-notify',
    lazy=true,
    config=function()
      vim.opt.termguicolors = true
      -- replace builtin notify
      -- vim.notify = require("notify")
    end
  },
  -----------------------------------------------------------------------------
  -- LSP-related
  -----------------------------------------------------------------------------
  {
    -- shows popup window about parameter/func
    -- NOTE: activated when on_attach() happens / or call .setup() in init.lua
    'ray-x/lsp_signature.nvim',
    lazy = true,
    -- config = function() require('lsp_signature').setup() end,
  },
  {
    -- adds vscode-like pictograms to neovim built-in lsp
    -- NOTE: should be init/configured in lsp/cmp settings
    'onsails/lspkind.nvim',
    lazy = true,
  },
  -----------------------------------------------------------------------------
  -- shows things
  -----------------------------------------------------------------------------
  {
    -- shows indent line
    'lukas-reineke/indent-blankline.nvim',
    lazy=false
  },
  {
    -- m의 mark 가 보이게 해준다.
    'kshenoy/vim-signature',
    lazy=false,
    config=function()
      --[[
        이유는 모르지만 vim-commentary 와 gc 에서 mapping 이 충돌.
        vim-surrounded
      --]]
      vim.g.SignatureMap = {
        -- ['Leader']            = "m",
        -- ['PlaceNextMark']     = "m,",
        -- ['ToggleMarkAtLine']  = "m.",
        -- ['PurgeMarksAtLine']  = "m-",
        -- ['PurgeMarks']        = "m<Space>",
        ['Leader']            = "m",
        ['PlaceNextMark']     = "",
        ['ToggleMarkAtLine']  = "",
        ['PurgeMarksAtLine']  = "",
        ['PurgeMarks']        = "",
        --
        ['PurgeMarkers']      = "",
        ['ListBufferMarks']   = "",
        ['ListBufferMarkers'] = "",
        ------
        ['DeleteMark']        = "",
        ------
        -- ['GotoNextLineAlpha']  =  "']",
        -- ['GotoPrevLineAlpha']  =  "'[",
        ['GotoNextLineAlpha'] = "", -- 기본 맵핑이 있음
        ['GotoPrevLineAlpha'] = "", -- 기본 맵핑이 있음
        ['GotoNextSpotAlpha'] = "", -- 기본 맵핑이 있음
        ['GotoPrevSpotAlpha'] = "", -- 기본 맵핑이 있음
        ------
        ['GotoNextLineByPos'] = "",
        ['GotoPrevLineByPos'] = "",
        ['GotoNextSpotByPos'] = "",
        ['GotoPrevSpotByPos'] = "",
        ['GotoNextMarker']    = "",
        ['GotoPrevMarker']    = "",
        ['GotoNextMarkerAny'] = "",
        ['GotoPrevMarkerAny'] = "",
      }

      local status_wk, wk = pcall(require, "which-key")
      if status_wk then
        wk.register({
          -- ["m,"] = { "place-next-mark" },
          -- ["m."] = { "toggle-mark-at-line" },
          -- ["m-"] = { "purge-marks-at-line" },
          -- ["m "] = { "purge-marks-at-buffer" },
          -- ["m/"] = { "list-buffer-marks" },
          -- ["m?"] = { "list-buffer-markers" },
          ----
          ["dm"] = { "delete-mark" },
          ----
          -- ["'["] = { "goto-prev-line-alpha" },
          -- ["']"] = { "goto-next-line-alpha" },
          -- ["`["] = { "goto-prev-spot-alpha" },
          -- ["`]"] = { "goto-next-spot-alpha" },
          ----
          -- ["]`"] = { "signature-spot-by-pos" },
          -- ["[`"] = { "signature-spot-by-pos" },
          -- ["['"] = { "signature-line-by-pos" },
          -- ["]'"] = { "signature-line-by-pos" },
          -- ["]-"] = { "signature-marker" },
          -- ["[-"] = { "signature-marker" },
          -- ["[="] = { "signature-marker-any" },
          -- ["]="] = { "signature-marker-any" },
        })
      end
    end
  },
}
