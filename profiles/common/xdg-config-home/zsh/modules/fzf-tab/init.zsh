# fzf-tab needs to be loaded after compinit, but before plugins which will wrap widgets, such as zsh-autosuggestions or fast-syntax-highlighting
#
# Completions should be configured before compinit, as stated in the zsh-completions manual installation guide.

zstyle ':fzf-tab:*' use-fzf-default-opts no

# force zsh not to show completion menu, which allows fzf-tab to capture the unambiguous prefix
zstyle ':completion:*' menu no

source "${0:A:h}/module/fzf-tab.plugin.zsh"

