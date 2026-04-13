---
name: commit
description: Standardize Git commits using Conventional Commits specification.
---

# Conventional Commits for Git

Create standardized git commits using the Conventional Commits specification.

## Command Input

When the user invokes `/commit [scope]`, treat the optional `scope` argument as
the logical area for the change (e.g., `auth`, `api`, `ui`) and apply it to the
commit message if it is appropriate for the staged changes.

## Commit Format

```
<type>[optional scope]: <subject>

[optional body]

[optional footer(s)]

🤖 Generated with [OpenCode](https://opencode.ai/)
```

**Subject guidelines:**

- Imperative present tense ("add" not "added")
- Lowercase (except proper nouns)
- 50 characters or fewer
- No period at the end
- Focus on what changed and why

**Body guidelines (when needed):**

- Explain rationale, impact, and any side effects
- Keep lines readable (around 72 characters is typical)

**Examples:**

- `feat(auth): add OAuth2 login`
- `fix(api): handle empty user response`
- `docs(readme): clarify install steps`
- `refactor(parser): simplify token checks`

## Conventional Types

- **feat**: New feature or functionality
- **fix**: Bug fix
- **docs**: Documentation only
- **refactor**: Code change without behavior change
- **perf**: Performance improvement
- **test**: Adding or modifying tests
- **chore**: Build tools, dependencies, or housekeeping
- **ci**: CI/CD configuration

## Workflow

1. Check conversation context for recent `git status` or `git diff` output.
2. If needed, run `git status` and `git diff --cached` in parallel.
3. If nothing is staged, ask the user to stage files or confirm what to include.
4. If the user wants additional files included, stage them before drafting.
5. Determine type and scope (use provided scope; otherwise infer or omit).
6. Draft the message from staged changes only.
7. Create the commit and verify with `git status`.

## Breaking Changes

- Add `!` after the type or scope: `feat(api)!: change response format`
- Add a `BREAKING CHANGE:` footer with migration details

## Operational Guidelines and Safety

- Avoid describing unstaged work.
- One commit should represent one logical change.
- If a pre-commit hook fails, fix the issue, stage the fixes, and re-run the commit.
- Do not use `--amend` unless the user explicitly asks.
- NEVER update git config.
- NEVER run destructive commands (--force, hard reset) without explicit request.
- NEVER skip hooks (--no-verify) unless the user asks.
- NEVER force push to main/master.
