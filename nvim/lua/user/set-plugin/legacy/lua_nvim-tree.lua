local status_ok, nvim_tree = pcall(require, 'nvim-tree')
if not status_ok then
  return
end
nvim_tree.setup({
  hijack_directories = {
    enable = true,
    auto_open = true,
  },
  diagnostics = {
    enable = false,
    show_on_dirs = false,
    icons = {
      hint = "",
      info = "",
      warning = "",
      error = "",
    },
  },
})
