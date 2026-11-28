---
name: nix-best-practices
description: "Conventions for writing and reviewing Nix code in any repository: list, attribute-set, and string composition; inline shell and other scripts built with `pkgs.writers`; and how data files reach a module. Use whenever you write, edit, refactor, or review a `.nix` file, a flake, a NixOS or home-manager module, or a derivation, even when the user does not mention style or conventions. A repository's own `AGENTS.md` overrides these rules where they conflict."
---

# Nix Best Practices

Apply these rules to every Nix expression you write or change. Follow them in new code; in existing code, change only what your task touches, and do not restyle adjacent code to match.

"Fits on one line" below means it fits within the line width of the repository's Nix formatter (such as `nixfmt`) after formatting.

## Lists

- Concatenate with `lib.flatten [ … ]` or `builtins.concatLists [ … ]` instead of `++` when the chain has three or more operands, or when it does not fit on one line. A conditionally empty term (`lib.lists.optional`, `lib.optionals`) then sits in the same list as the literals instead of becoming an operand of its own.
- Keep `++` for an append that fits on one line: `opts ++ [ "subvol=@nix" ]`.
- Use `builtins.concatLists` when the entries are lists that must stay nested; `lib.flatten` flattens all the way down.

<example>
Instead of `base ++ [ pkgs.git ] ++ lib.optional cfg.gui pkgs.firefox`, write:

```nix
lib.flatten [
  base
  pkgs.git
  (lib.optional cfg.gui pkgs.firefox)
]
```

</example>

## Attribute sets

- Merge with `lib.mergeAttrsList [ … ]` instead of `//` when the chain has three or more operands. A conditional operand (`lib.optionalAttrs`) then reads as an element of the same list instead of an operand of its own.
- Keep `//` for a two-operand merge, even when it spans several lines: the list form adds a bracket layer and an indent level without removing a chain.
- `lib.mergeAttrsList` merges the top level only, and a later element wins, so it produces the same result as `//`. `lib.recursiveUpdate` merges nested sets as well, so it changes the result wherever both sides set a set.

<example>
Instead of `defaults // { port = 8080; } // lib.optionalAttrs cfg.tls { cert = cfg.cert; }`, write:

```nix
lib.mergeAttrsList [
  defaults
  { port = 8080; }
  (lib.optionalAttrs cfg.tls { cert = cfg.cert; })
]
```

</example>

## Strings

- Write a string that spans more than one line as an indented string (`''…''`), never as a quoted string with `\n` joins: the indented form shows the text as it will be written and strips the common indentation.
- Tag a multi-line string that holds code with the language it is written in, in a comment on the line immediately before the opening `''`: `shellHook = # sh`. The reader then knows which language's rules apply to the body.
- A single-line string stays quoted, unless it carries many `"` or `\` characters: the indented form takes both literally, so `''…''` reads shorter and needs no escape.
- Concatenate with `lib.concatStrings [ … ]` instead of `+` when the chain has three or more operands. A conditional part (`lib.optionalString`) then sits in the same list as the literals.
- Keep `+` for a two-operand concatenation, even when an operand is a multi-line string.
- Keep `+` when the left operand is a path: `path + "/sub/file"` yields a path, while `lib.concatStrings` yields a string.

<example>
Instead of `"--port " + toString cfg.port + lib.optionalString cfg.verbose " -v"`, write:

```nix
lib.concatStrings [
  "--port "
  (toString cfg.port)
  (lib.optionalString cfg.verbose " -v")
]
```

</example>

## Executables

- Write inline shell with `pkgs.writers.writeDash`, and `pkgs.writers.writeDashBin` when the result is installed. The author prefers POSIX shell to bash. Keeping shell to POSIX plus a few dash extensions also keeps scripts small, because a job that outgrows them moves to a real language (see the order below) instead of growing into a bash program. dash enforces this: a bashism fails instead of silently working.
- `writers.*` check nothing on their own, so pass a `check` command that runs `shellharden --check`, then `shellcheck`, then `shfmt -d -ln posix -i <n>`, in that order, stopping at the first failure; any finding, a bashism included, fails the build. Set `<n>` to the indentation width the Nix file holding the script uses, so the embedded body steps like the code around it. Check a POSIX script with `shellcheck -s sh` and a dash-dialect script with `shellcheck -s dash`. Define the checker once per repository and reuse it; reuse the repository's existing checker when it has one.
- Pick the script's language in this order, moving down only when the current step falls short:
    1. POSIX `sh`.
    2. The dash dialect, when POSIX falls short or a dash extension such as `local` or `set -o pipefail` makes the script clearer or safer. `shellcheck -s sh` reports both as undefined, which is why a dash script is checked as `dash`. Name the extensions the script relies on in a comment beside the writer.
    3. Another language, when dash falls short (for example, the job needs real data structures, structured parsing, or a library). Use that language's writer — `writePython3`, `writePerl`, `writeLua`, `writeJS`, `writeRuby`, `writeRust`, `writeHaskell`, ...
- The check runs only when the derivation builds, so build it (for example with `nix build`) before reporting a script as done. If you cannot build it, say so.

## Data files

- Do not pass a path to a data file in the source tree directly to a module. Read the file and generate the output in Nix with `pkgs.writeText`; for structured data, use `pkgs.formats.json` (or the matching `pkgs.formats.*`). A flake path changes with the whole source tree, so an unrelated edit changes the generated unit.

## Reviewing

When asked to review Nix code, check it against every rule above and report each finding with its location (`file:line`), the rule it breaks (by section), and the concrete rewrite. Report only what a rule supports; leave untouched code that already complies.
