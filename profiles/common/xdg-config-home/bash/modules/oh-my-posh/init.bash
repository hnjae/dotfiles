# shellcheck shell=bash

if command -v oh-my-posh >/dev/null 2>&1; then
    # NOTE: `--strict` 없이는 생성 스크립트 캐시에 oh-my-posh 의 절대 store path 가 박히고,
    # 캐시 키가 버전 문자열뿐이라 `nix profile upgrade` 후에도 갱신되지 않아 GC 된 path 를 실행한다.
    eval "$(command oh-my-posh init bash --config "${XDG_CONFIG_HOME:-${HOME}/.config}/oh-my-posh.json" --strict)"
fi
