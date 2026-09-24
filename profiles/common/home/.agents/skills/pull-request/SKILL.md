---
name: pull-request
description: "Write, draft, or publish a pull request or merge request from committed changes. Use this skill whenever a user asks to draft, write, describe, open, create, or publish a GitHub pull request, GitLab merge request, or Gitea/Forgejo pull request, even if they use another platform's terminology."
---

# Pull Request and Merge Request Workflow

Prepare a grounded review request from committed changes. A draft is text only; publication changes remote state and requires explicit user intent.

## Scope and authorization

- “Write”, “draft”, or “describe” means return a title and body draft only. Do not push, create a remote item, or mutate Git state.
- “Create”, “open”, or “publish” explicitly authorizes creating the remote PR/MR. It does not authorize commits, amend/rebase, branch creation, force-push, merge, or unrelated file changes.
- Never stage or commit automatically. If the user wants uncommitted work included, explain that it must first be committed; use the `git-commit` skill only if they explicitly request a commit.
- Use already-committed changes. A normal push of the current branch is allowed only when publication requires it and the destination is unambiguous and non-force push is safe. Respect an explicit no-push instruction.

## Establish the comparison

Before writing anything, inspect repository status, current branch and upstream, remotes, hosting origin, contribution instructions, and applicable PR/MR template. Identify the source branch and target base; use a user-specified base first, otherwise the hosting platform's configured default. If host, source, or base cannot be determined unambiguously, ask one focused question rather than guessing.

Compare committed work against the base using the merge base. Inspect both the commit list and complete diff. Keep uncommitted and staged changes separate from this comparison; never describe them as included. If the committed comparison is empty, do not fabricate a review request.

Read repository contribution guidance and templates before composing. Follow template headings and documented title conventions. Otherwise use a concise title and `Summary` and `Testing` sections. Describe only observed changes. List checks as passed only when their output was observed; otherwise mark them not run or not verified. Do not add issue-closing references unless the user or repository guidance provides the intended reference. Match the user's language unless repository guidance specifies otherwise.

## Draft only

Return a proposed title and body; do not alter local or remote state. For a substantive authored PR/MR body, append the repository-required attribution as its final line, using the executing harness and model in plain tokens:

`Assisted-by: LLM <harness> <model>`

Do not put explanatory text after the trailer. A mechanical one-line description is exempt.

## Publish

Before creating a remote item:

1. Confirm the target repository, base branch, and head branch.
2. Check for an existing open PR/MR with the same head and base. If found, return its URL and ask whether to update it; do not silently create a duplicate or edit it.
3. Use an authenticated host CLI when available: `gh` for GitHub, `glab` for GitLab, or `tea` only after confirming it supports the configured Gitea/Forgejo host. Otherwise use an authenticated browser UI. Never install a client or request, paste, or expose access tokens.
4. If the committed head is not available remotely, push the current branch to its intended remote only if the destination is clear and an ordinary non-force push is safe. Never rewrite history. If authentication, host access, or safe push is unavailable, stop and report the exact blocker with the grounded title/body draft; do not claim publication.
5. Create a draft PR/MR only when the user requests draft status or says the work is not ready; otherwise create a regular review request.
6. After creation, verify the returned URL and inspect the created item to confirm title, base, head, body, and draft status. Report the URL and checks that were not run.

A successful command alone is not proof that the created item has the intended content. Never invent a URL, remote state, or test result.
