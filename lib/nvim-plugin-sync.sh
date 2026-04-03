#!/bin/sh

set -eu

echo "INFO: Sync lazy.nvim plugin" >&2

nvim --headless -c "$(
    cat <<'EOF'
lua
    vim.api.nvim_create_autocmd("VimEnter", {
        once = true,
        callback = function ()
            require("lazy").sync({wait=true})
            vim.cmd("qall")
        end,
    })
EOF
)"
