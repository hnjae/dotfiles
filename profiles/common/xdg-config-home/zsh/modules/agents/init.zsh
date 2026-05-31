if (($+commands[codex])); then
    alias codexmini="codex --sandbox danger-full-access --model gpt-5.4-mini"
    alias codexro="codex --sandbox read-only"
    alias "codex!"="codex --dangerously-bypass-approvals-and-sandbox"
fi
