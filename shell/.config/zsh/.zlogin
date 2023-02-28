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

type neofetch > /dev/null 2>&1 \
    && neofetch \
        --gtk_shorthand off \
        --de_version off \
        --gtk2 off \
        --gtk3 off \
        --disable resolution \
        --disable de \
        --disable wm \
        --uptime_shorthand tiny \
        --speed_shorthand on \
        --kernel_shorthand on \
        --distro_shorthand off \
        --color_blocks off \
        --gpu_brand on \
        --cpu_brand on \
        --memory_percent on \
        --disk_show '/' \
        --disk_display 'infobar' \
        --disk_percent on \
        --disk_subtitle 'dir'

if [ "$TERM" = linux -a -z "$DISPLAY" -a "$(tty)" = "/dev/tty1" ]; then
    "$HOME/.local/bin/run-de" sway
fi
