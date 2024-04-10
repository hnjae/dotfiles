local package_path = (...)

-- shows popup window about parameter/func
---@type LazySpec|LazySpec[]
return require(package_path .. ".cmp")
