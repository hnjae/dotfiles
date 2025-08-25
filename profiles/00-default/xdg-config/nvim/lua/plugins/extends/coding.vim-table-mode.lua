---@type LazySpec
return {
  [1] = "dhruvasagar/vim-table-mode",
  lazy = true,
  event = {},
  ft = { "markdown" },
  cmd = {
    "TableModeToggle",
    "TableModeEnable",
    "Tableize",
    "TableModeDisable",
    "TableModeRealign",
    "TableAddFormula",
    "TableEvalFormulaLine",
    "TableSort",
  },
  init = function()
    vim.g.table_mode_disable_mappings = 1
    vim.g.table_mode_corner = "|"
  end,
}
