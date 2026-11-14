#!/bin/sh

set -eu

_log_stderr_is_journal() {
    _log_stderr_id=

    if [ "${JOURNAL_STREAM:-}" = "" ] || [ -t 2 ]; then
        return 1
    fi

    # `/proc/$$`, not `/proc/self`: `self` here is `stat`, whose stderr the
    # redirection has already pointed at /dev/null.
    if _log_stderr_id=$(stat -Lc '%d:%i' "/proc/$$/fd/2" 2>/dev/null); then
        if [ "$_log_stderr_id" = "$JOURNAL_STREAM" ]; then
            return 0
        fi
        return 1
    fi

    # Cannot inspect stderr's identity; trust the inherited variable.
    return 0
}

_log_init() {
    # _log_who="$(basename -- "$0")"

    if [ "${LOG_SYSTEMD:-}" = "1" ]; then
        _log_systemd=1
    elif [ "${LOG_SYSTEMD:-}" = "0" ]; then
        _log_systemd=0
    elif _log_stderr_is_journal; then
        _log_systemd=1
    else
        _log_systemd=0
    fi

    if [ "$_log_systemd" = "1" ] || [ ! -t 2 ] || [ "${NO_COLOR:-}" != "" ]; then
        _log_color_reset=''
        _log_color_bright_black=''
        _log_color_red=''
        _log_color_yellow=''
        _log_color_blue=''
        _log_color_cyan=''
    else
        _log_esc=$(printf '\033')
        _log_color_reset="${_log_esc}[0m"
        _log_color_bright_black="${_log_esc}[90m"
        _log_color_red="${_log_esc}[31m"
        _log_color_yellow="${_log_esc}[33m"
        _log_color_blue="${_log_esc}[34m"
        _log_color_cyan="${_log_esc}[36m"
        _log_color_magenta="${_log_esc}[35m"
    fi

}

_log_init

log() {
    _log_severity="${1:-UNKNOWN}"

    if [ "$#" -gt 0 ]; then
        shift
    fi

    _log_message=$*

    case "$_log_severity" in
    ERR)
        _log_priority=3
        _log_severity_color=$_log_color_red
        ;;
    WARNING)
        _log_priority=4
        _log_severity_color=$_log_color_yellow
        ;;
    NOTICE)
        _log_priority=5
        _log_severity_color=$_log_color_cyan
        ;;
    INFO)
        _log_priority=6
        _log_severity_color=$_log_color_blue
        ;;
    DEBUG)
        _log_priority=7
        _log_severity_color=$_log_color_bright_black
        ;;
    *)
        _log_priority=6
        _log_severity="UNKNOWN"
        _log_severity_color=$_log_color_reset
        ;;
    esac

    if [ "$_log_systemd" = "1" ]; then
        printf '<%s>%s: %s\n' \
            "$_log_priority" \
            "$_log_severity" \
            "$_log_message" >&2
        return
    fi

    _log_timestamp=$(date '+%Y-%m-%dT%H:%M:%S%z')

    printf '%s[%s]%s %s%s%s: %s\n' \
        "$_log_color_bright_black" \
        "$_log_timestamp" \
        "$_log_color_reset" \
        "$_log_severity_color" \
        "$_log_severity" \
        "$_log_color_reset" \
        "$_log_message" >&2
}

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

main() {
    XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
    XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"

    state_dir="$XDG_STATE_HOME/dotfiles"
    state_file="$state_dir/install-mason-tools.hash"
    current_hash="$(config_hash)"

    if [ -f "$state_file" ] && [ "$(cat "$state_file")" = "$current_hash" ]; then
        log "INFO" "Mason tools are up to date; skipping"
        exit 0
    fi

    if ! command -v nvim >/dev/null 2>&1; then
        log "NOTICE" "neovim is not installed"
        exit 0
    fi

    log "INFO" "Installing Mason tools"

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
    printf '%s\n' "$current_hash" >"$state_file"
}

main
