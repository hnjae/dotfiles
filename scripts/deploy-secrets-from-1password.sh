#!/bin/sh

set -eu

XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-${HOME}/.config}"

deploy_ssh_key() {
    # --- SSH keys ---
    install -d -m 700 ~/.ssh

    op read "op://Personal/ssh-home/private key" >~/.ssh/id_ed25519
    chmod 600 ~/.ssh/id_ed25519

    ssh-keygen -y -f ~/.ssh/id_ed25519 >~/.ssh/id_ed25519.pub
    chmod 644 ~/.ssh/id_ed25519.pub

    echo "INFO: SSH key deployed" >&2
}

deploy_age_key() {
    install -d -m 700 "${XDG_CONFIG_HOME}/sops/age"

    op read "op://Personal/ssh-home/age/private-key" >"${XDG_CONFIG_HOME}/sops/age/keys.txt"
    chmod 600 "${XDG_CONFIG_HOME}/sops/age/keys.txt"

    echo "INFO: age key deployed" >&2
}

deploy_api_keys() {
    # --- OpenRouter API key → secret-tool (libsecret) ---
    _openrouter_key="$(op read "op://Personal/openrouter-local/credential")"
    printf '%s' "$_openrouter_key" | secret-tool store --label="openrouter-local" api openrouter
    unset _openrouter_key

    echo "INFO: OpenRouter API key stored in libsecret" >&2
}

main() {
    if command -v op >/dev/null 2>&1; then
        echo "ERR: op 가 설치되어 있지 않습니다." >&2
        exit 1
    fi

    # 1Password 로그인 확인
    if ! op account get >/dev/null 2>&1; then
        echo "ERR: 1Password CLI 로그인이 필요합니다. 'eval \$(op signin)' 을 실행하세요." >&2
        exit 1
    fi

    deploy_ssh_key
    deploy_age_key
    deploy_api_keys
}
