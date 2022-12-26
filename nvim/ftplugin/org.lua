local status_wk, wk = pcall(require, "which-key")
if status_wk then

  wk.register({
    ["$"] = "archive",
    ["'"] = "edit-special",
    ["*"] = "toggle-heading",
    [","] = "set-priority",
    ["A"] = "toggle-archive-tag",
    ["e"] = "exports",
    ["J"] = "move-subtree-down",
    ["K"] = "move-subtree-up",
    ["o"] = "open-at-point",
    ["r"] = "capture-refile-headline-to-dst",
    ["t"] = "set-tag",
  }, { prefix = "<Leader>o", buffer = 0 }
  )

  wk.register({
    ["!"] = "org-time-stamp-inactive",
    ["."] = "org-time-stamp",
    ["d"] = "org-deadline",
    ["h"] = "insert-heading-respect-content",
    ["s"] = "insert/update-schedule",
    ["t"] = "insert-todo-heading-respect-content",
    ["T"] = "insert-todo-heading",
  }, { prefix = "<Leader>oi", buffer = 0 }
  )

  wk.register({
    ["e"] = "org-set-effort",
    ["i"] = "org-clock-in",
    ["j"] = "org-clock-goto",
    ["o"] = "org-clock-out",
    ["q"] = "org-clock-cancel",
  }, { prefix = "<Leader>ox", buffer = 0 }
  )
end
