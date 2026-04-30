#!/bin/sh

set -eu

XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"

state_dir="$XDG_STATE_HOME/dotfiles"
state_file="$state_dir/install-treesitter-parsers.done"

if [ -f "$state_file" ]; then
    echo "INFO: Treesitter parsers were already installed once; skipping" >&2
    exit 0
fi

if ! command -v nvim >/dev/null 2>&1; then
    echo "INFO: neovim is not installed" >&2
    exit 0
fi

nvim --headless -c "$(
    cat <<'EOF'
lua
  local ok, plugin = pcall(function()
    return require("lazy.core.config").plugins["nvim-treesitter"]
  end)

  if not ok or not plugin or plugin.enabled == false then
    vim.cmd("qall")
    return
  end

  local opts = require("lazyvim.util").opts("nvim-treesitter")
  local seen, install = {}, {}
  for _, lang in ipairs(opts.ensure_installed or {}) do
    if not seen[lang] then
      seen[lang] = true
      install[#install + 1] = lang
    end
  end

  local TS = require("nvim-treesitter")
  require("lazyvim.util.treesitter").build(function()
    TS.install(install, { summary = true }):await(function()
      vim.cmd("qall")
    end)
  end)
EOF
)"

mkdir -p "$state_dir"
date --utc '+%Y-%m-%dT%H:%M:%SZ' >"$state_file"
