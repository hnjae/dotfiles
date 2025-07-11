# zmodload zsh/zprof

if [[ "$TERM" != "dumb" ]] && (( $+commands[pfetch] )); then
  PF_INFO="ascii title os host kernel uptime memory shell" pfetch
fi

#################################################
# interactive shell 설정
#################################################
alias vi="nvim"

case "$OSTYPE" in
  linux*)
    export LC_TIME="en_IE.UTF-8"
    ;;
  *)
    ;;
esac

if [[ $(hostname) == "isis" ]]; then
  # temp
  export DISABLE_LAYER_AMD_SWITCHABLE_GRAPHICS_1="1"
  export VK_DRIVER_FILES="/run/current-system/sw/share/vulkan/icd.d/amd_icd64.json"

  # cd to commonly used directories
  alias sp='cd "$HOME/Projects"'
  alias sn='cd "$HOME/Projects/nix-config"'
  alias sf='cd "$HOME/Projects/dotfiles"'
  alias sv='cd "$HOME/Projects/dotfiles/nvim"'
  alias sz='cd "$HOME/Projects/dotfiles/zsh/xdg.config.home"'
  alias so='cd "${XDG_DOCUMENTS_DIR:-$HOME/Documents}/obsidian/home"'

  # det commonly used files
  alias ed='vi "${XDG_DOCUMENTS_DIR:-$HOME/Documents}/obsidian/home/dailies/$(date +"%Y-%m-%d").md"'
  alias ew='vi "${XDG_DOCUMENTS_DIR:-$HOME/Documents}/obsidian/home/weeklies/$(date +"%G-W%V").md"'
fi

# EDITOR가 vi 이여도, ^A, ^E 같은 emacs 키는 사용할 수 있게 설정
# https://github.com/simnalamburt/.dotfiles/blob/997d482/.zshrc
if (( $+commands[vim] )) || (( $+commands[nvim] )); then
  bindkey '^A' beginning-of-line
  bindkey '^E' end-of-line
fi

#################################################
# History 설정
#################################################

HISTSIZE="99999"
SAVEHIST="99999"
HISTORY_IGNORE='(cd *|s *|z *|zi *|si *|rm *|sudo rm *|trash *|trash-put *|trash-rm *|trash-empty|mv|pfkill *|exit|fg|bg|zfs destroy *|zpool destroy *|btrfs subvolume delete *|sudo zfs destroy *|sudo zpool destroy *|sudo btrfs subvolume delete *|* --please-destroy-my-drive *|reboot|shutdown|halt|kexec|systemctl reboot|systemctl halt|systemctl poweroff|systemctl kexec|systemctl soft-reboot|man *|just *|rg *|vi *|vim *|nvim *|nano *|which *|command *|stat *|xdg-open *|mpv *|psql *|git*--hard*)'
HISTFILE="${XDG_DATA_HOME:-$HOME/.local/data}/.zsh_history"

setopt HIST_FCNTL_LOCK
unsetopt APPEND_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
unsetopt HIST_SAVE_NO_DUPS
unsetopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_EXPIRE_DUPS_FIRST
setopt SHARE_HISTORY
setopt EXTENDED_HISTORY


#################################################
# zsh-abbr 설정
#################################################
# typeset -g ABBR_EXPAND_PUSH_ABBREVIATION_TO_HISTORY=1
# typeset -g ABBR_GET_AVAILABLE_ABBREVIATION=1
# typeset -g ABBR_LOG_AVAILABLE_ABBREVIATION=1
#
# # alias 에서 import 해서 사용할 예정이라 ~/.config 에 위치하지 않도록 한다.
# typeset -g ABBR_USER_ABBREVIATIONS_FILE="${XDG_STATE_HOME:-${HOME}/.local/state}/zsh-abbr-user"
#
# function sync-abbr() {
#     if [[ "$ABBR_USER_ABBREVIATIONS_FILE" != "" && -f "$ABBR_USER_ABBREVIATIONS_FILE" ]]; then
#       rm "$ABBR_USER_ABBREVIATIONS_FILE"
#     fi
#
#     abbr import-aliases
# }

#################################################
# ZVM 설정
#################################################
ZVM_CURSOR_STYLE_ENABLED=false
# ZVM_LINE_INIT_MODE=$ZVM_MODE_INSERT
ZVM_INIT_MODE=sourcing

#################################################
# 기타 플러그인 설정
#################################################
export FZF_DEFAULT_OPTS="--color=16,border:8 --layout=reverse --height=22 --marker=░"
# if (( $+commands[fd] )); then
#   # export FZF_ALT_C_COMMAND="command fd -H --no-ignore-vcs -E .git -td"
#   # export FZF_CTRL_T_COMMAND="command fd -H --no-ignore-vcs -E .git -td -tf"
# #   export FZF_ALT_C_COMMAND="command fd -H -L --min-depth 1 --exclude \".cache\" --exclude \".direnv\" --exclude \".git\" --exclude \".github\" --exclude \".gitlab\" --exclude \".idea\" --exclude \".vscode\" --exclude \".vscode-server\" --exclude \".zed\" --exclude \"node_modules\" --exclude \".mypy_cache\" --exclude \".ruff_cache\" --exclude \".__pycache__\" --type d --one-file-system . 2>/dev/null"
# # export FZF_CTRL_T_COMMAND="command fd -H -L --min-depth 1 --exclude \".cache\" --exclude \".direnv\" --exclude \".git\" --exclude \".github\" --exclude \".gitlab\" --exclude \".idea\" --exclude \".vscode\" --exclude \".vscode-server\" --exclude \".zed\" --exclude \"node_modules\" --exclude \".mypy_cache\" --exclude \".ruff_cache\" --exclude \".__pycache__\" --exclude \".DS_Store\" --exclude \"*.pyc\" --exclude \"*.swp\" --exclude \"*.thumbsnail\" --type f --type d --type l --one-file-system . 2>/dev/null"
# # export _ZO_FZF_OPTS="--color=16,border:8 --layout=reverse --height=22 --marker=░ --scheme=path"
# fi

ZSH_AUTOSUGGEST_STRATEGY=(match_prev_cmd completion)
zstyle ':fzf-tab:*' use-fzf-default-opts yes

################################################################################
# Bootstrap zimfw
################################################################################
zstyle ':zim:zmodule' use 'degit'
typeset -g ZIM_HOME="${XDG_STATE_HOME:-${HOME}/.local/state}/zim"

if [[ ! -f "${ZDOTDIR:-${HOME}}/.zimrc" ]]; then
    echo "ERROR: .zimrc not found."
    return
fi

# Download zimfw plugin manager if missing.
if [[ ! -e ${ZIM_HOME}/zimfw.zsh ]]; then
    echo "[INFO] Installing ZIM."
    if (( $+commands[curl] )); then
        curl -fsSL --create-dirs -o "${ZIM_HOME}/zimfw.zsh" \
            "https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh"
    elif (( $+commands[wget] )); then
        mkdir -p "${ZIM_HOME}" && wget -nv -O "${ZIM_HOME}/zimfw.zsh" \
            "https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh"
    else
        echo "ERROR: Neither curl nor wget is available to download ZIM."
        return
    fi
fi

# Install missing modules, and update ${ZIM_HOME}/init.zsh if missing or outdated.
if [[ ! "${ZIM_HOME}/init.zsh" -nt "${ZDOTDIR:-${HOME}}/.zimrc" ]]; then
    echo "[INFO] Installing ZIM modules..."
    source "${ZIM_HOME}/zimfw.zsh" init -q
fi

# Initialize modules.
source "${ZIM_HOME}/init.zsh"

# zprof | wl-copy
