local choices = {
  { on = "n", by = "natural", desc = "Sort by name" },
  { on = "m", by = "mtime", desc = "Sort by modified time" },
  { on = "s", by = "size", desc = "Sort by size" },
  { on = "e", by = "extension", desc = "Sort by extension" },
  { on = "b", by = "btime", desc = "Sort by birth time" },
  { on = "a", by = "alphabetical", desc = "Sort alphabetically" },
  { on = "r", by = "random", desc = "Sort randomly" },
  { on = "u", by = "none", desc = "Disable sorting" },
}

local cands = {
  { on = "n", desc = "Sort by name" },
  { on = "m", desc = "Sort by modified time" },
  { on = "s", desc = "Sort by size" },
  { on = "e", desc = "Sort by extension" },
  { on = "b", desc = "Sort by birth time" },
  { on = "a", desc = "Sort alphabetically" },
  { on = "r", desc = "Sort randomly" },
  { on = "u", desc = "Disable sorting" },
}

return {
  entry = function()
    local idx = ya.which({ cands = cands })
    if not idx then
      return
    end

    ya.emit("sort", { choices[idx].by })
  end,
}
