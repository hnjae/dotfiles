#!/bin/sh

set -eu

if ! command -v nvim >/dev/null 2>&1; then
    echo "INFO: neovim is not installed" >&2
    exit 0
fi

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
