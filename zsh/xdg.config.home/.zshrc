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

    # temp
    export DISABLE_LAYER_AMD_SWITCHABLE_GRAPHICS_1="1"
    export VK_DRIVER_FILES="/run/current-system/sw/share/vulkan/icd.d/amd_icd64.json"
    ;;
  *)
    ;;
esac

# EDITOR가 vi 이여도, ^A, ^E 같은 emacs 키는 사용할 수 있게 설정
# https://github.com/simnalamburt/.dotfiles/blob/997d482/.zshrc
if (( $+commands[vim] )) || (( $+commands[nvim] )); then
  bindkey '^A' beginning-of-line
  bindkey '^E' end-of-line
fi


HISTSIZE="99999"
SAVEHIST="99999"
HISTORY_IGNORE='(cd *|s *|z *|zi *|si *|rm *|sudo rm *|trash *|trash-put *|trash-rm *|trash-empty|mv|rcp *|rmv *|pfkill *|exit|fg|bg|zfs destroy *|zpool destroy *|btrfs subvolume delete *|sudo zfs destroy *|sudo zpool destroy *|sudo btrfs subvolume delete *|* --please-destroy-my-drive *|reboot|shutdown|halt|kexec|systemctl reboot|systemctl halt|systemctl poweroff|systemctl kexec|systemctl soft-reboot|man *|just *|rg *|vi *|vim *|nvim *|nano *|which *|command *|stat *|xdg-open *|mpv *)'
HISTFILE="${XDG_STATE_HOME:-$HOME/.local/state}/zsh_history"

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
typeset -g ABBR_EXPAND_PUSH_ABBREVIATION_TO_HISTORY=1
typeset -g ABBR_GET_AVAILABLE_ABBREVIATION=1
typeset -g ABBR_LOG_AVAILABLE_ABBREVIATION=1

# alias 에서 import 해서 사용할 예정이라 ~/.config 에 위치하지 않도록 한다.
typeset -g ABBR_USER_ABBREVIATIONS_FILE="${XDG_STATE_HOME:-${HOME}/.local/state}/zsh-abbr-user"

function abbr-update() {
    if [[ "$ABBR_USER_ABBREVIATIONS_FILE" != "" && -f "$ABBR_USER_ABBREVIATIONS_FILE" ]]; then
      rm "$ABBR_USER_ABBREVIATIONS_FILE"
    fi

    abbr import-aliases
}

#################################################
# ZVM 설정
#################################################
ZVM_CURSOR_STYLE_ENABLED=false
# ZVM_LINE_INIT_MODE=$ZVM_MODE_INSERT
ZVM_INIT_MODE=sourcing

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
    echo "INFO: Installing ZIM."
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
    echo "INFO: installing ZIM modules..."
    source "${ZIM_HOME}/zimfw.zsh" init -q
fi

# Initialize modules.
source "${ZIM_HOME}/init.zsh"

#################################################
# Powerlevel10k
#################################################

# To customize prompt, run `p10k configure` or edit ~/.config/zsh/.p10k.zsh.
# [[ ! -f "${ZDOTDIR:-${HOME}}/.p10k.zsh" ]] || source "${ZDOTDIR:-${HOME}}/.p10k.zsh"
