if (( ! $+commands[oh-my-posh] )); then
    return
fi

# NOTE: example of oh-my-posh result: `export POSH_SESSION_ID="f0f2ffb7-f1f2-423b-a4df-bd39162caf67";source $'/home/hnjae/.cache/oh-my-posh/init.14695981039346656037.zsh'`

eval "$($commands[oh-my-posh] --config "${0:A:h}/config.json" init zsh)"

# from https://github.com/JanDeDobbeleer/oh-my-posh/issues/5438
_omp_redraw-prompt() {
    local precmd
    for precmd in "${precmd_functions[@]}"; do
        "$precmd"
    done

    zle .reset-prompt
}

function zvm_after_select_vi_mode() {
    _omp_redraw-prompt
}
