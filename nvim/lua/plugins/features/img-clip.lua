---@type LazySpec
return {
  [1] = "HakonHarnes/img-clip.nvim",
  lazy = true,

  ft = {
    "markdown",
    "html",
    "tex",
    "typst",
    "rst",
    "asciidoc",
    "asciidoctor",
    "org",
  },
  cmd = {
    "PasteImage",
    "ImgClipConfig",
    "ImgClipDebug",
  },
  opts = {
    default = {
      file_name = "%Y-%m-%dT%H-%M-%S", ---@type string
      download_images = vim.fn.executable("curl") == 1, ---@type boolean
    },
  },
}
