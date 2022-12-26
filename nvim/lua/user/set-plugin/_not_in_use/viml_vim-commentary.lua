-- commentary.txt

-- gc{motion}
if _IS_PLUGIN('vim-commentary') then
  local status_wk, wk = pcall(require, "which-key")
  if status_wk then
    wk.register({["gc"] = "commentary"})
    wk.register({
      ["c"] = "line",
      ["u"] = {name = "current-and-adjacent"},
    }, {prefix="gc"})
  end
end
