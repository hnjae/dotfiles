# NOTE:
# Executes commands at logout.
# read at logout, within login shell
# Here, you can clear your terminal or any other resource which was setup at login.
#
# Sourced only when using tty or tmux

################################################################################
# Authors: Sorin Ionescu <sorin.ionescu@gmail.com> from zprezto

# Execute code only if STDERR is bound to a TTY.
[[ -o INTERACTIVE && -t 2 ]] && {

SAYINGS=(
    "So long and thanks for all the fish.\n  -- Douglas Adams"
    "Good morning! And in case I don't see ya, good afternoon, good evening and goodnight.\n  --Truman Burbank"
)

# Print a randomly-chosen message:
echo $SAYINGS[$(($RANDOM % ${#SAYINGS} + 1))]

} >&2
