alias g='git'

typeset -g _lformat='%C(auto)%h␟%s␟%C(blue)%aI␟%C(green)%an␟%C(auto)%d␟'
typeset -g _gformat='%C(auto)%h%C(auto)%d%s%C(blue)%aI%C(green)<%an>'

export FORGIT_PAGER="cat" # delta 는 forgit 에서 사용하면 번잡스럽다.
alias lg="lazygit"

######################################################
# git-log
######################################################
alias gl="git log --oneline --decorate -19"
alias gll="git log --oneline --decorate"
typeset -g forgit_log="glz" # default: glo

alias gld="git log --color=always --pretty='${lFormat}' -19 | column --table --separator '␟'"
alias gldd="git log --color=always --pretty='${lFormat}' | column --table --separator '␟'"

# git-log with graph
alias glg="git log --oneline --decorate --graph -19"
alias glgg="git log --oneline --decorate --graph"
alias glgf="git log --graph --decorate"
alias glgp="git log --graph --decorate --oneline --show-pulls --"
alias glgd="git log --graph --pretty='${gFormat}' -19"
alias glgdd="git log --graph --pretty='${gFormat}'"
alias glgds="git log --graph --pretty='${gFormat}' --stat"

# git-log misc
alias gls="git log --stat | bat --style=plain"
alias glsp="git log --stat -p"
alias glcount="git shortlog -sn"

######################################################
# git-diff
######################################################
alias gd="git diff"
typeset -g forgit_diff="gdz" # defaults: `gd`
alias gdw="git diff --word-diff"
alias gds="git diff --staged"
alias gdst="git diff --stat"
alias gdsw="git diff --staged --word-diff"
alias gdl="git difftool"
alias gdt="git diff-tree --no-commit-id --name-only -r"

######################################################
# git-blame
######################################################
# git-blame
# gbl                  git blame -b -w
# gbl (forgit)
typeset -g forgit_blame="gbl" # defaults

######################################################
# git-status
######################################################
alias gs="git status --short --branch --untracked-files=all"
alias gst="git status --short --branch --untracked-files=all"

######################################################
# git-show
######################################################
alias gshw="git show --no-abbrev-commit"
alias gshw="git show --no-abbrev-commit --pretty=short --show-signature"

######################################################
# git-bisect
######################################################
alias gbs="git bisect"
alias gbsb="git bisect bad"
alias gbsg="git bisect good"
alias gbsr="git bisect reset"
alias gbss="git bisect start"

######################################################
# ga: git-add
######################################################
alias ga="git add -v"
typeset -g forgit_add="gaz" # defaults: `ga`
alias gaa="git add --all"
alias gapa="git add --patch"
alias gau="git add --update"
# alias gav="git add --verbose"

######################################################
# grm: git-rm
######################################################
alias grm="git rm"
alias grmc="git rm --cached" # cached: staged

######################################################
# git-restore
######################################################
typeset -g forgit_checkout_file="grst" # git-restore (default: `gcf`)
alias grsts="git restore --source"
alias grstt="git restore --staged"

######################################################
# git-commit
######################################################
# note: `-v`: diff 를 gitcommit 에 comment 로 포함시킴.
alias gc="git commit -v"
alias gca="git commit -v --amend"
alias gcaN="git commit -v --amend --no-edit"
alias gcm="git commit -v -m"

######################################################
# git-cherry-pick
######################################################
typeset -g forgit_cherry_pick="gcp" # defaults
alias gcpA="git cherry-pick --abort"
alias gcpc="git cherry-pick --continue"

######################################################
# git-merge
######################################################
alias gm="git merge"
alias gmA="git merge --abort"
alias gmt="git mergetool --no-prompt"
alias gmtvim="git mergetool --no-prompt --tool=vimdiff"
alias gmom="git merge origin/main"
alias gmum="git merge upstream/main"

######################################################
# git-rebase
######################################################
typeset -g forgit_rebase="grb" # defaults / interactive `git rebase -i` selector (forgit)
alias grbA="git rebase --abort"
alias grbc="git rebase --continue"
alias grbi="git rebase -i"
alias grbm="git rebase main"
alias grbs="git rebase --skip"

######################################################
# git-revert
######################################################
typeset -g forgit_revert_commit="grv" # default: `grc`

######################################################
# git-branch
######################################################
alias gb="git branch"
alias gbm="git branch --move"
alias gba="git branch --all"
alias gbnm="git branch --no-merged"
alias gbr="git branch --remote"

typeset -g forgit_branch_delete="gbd" # defaults
alias gbd!="git branch --delete --force"
# "gbdm" = "git-branch-delete-merged";

######################################################
# git-tag
######################################################
alias gts="git tag -s"
alias gtv="git tag | sort -V"

######################################################
# git-switch (HEAD 조작)
######################################################
typeset -g forgit_checkout_branch="gsw" # git-switch (default: `gcb`)
# gsw                  git branch | sed 's/^[[:space:]*]*//' | fzf --header="current: $(git branch --show-current)" --preview='git log --oneline --color=always {}' | xargs git switch
alias gswc="git switch -c"

######################################################
# git-reset (HEAD/working directory 조작)
######################################################
typeset -g forgit_reset_head="grz" # default: `grh`
alias gr="git reset"
alias grhd="git reset HEAD"
alias grH="git reset --hard"
# forgit_checkout_tag = "grst"
# forgit_checkout_commit = "grsco"
# groh                 git reset origin/$(git_current_branch) --hard
alias grHhd="git reset --hard HEAD"
alias grHhd1="git reset --hard HEAD~1"

############################################################################
# git-stash
############################################################################
typeset -g forgit_stash_show="gss" # default: `gss`
typeset -g forgit_stash_push="gsp" # default: `gsp`
alias gsu="git stash --include-untracked" # -u: --include-untracked
alias gsl="git stash list"
alias gso="git stash pop"

# gsta                 git stash save
# gstaa                git stash apply
# gstc                 git stash clear
# gstd                 git stash drop
# gsts                 git stash show --text
# gstall               git stash --all

############################################################################
# git-remote
############################################################################
alias gre="git remote -v"
alias grea="git remote add"
alias grern="git remote rename"
alias grerm="git remote remove"
alias greset="git remote set-url"
alias greup="git remote update"

############################################################################
# git-push
############################################################################
alias gP="git push"
alias gPu="git push upstream"
alias gPv="git push -v"
alias gP!="git push --force-with-lease"
alias gPd="git push --dry-run"
alias gPoat="git push origin --all && git push origin --tags"
# gpsup                git push --set-upstream origin $(git_current_branch)
# ggpush               git push --set-upstream origin HEAD

############################################################################
# git-fetch
############################################################################
alias gf="git fetch"
alias gfa="git fetch --all --prune"
alias gfo="git fetch origin"

############################################################################
# git-pull
############################################################################
alias gplf="git pull --ff-only"
alias gplr="git pull --rebase -v"
alias gplra="git pull --rebase --autostash -v"
# glum                 git pull upstream master
# ggpull               git pull origin "$(git_current_branch)"
# ggpush               git push origin "$(git_current_branch)"

############################################################################
# git-clone
############################################################################
alias gcl="git clone --recurse-submodules"
alias gclm="git clone --depth 1 --recurse-submodules --shallow-submodules"

############################################################################
# git-submodule
############################################################################
alias gsui="git submodule init"
alias gsur="git submodule update --recursive"
alias gsuu="git submodule update"

############################################################################
# git-misc
############################################################################
alias gcf="git config --list"
alias gfg="git ls-files | grep"
alias gg="git gui citool"
alias ggA="git gui citool --amend"
alias ghp="git help"
alias gop="git open"

alias gwch="git whatchanged -p --abbrev-commit --pretty=medium"
alias gignore="git update-index --assume-unchanged"
alias gunignore="git update-index --no-assume-unchanged"
# alias gignored="git ls-files -v | grep "^[[:lower:]]""
alias gpristine!="git reset --hard && git clean -dfx"
# alias gdct="git describe --tags \$(git rev-list --tags --max-count=1)"
# gap                  git apply
# ggsup                git branch --set-upstream-to=origin/$(git_current_branch)
# "gke" = "\gitk --all \$(git log -g --pretty=%h)";
# misc using forgit
# gclean               git clean -id
# grl                  git reflog
# gclean (forgit)
# greflog (forgit) `git reflog`
# gignoredgenerate (forgit)
# gfixup (forgit)

alias gtl="git-tag-list"
alias gcr="git-cd-root"

alias gwip="git-wip"
alias gunwip="git-unwip"
alias gtodo="git-todo"
# "ge" = ''vi $(git_status_select)''; # WIP: not working

typeset -g forgit_reflog="greflog"
typeset -g forgit_clean="gclean"
typeset -g forgit_ignore="gignoredgenerate"
typeset -g forgit_fixup="gfixup"
