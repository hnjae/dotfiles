local pf # prefix

pf="zw"

alias $pf="zimfw"
alias ${pf}b="zimfw build"
alias ${pf}h="zimfw --help"
alias ${pf}c="zimfw clean && zimfw build && exec zsh"

# Handles none `my-` modules
alias ${pf}i="zimfw install -v && exec zsh"
alias ${pf}r="zimfw reinstall -v && exec zsh"
alias ${pf}u="zimfw update -v && exec zsh"

# alias ${pf}ug="zimfw upgrade && exec zsh"; zimfw 는 git-submodule 로 관리되는 중

unset pf
