# Agent Guidelines

Scope: everything under this directory (`~/.config/zsh`, `$ZDOTDIR`). The root `AGENTS.md` still applies.

## Layout facts worth knowing

- `.zshenv` runs for every zsh process and is linked to both `~/.config/zsh/.zshenv` and `~/.zshenv`; keep its `__DOT_ZSHENV_SOURCED` guard so a double source is harmless. `.zimrc` is read by zimfw, not sourced at startup.
- Editing `.zimrc` makes the next `.zshrc` run `zimfw init -q` and rewrite `${ZIM_HOME}/init.zsh`.
- `NOSYSZSHRC` and `no_global_rcs` keep distro `/etc/zshrc` and `/etc/profile` from overriding `PATH`; `EXTENDED_GLOB` stays off so `#`, `~`, and `^` are literal in globs.
- This directory is a symlink into the dotfiles repo, so generated caches land in the repo working tree.
- `fzf`, `fzf-tab`, and `zsh-vi-mode` vendor upstream code (their `LICENSE` stays); upstream sources are submodules under `module/`.

## Adding a module

1. Create `modules/<tool>/init.zsh`. The directory name must not collide with a zimfw builtin module (see the note at the top of `.zimrc`).
2. Register it in `.zimrc` with `zmodule "$ZDOTDIR/modules/<tool>"`. Zimfw sources `init.zsh` unless `--source` names another entry file (upstream plugins only).
3. Place the line in the group that matches its dependencies:
   - plain env/alias modules first;
   - `modules/git` before `forgit`;
   - completion definitions before `compinit`;
   - anything calling `compdef` or reading `_comps` after `compinit` (`zoxide`, `worktrunk`, `fzf-tab`);
   - widget-wrapping plugins last (`zsh-syntax-highlighting`, `zsh-autosuggestions`).

Done when a fresh `zsh -i` defines what the module provides and `zsh -i -c 'exit'` returns 0; use the checks under [Verifying changes](#verifying-changes).

## Module contract

- A module is a no-op when its tool is absent, and exits 0:

  ```zsh
  if (( !$+commands[<tool>] )); then
      return
  fi
  ```

- Interactive-only code (`widgets`, `bindkey`, `compdef`) checks `[[ $TERM == dumb || $options[zle] != on ]]`; session-specific integration checks its session env (`TMUX`, `HERDR_ENV`, `HC_TERMINAL_ID`).
- The module's last command decides the shell's initial `$?`: end with an `if` block or `return 0`, so a failing test cannot make `ssh` or a fresh tmux pane report status 1.
- Top-level `local` is a normal parameter in zsh, not function-local. Use it for module-private values, `unset` it when a function defined in the module might read it, and use `typeset -g` when a later function must read it.
- Use `${0:A:h}` for the module directory (`:A` resolves the symlink into the repo), `${commands[<tool>]:A}` for a binary path, and `${XDG_*}` instead of hardcoded `$HOME` paths.
- Inside wrappers, prefix calls with `command` (bypass aliases and functions, e.g. zoxide's `cd`) or `builtin` (`builtin cd`). Wrap option-changing bodies in `emulate -L zsh` so options do not leak.

## Generated caches

A command whose `init`/`hook` output is evaluated at startup is generated once into a cache beside the module:

```zsh
local initfile="${0:A:h}/_<tool>.zsh"
local sigfile="${initfile}.sig"
local sig="${commands[<tool>]:A}"

# Cache invalidation policy:
# - `-ot` catches ordinary in-place binary updates.
# - `${commands[<tool>]:A}` catches Nix upgrades because the real store path changes.

if [[
    ! -s "$initfile" ||
    "$initfile" -ot "${commands[<tool>]}" ||
    ! -e "$sigfile" ||
    "$(<"$sigfile")" != "$sig" ]] \
    ; then
    "${commands[<tool>]}" <init command> >|"$initfile" || return 1
    print -r -- "$sig" >|"$sigfile"
    zcompile -UR "$initfile"
fi
source "$initfile"
```

- The signature file is what makes Nix upgrades visible: store mtimes are pinned, so an upgrade changes the store path without changing an mtime that `-ot` can compare. A binary rewritten in place (pnpm shim, `opencode`) needs the mtime check only.
- `! -s` rejects empty or truncated caches; `|| return 1` keeps a failed generation from writing a signature, so the next shell retries. `zcompile -UR` after every successful write; zsh prefers the newer `.zwc`.
- Add `_<tool>.zsh`, `_<tool>.zsh.sig`, and `_<tool>.zsh.zwc` to the module's `.gitignore`.
- Cache only output independent of per-shell state. `modules/nodejs` runs `fnm env` on every startup because `FNM_MULTISHELL_PATH` is per shell.
- Record the measurement that justified the cache in the module comment: `hyperfine` command, tool and zsh versions, and the date, in the existing `# hyperfine ..., <date>:` block. When the win is below measurement noise, say so (`modules/zoxide`).

Generated `_*.zsh` files are rebuilt from their binary; change `init.zsh` or the binary, then delete the cache to force regeneration.

## Comments

- Mark workarounds with `# NOTE:`, `# TODO:`, or `# HACK:` and end the line with `<YYYY-MM-DD>`; include the tool version when the behaviour is version-specific.
- Record numbers, not directions: "took 1.3 ms", "~65 ms per shell", "shfmt 3.13.1". The date lets a later reader re-check the premise and drop the workaround once it stops applying.

## Verifying changes

1. Source the module alone: `zsh -f -c 'source modules/<tool>/init.zsh; whence -w <fn>; <fn> --version'`
2. Source it twice and compare `stat -c '%Y %n' modules/<tool>/_*`: the second run must not rewrite. Then force each invalidation branch: touch or replace the binary, and write a wrong value into `_<tool>.zsh.sig`. A fake binary on a temporary `PATH` tests a store-path change cheaply.
3. Remove the tool from `PATH` and source the module again: exit 0, no files created.
4. Check the real startup: `zsh -i -c 'whence -w <fn>'` and `zsh -i -c 'exit'; echo $?`, then `time zsh -i -c exit` for startup cost.

After `.zimrc` changes, `zimfw install && exec zsh` (the next shell also auto-runs `zimfw init -q`). After an `init.zsh` edit, `exec zsh` is enough; `zimfw build` only refreshes compiled copies.
