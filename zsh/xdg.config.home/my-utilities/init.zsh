# cd to commonly used directories
alias sp="cd "$HOME/Projects""
alias sn="cd "$HOME/Projects/nix-config""
alias sv="cd "$HOME/Projects/dotfiles/nvim""
alias sz="cd "$HOME/Projects/dotfiles/zsh/xdg.config.home""

alias so="cd "${XDG_DOCUMENTS_DIR:-$HOME/Documents}/obsidian/home""
alias et="vi "${XDG_DOCUMENTS_DIR:-$HOME/Documents}/obsidian/home/dailies/$(date +"%Y-%m-%d").md""

# cd to XDG directories
alias sxc="cd "${XDG_CONFIG_HOME:-$HOME/.config}""
alias sxd="cd "${XDG_DATA_HOME:-$HOME/.local/share}""
alias sxs="cd "${XDG_STATE_HOME:-$HOME/.local/state}""

alias cp="cp -i --preserve=all --reflink=auto"
alias mv="mv -i"
alias j="just"
alias je="just --edit"

alias fmime= "file --mime-type --brief --"
alias xmime="xdg-mime query filetype"
alias nfd2nfc-dryrun="convmv -r -f utf8 -t utf8 --nfc ."
alias nfd2nfc-run="convmv -r -f utf8 -t utf8 --nfc --notest ."
alias colorpattern="curl -s https://gist.githubusercontent.com/HaleTom/89ffe32783f89f403bba96bd7bcd1263/raw/e50a28ec54188d2413518788de6c6367ffcea4f7/print256colours.sh | bash"
