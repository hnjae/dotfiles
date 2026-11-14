#!/bin/sh

set -eu

XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"

state_dir="$XDG_STATE_HOME/dotfiles"
state_file="$state_dir/install-treesitter-parsers.hash"

hash_stdin() {
    if command -v xxhsum >/dev/null 2>&1; then
        xxhsum | awk '{print $1}'
    elif command -v sha256sum >/dev/null 2>&1; then
        sha256sum | awk '{print $1}'
    elif command -v shasum >/dev/null 2>&1; then
        shasum -a 256 | awk '{print $1}'
    else
        echo "ERROR: sha256sum or shasum is required" >&2
        exit 1
    fi
}

# Hash the Neovim config, so a changed tool list or a new plugin version
# reruns this step while an unchanged config skips it. A timestamp sentinel
# would install once and never again.
config_hash() {
    if [ ! -d "$XDG_CONFIG_HOME/nvim" ]; then
        return 0
    fi
    find "$XDG_CONFIG_HOME/nvim" -type f -print0 |
        LC_ALL=C sort -z |
        xargs -0 -r cat |
        hash_stdin
}

current_hash="$(config_hash)"

if [ -f "$state_file" ] && [ "$(cat "$state_file")" = "$current_hash" ]; then
    echo "INFO: Treesitter parsers are up to date; skipping" >&2
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
printf '%s\n' "$current_hash" >"$state_file"
