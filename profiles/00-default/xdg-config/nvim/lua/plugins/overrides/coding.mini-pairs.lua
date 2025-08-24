---@type LazySpec
return {
  [1] = "mini.pairs",
  optional = true,
  opts = {
    mappings = {
      ['"'] = false,
      ["'"] = false,
      ["`"] = false,
    },
  },
}
