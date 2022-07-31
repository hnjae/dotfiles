-- local status_ok, chadtree_settings = pcall(require, "chadtree_settings")
if _IS_PLUGIN("chadtree") then
  local chadtree_settings = {
    ["theme"] = {
      ["icon_glyph_set"] = "devicons",
      ["icon_colour_set"] = "none"
    }
  }
  vim.api.nvim_set_var("chadtree_settings", chadtree_settings)
end
