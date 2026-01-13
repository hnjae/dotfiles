-- NOTE: enable ai.copilot from LazyVim Extra

---@type LazySpec[]
return {
  [1] = "copilot.lua",
  optional = true,
  enabled = true,
  keys = {
    {
      [1] = "<leader>ua",
      [2] = "<cmd>Copilot toggle<CR>",
      desc = "copilot-toggle",
      remap = true,
    },
  },
  opts = {
    filetypes = {
      sh = function()
        local bufname = vim.api.nvim_buf_get_name(0)
        local basename = vim.fs.basename(bufname)

        -- Disable for `.env` files
        if string.match(basename, "^%.env.*") or string.match(basename, "env") then
          return false
        elseif vim.startswith(bufname, "/tmp/") then
          return false
        end

        return true
      end,

      nix = function()
        if string.match(vim.api.nvim_buf_get_name(0), "^.*-encrypted.nix") then
          return false
        end
        return true
      end,

      -- data-formats
      conf = false,
      csv = false,
      ini = false,
      json = false,
      jsonc = false,
      toml = false,
      xml = false,
      yaml = false,

      -- plain text accounting (ledger)
      ledger = false,
      beancount = false,

      -- docs
      text = false,
      markdown = false,
      org = false,
      norg = false,
      asciidoctor = false,
      asciidoc = false,
      rst = false,
      help = false,
      [""] = false,
      typst = false,
      tex = false,

      -- version-control
      gitcommit = false,
      gitrebase = false,
      hgcommit = false,
      svn = false,
      cvs = false,

      --
      c = true,
      rust = true,
      java = true,
      lua = true,
      python = true,
      typescript = true,
      javascript = true,
      ["yaml.ansible"] = true,
      ["*"] = true,
    },
  },
}
