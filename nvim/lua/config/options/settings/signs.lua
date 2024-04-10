local signs
if require("utils").enable_icon then
  local icons = require("val").icons.signs
  signs = {
    { name = "DiagnosticSignError", text = icons.error .. " " },
    { name = "DiagnosticSignWarn", text = icons.warn .. " " },
    { name = "DiagnosticSignInfo", text = icons.info .. " " },
    { name = "DiagnosticSignHint", text = icons.hint .. " " },
  }
else
  signs = {
    { name = "DiagnosticSignError", text = "E" },
    { name = "DiagnosticSignWarn", text = "W" },
    { name = "DiagnosticSignInfo", text = "I" },
    { name = "DiagnosticSignHint", text = "H" },
  }
end

for _, sign in ipairs(signs) do
  vim.fn.sign_define(
    sign.name,
    { texthl = sign.name, text = sign.text, numhl = "" }
  )
end
