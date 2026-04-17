---@type LazySpec
return {
  [1] = "nvim-mini/mini.trailspace",
  version = "*",
  lazy = true,
  event = { "BufWritePre", "FileAppendPre", "FileWritePre" },
}
