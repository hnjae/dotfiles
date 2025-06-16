if (( ! $+commands[oh-my-posh] )); then
  return
fi

# $commands[oh-my-posh] init zsh >| ${0:A:h}/oh-my-posh.zsh
$commands[oh-my-posh] --config ${0:A:h}/config.toml init zsh >| ${0:A:h}/oh-my-posh.zsh

source ${0:A:h}/oh-my-posh.zsh

# from https://github.com/JanDeDobbeleer/oh-my-posh/issues/5438
_omp_redraw-prompt() {
  local precmd
  for precmd in "${precmd_functions[@]}"; do
    "$precmd"
  done

  zle .reset-prompt
}

export _POSH_VI_MODE="?" # this should not displayed in the prompt
function _set_posh_vi_mode() {
  case $ZVM_MODE in
  $ZVM_MODE_NORMAL)
    _POSH_VI_MODE="❮"
    ;;
  $ZVM_MODE_INSERT)
    _POSH_VI_MODE="❯"
    ;;
  $ZVM_MODE_VISUAL)
    _POSH_VI_MODE="V"
    ;;
  $ZVM_MODE_VISUAL_LINE)
    _POSH_VI_MODE="VL"
    ;;
  $ZVM_MODE_REPLACE)
    _POSH_VI_MODE="▶"
    ;;
  esac
}
_set_posh_vi_mode

function zvm_after_select_vi_mode() {
  _set_posh_vi_mode
  _omp_redraw-prompt
}
