if (( ! $+commands[fzf] )); then
  return
fi


export FZF_DEFAULT_OPTS="--color=16,border:8 --layout=reverse --height=22 --marker=░"

# configures in https://github.com/zimfw/fzf/blob/master/init.zsh
# if [[ $options[zle] = on ]]; then
#   eval "$(fzf --zsh)"
# fi

if (( $+commands[fd] )); then

  # export FZF_ALT_C_COMMAND="command fd -H --no-ignore-vcs -E .git -td"
  # export FZF_CTRL_T_COMMAND="command fd -H --no-ignore-vcs -E .git -td -tf"
#   export FZF_ALT_C_COMMAND="command fd -H -L --min-depth 1 --exclude \".cache\" --exclude \".direnv\" --exclude \".git\" --exclude \".github\" --exclude \".gitlab\" --exclude \".idea\" --exclude \".vscode\" --exclude \".vscode-server\" --exclude \".zed\" --exclude \"node_modules\" --exclude \".mypy_cache\" --exclude \".ruff_cache\" --exclude \".__pycache__\" --type d --one-file-system . 2>/dev/null"
# export FZF_CTRL_T_COMMAND="command fd -H -L --min-depth 1 --exclude \".cache\" --exclude \".direnv\" --exclude \".git\" --exclude \".github\" --exclude \".gitlab\" --exclude \".idea\" --exclude \".vscode\" --exclude \".vscode-server\" --exclude \".zed\" --exclude \"node_modules\" --exclude \".mypy_cache\" --exclude \".ruff_cache\" --exclude \".__pycache__\" --exclude \".DS_Store\" --exclude \"*.pyc\" --exclude \"*.swp\" --exclude \"*.thumbsnail\" --type f --type d --type l --one-file-system . 2>/dev/null"
# export _ZO_FZF_OPTS="--color=16,border:8 --layout=reverse --height=22 --marker=░ --scheme=path"
fi
