-- TEMPORARY DISABLE

---@type LazySpec
return {
  [1] = "snacks.nvim",
  optional = true,
  ---@type snacks.Config
  opts = {
    image = {
      docs = {
        enabled = false,
      },
      math = {
        enabled = false,
      },
    },
  },
}
