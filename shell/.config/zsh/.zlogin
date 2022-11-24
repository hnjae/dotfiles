# NOTE:
# Executes commands at login post-zshrc. (after sourcing zshrc)
# Execute code that does not affect the current session in the background.

# This file is sourced after .zshenv, .zprofile, .zshrc
# This file is only sourced when initial login (only tmux or tty (FIND WHY))
# This file is used to launch external commands which do not modify shell behaviors (e.g. a login manager).

################################################################################
# Authors: Sorin Ionescu <sorin.ionescu@gmail.com> from zprezto
{
  # Compile the completion dump to increase startup speed.
  zcompdump="${XDG_CACHE_HOME:-$HOME/.cache}/prezto/zcompdump"
  if [[ -s "$zcompdump" && (! -s "${zcompdump}.zwc" || "$zcompdump" -nt "${zcompdump}.zwc") ]]; then
    zcompile "$zcompdump"
  fi
} &!

# Execute code only if STDERR is bound to a TTY.
if [[ -o INTERACTIVE && -t 2 ]]; then

  # Print a random, hopefully interesting, adage.
  if (( $+commands[fortune] )); then
    fortune -s
    print
  fi

fi >&2

################################################################################

# Colorscheme for console
[ "$TERM" = "linux" -a -f "$ZDOTDIR/colorscheme.sh" ] \
    && . "$ZDOTDIR/colorscheme.sh"
