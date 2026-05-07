# shellcheck shell=bash

dot_bashenv="${XDG_CONFIG_HOME:-${HOME}/.config}/bash/.bashenv"
if [[ -r "$dot_bashenv" ]]; then
    # shellcheck source=/dev/null
    . "$dot_bashenv"
fi
unset dot_bashenv

# If not running interactively, don't do anything
case $- in
*i*) ;;
*) return ;;
esac

# Don't check mail when opening terminal.
unset MAILCHECK

# Change this to your console based IRC client of choice.
export IRC_CLIENT='irssi'

set -o vi

__bash_module_root="${XDG_CONFIG_HOME:-${HOME}/.config}/bash/modules"
__bash_modules_file="${XDG_CONFIG_HOME:-${HOME}/.config}/bash/.bash_modules"

# shellcheck disable=SC2329
bmodule() {
    local module_name module_file

    if [[ $# -ne 1 ]]; then
        printf 'bmodule: expected one module name\n' >&2
        return 1
    fi

    module_name=$1
    module_file="${__bash_module_root}/${module_name}/init.bash"
    if [[ ! -r "$module_file" ]]; then
        printf 'bmodule: %s: module not found\n' "$module_name" >&2
        return 1
    fi

    # shellcheck source=/dev/null
    . "$module_file"
}

if [[ -r "$__bash_modules_file" ]]; then
    # shellcheck source=/dev/null
    . "$__bash_modules_file"
fi

unset -f bmodule
unset __bash_module_root __bash_modules_file
