#!/bin/sh

set -eu

XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"

state_dir="$XDG_STATE_HOME/dotfiles"
state_file="$state_dir/install-mason-tools.done"

if [ -f "$state_file" ]; then
    echo "INFO: Mason tools were already installed once; skipping" >&2
    exit 0
fi

if ! command -v nvim >/dev/null 2>&1; then
    echo "INFO: neovim is not installed" >&2
    exit 0
fi

echo "INFO: Install Mason tools" >&2

nvim --headless -c "$(
    cat <<'EOF'
lua
  local ok, plugin = pcall(function()
    return require("lazy.core.config").plugins["mason.nvim"]
  end)

  if not ok or not plugin or plugin.enabled == false then
    vim.cmd("qall")
    return
  end

  local opts = require("lazyvim.util").opts("mason.nvim")
  require("utils.mason").filter_ensure_installed(opts)
  vim.opt.rtp:prepend(plugin.dir)
  require("mason").setup(opts)
  require("mason.api.command").MasonInstall(opts.ensure_installed or {}, {
    quiet = true,
  })

  vim.cmd("qall")
EOF
)"

mkdir -p "$state_dir"
date --utc '+%Y-%m-%dT%H:%M:%SZ' >"$state_file"
