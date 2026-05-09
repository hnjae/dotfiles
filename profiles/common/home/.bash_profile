# shellcheck shell=bash

# NOTE: login shell 일때 읽힘. (interactive 여부와 상관 없이.)

if [[ -r "${HOME}/.bashenv" ]]; then
    # shellcheck source=/dev/null
    . "${HOME}/.bashenv"
fi

for user_profile_file in "${XDG_CONFIG_HOME:-${HOME}/.config}/profile.d"/*.sh; do
    [[ -r "$user_profile_file" ]] || continue
    # shellcheck source=/dev/null
    . "$user_profile_file"
done

if [[ $- == *i* && -s "${HOME}/.bashrc" ]]; then
    # shellcheck source=/dev/null
    . "${HOME}/.bashrc"
fi
