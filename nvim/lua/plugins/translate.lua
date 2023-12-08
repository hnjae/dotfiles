return {
  "uga-rosa/translate.nvim",
  lazy = true,
  cmd = {
    "Translate",
  },
  opts = {
    default = {
      -- command = "deepl_pro",
      output = "split"
    },
    preset = {
      output = {
        split = {
          append = true,
        },
      },
    },
  },
}
