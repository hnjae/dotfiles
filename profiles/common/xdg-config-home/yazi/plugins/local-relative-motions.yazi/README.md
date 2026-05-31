# local-relative-motions.yazi

Local relative motions for Yazi.

- Numeric prefixes `1` through `9` are bound in `keymap.toml`; extra digits may follow, so `10gg` jumps to line 10.
- Supported motions are `j`/`<Down>`, `k`/`<Up>`, `h`/`<Left>`, `l`/`<Right>`, `gg`, `gj`, `gk`, and `gt`.
- Supported operations are `v`, `y`, `x`, and `d` followed by `j`/`<Down>`, `k`/`<Up>`, or the same key again, such as `2yy` or `3dj`.
- Supported tab operations are `t`, `H`, `L`, `w`, `W`, `<`, `>`, and `~`.
- Relative number display is intentionally excluded; use Yazi custom linemode if that is needed later.
- `d`, `x`, `w`, and `W` can remove files or close tabs, so test new sequences in a fixture directory first.
