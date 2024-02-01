---@type LazySpec
return {
  [1] = "habamax/vim-asciidoctor",
  lazy = true,
  ft = { "asciidoc", "asciidoctor" },
  init = function()
    local is_luasnip, luasnip = pcall(require, "luasnip")
    if is_luasnip then
      luasnip.filetype_extend("asciidoctor", { "asciidoc" })
    end

    -- NOTE: handlr can not handle asciidoc file.
    -- It recognize it as text file.
    local browser = os.getenv("BROWSER")
    if browser == nil then
      if vim.fn.has("linux") and vim.fn.executable("flatpak") then
        browser = "flatpak run org.mozilla.firefox --"
      elseif vim.fn.executable("firefox") == 1 then
        browser = "firefox --"
      elseif vim.fn.executable("chromium") then
        browser = "chromium --"
      end
    end
    if browser then
      vim.g.asciidoctor_opener = "!" .. browser
    end

    vim.g.asciidoctor_folding = 1
    vim.g.asciidoctor_syntax_indented = 1
    vim.g.asciidoctor_fenced_languages = {
      "html",
      "python",
      "java",
      "kotlin",
      "sh",
      "ruby",
      "dockerfile",
      "sql",
      "c",
      "nix",
      "typescript",
      "javascript",
    }
    vim.g.asciidoctor_syntax_conceal = 1

    local keys = {
      {
        "n",
        require("val").prefix.buffer .. "p",
        "<cmd>AsciidoctorOpenRAW<CR>",
        { desc = "preview", buffer = 0, silent = true, noremap = true },
      },
    }

    vim.api.nvim_create_autocmd({ "FileType" }, {
      pattern = { "asciidoc", "asciidoctor" },
      callback = function()
        for _, key in pairs(keys) do
          vim.keymap.set(unpack(key))
        end
      end,
    })
  end,
}
