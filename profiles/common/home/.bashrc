# shellcheck shell=bash

# NOTE: interactive non-login shell 일때 읽힘.

__DOT_BASHRC_SOURCED=1

XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-${HOME}/.config}"

dot_bashenv="${HOME}/.bashenv"
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

set -o vi

__bash_module_root="${XDG_CONFIG_HOME}/bash/modules"
__bash_modules_file="${XDG_CONFIG_HOME}/bash/.bash_modules"

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
