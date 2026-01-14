#!/bin/sh

set -eu

echo "INFO: Restore plugin status to lazy-lock.json" >&2

nvim --headless -c "$(
    cat <<'EOF'
lua
    vim.api.nvim_create_autocmd("VimEnter", {
        once = true,
        callback = function ()
            require("lazy").restore({wait=true})
            vim.cmd("qall")
        end,
    })
EOF
)"
