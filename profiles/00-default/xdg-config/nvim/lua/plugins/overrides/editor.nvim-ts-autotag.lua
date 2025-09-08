---@type LazySpec
return {
  [1] = "nvim-ts-autotag",
  optional = true,
  opts = {
    per_filetype = {
      ["markdown"] = {
        enable_close = false,
      },
    },
  },
}
