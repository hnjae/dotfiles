if ((!$+commands[opencode])); then
    return
fi

local initfile="${0:A:h}/_opencode.zsh"

# Cache invalidation: opencode 는 pnpm global 로 설치되며, 업그레이드 시 shim 이
# 재작성되므로 `-ot` 비교로 충분하다. (Nix store 경로라면 mtime 이 epoch 로 고정되어
# modules/navi 식 path-signature 가 필요하지만, 여기서는 해당 없음)
#
# hyperfine, 2026-08-23: `opencode completion` 435.8 ms ± 4.2 ms (opencode 1.18.21)
# — 캐시 적중 시 이 프로세스 비용 전체를 회피.
if [[ ! -e "$initfile" || "$initfile" -ot "${commands[opencode]}" ]]; then
    $commands[opencode] completion >|"$initfile" || return 1
    zcompile -UR "$initfile"
fi

source "$initfile"

alias oc="systemd-inhibit --what=sleep --who=opencode --why='opencode session' opencode"
