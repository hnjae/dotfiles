if ((!$+commands[fnm])); then
    return 0
fi

# fnm env는 셸마다 고유한 FNM_MULTISHELL_PATH를 생성한다.
# 출력을 캐시하면 셸들이 같은 경로를 공유해 Node 버전 변경이 서로 영향을 주므로 매번 실행한다.
local fnm_env
fnm_env="$("${commands[fnm]}" env --shell zsh)" || return 1
eval "$fnm_env"
