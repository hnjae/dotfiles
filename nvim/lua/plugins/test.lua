---@type LazySpec
return {
  -- [1] = "",
  -- dir = "",
  -- dir = vim.fn.stdpath("cache"),
  keys = {
    {
      [1] = "sz",
      [2] = function()
        print("Hello")
      end,
    },
  },
}
