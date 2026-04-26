local pf # prefix

pf="zm"

alias $pf="zimfw"
alias ${pf}b="zimfw build && exec zsh" # apply changes
alias ${pf}h="zimfw --help"
alias ${pf}C="zimfw clean && zimfw build && exec zsh"

# Handles none `my-` modules
alias ${pf}i="zimfw install -v && exec zsh"
alias ${pf}r="zimfw reinstall -v && exec zsh"
alias ${pf}u="zimfw update -v && exec zsh"

# alias ${pf}ug="zimfw upgrade && exec zsh"; zimfw 는 git-submodule 로 관리되는 중

unset pf
