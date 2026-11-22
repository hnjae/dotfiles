---
name: git-commit
description: "Create a Conventional Commit from repository changes. Use whenever the user asks to commit changes, make or create a commit, save work in Git as a commit, or invokes /commit."
---

# Git Commit with Conventional Commits

## Overview

Create standardized, semantic git commits using the Conventional Commits specification. Analyze the actual diff to determine appropriate type, scope, and message.

## Conventional Commit Format

```text
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

## Commit Types

| Type | Purpose |
| ---------- | ------------------------------ |
| `feat` | New feature |
| `fix` | Bug fix |
| `docs` | Documentation only |
| `style` | Formatting/style (no logic) |
| `refactor` | Code refactor (no feature/fix) |
| `perf` | Performance improvement |
| `test` | Add/update tests |
| `build` | Build system/dependencies |
| `ci` | CI/config changes |
| `chore` | Maintenance/misc |
| `revert` | Revert commit |

## Breaking Changes

```text
# Exclamation mark after type/scope
feat!: remove deprecated endpoint

# BREAKING CHANGE footer
feat: allow config to extend other configs

BREAKING CHANGE: `extends` key behavior changed
```

## Workflow

### 1. Analyze Diff

```bash
# If files are staged, use staged diff
git diff --staged

# If nothing staged, use working tree diff
git diff

# Lists untracked files too, which `git diff` never shows
git status --porcelain
```

### 2. Stage Files (if needed)

If nothing is staged or you want to group changes differently, stage explicit paths that belong to this commit. Do not use globs or `git add -A`; they sweep in unrelated changes.

```bash
git add path/to/file1 path/to/file2
```

**Never commit secrets** (.env, credentials.json, private keys).

### 3. Generate Commit Message

Analyze the diff to determine:

- **Type**: What kind of change is this?
- **Scope**: What area/module is affected?
- **Description**: One-line summary of what changed (imperative, present tense, at most 72 chars)
- **Body**: Add one when the reason for the change is not obvious from the description.

### 4. Execute Commit

Every git command runs non-interactively: pass `-m` or `--no-edit`. A command that opens an editor (`commit` without `-m`, `rebase -i`) hangs until cancelled.

Pass each paragraph as its own `-m`. Add the attribution trailer with `--trailer` (see AI Assistance Attribution) instead of writing it into the message text.

```bash
# No attribution needed
git commit -m "<type>[scope]: <description>" -m "<optional body>"

# Attribution needed (Codex example; use the form for your harness)
git commit -m "<type>[scope]: <description>" -m "<optional body>" \
  --trailer "Co-authored-by: GPT-6.2 Astra <noreply@openai.com>"
```

### 5. Rewrite the Last Local Commit (only when the user asks)

```sh
# Keep the message, add the trailer
git commit --amend --no-edit --trailer "Co-authored-by: GPT-6.2 Astra <noreply@openai.com>"

# Change the body or an existing trailer
git commit --amend -m "<subject>" -m "<body>" -m "Co-authored-by: GPT-6.2 Astra <noreply@openai.com>"
```

`--trailer` appends: amending a commit that already carries the trailer with a different value leaves both lines. To change a trailer, rewrite the message with `-m`. Amend only a commit that is not pushed.

## Best Practices

- One logical change per commit
- Imperative present tense: "add" not "added", "fix bug" not "fixes bug"
- Reference issues: `Closes #123`, `Refs #456`

## AI Assistance Attribution

Disclose LLM assistance with a `Co-authored-by:` trailer.

When to add it:

- Add it when the agent edited files that are part of this commit during the current session (code, docs, config). A commit that mixes agent and human edits counts.
- Omit it when the agent did not write any of the committed changes, e.g. the user made them by hand and the agent only stages, writes the message, and commits.

Format, by harness:

| Harness | Trailer |
| ------- | ------- |
| Claude | `Co-authored-by: <Model display name> <noreply@anthropic.com>` |
| Codex | `Co-authored-by: <Model display name> <noreply@openai.com>` |
| Maki | `Co-authored-by: <Model display name> <noreply@maki.sh>` |
| OpenCode | `Co-authored-by: <Model display name> <noreply@opencode.ai>` |
| Pi | `Co-authored-by: <Model display name> <noreply@pi.dev>` |
| Vibe | `Co-authored-by: <Model display name> <vibe@mistral.ai>` |

- Each address identifies the tooling, not the model's vendor; never change it per model. For any other harness, use the attribution line its own instructions specify; never invent an address.
- Write the display name bare: only the email is wrapped in `<>`.
- `<Model display name>` is the model display name for the exact revision running this session, written as its vendor brands it: `Kimi K3.1 Pro`, `Gemini 4 Hydrogen`, `Claude Sonnet 5.5`, `GPT-6.2 Astra`. It is not a provider-prefixed slug (`zai-coding-plan/glm-5.3-flash`) or a raw catalog slug (`zai-glm-5-3-flash`). Preserve every revision suffix verbatim, since suffixes can identify distinct deployments and benchmarks: the slug `deepseek-v4-1-flash-1017` becomes `DeepSeek V4.1 Flash 1017`, not `DeepSeek V4.1 Flash`. If the runtime reports a shorter display name than the slug, append the missing revision suffix instead of trusting the shorter name. Drop only provider namespaces and slug punctuation, never a version or revision component. If you cannot map the slug to a display name without losing revision information, ask the user instead of guessing.
- Place it in the footer (the last paragraph) of the commit message. `--trailer` does this.
- Never add `Signed-off-by` on behalf of the AI; DCO certification is human-only (the Linux kernel's AI coding assistant guidance says the same).

## Git Safety Protocol

- NEVER update git config
- NEVER run destructive commands (--force, hard reset) without explicit request
- NEVER skip hooks (--no-verify) unless user asks
- NEVER force push to main/master
- If a hook rejects the commit, no commit was created: fix the problem, re-stage, and run `git commit` again. Do not `--amend`; that would rewrite the previous commit.
