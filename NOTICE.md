# Third-party notices

This repository is distributed under AGPL-3.0-or-later (see `LICENSE`). This file is an index of the material taken from other projects. The notices that the upstream licenses require sit next to the material, so they travel when a single directory is copied. A directory taken wholesale from one upstream keeps that upstream's `LICENSE`; a directory with modifications or several sources has a `NOTICE.md`; a single file keeps its notice in its header or in a comment.

MIT and Apache-2.0 material is included under AGPL-3.0-or-later, which those licenses permit. The rows marked "kept" are not under AGPL-3.0-or-later, because the upstream license does not allow it; their texts are in `LICENSES/`.

| Material | Upstream | License | Notice |
| ------------------------------------------------------------------------------------- | -------------------------------------------- | ------------------- | --------------------------------------------------------- |
| `profiles/common/home+.codex/BASE_INSTRUCTIONS.md` | OpenAI Codex | Apache-2.0 | `profiles/common/home+.codex/NOTICE.md` |
| LazyVim excerpts in `profiles/common/xdg-config-home/nvim/` | LazyVim | Apache-2.0 | `profiles/common/xdg-config-home/nvim/NOTICE.md` |
| `profiles/common/xdg-config-home/nvim/lua/plugins/lang/_.overseer.lua` | overseer.nvim | MIT | `profiles/common/xdg-config-home/nvim/NOTICE.md` |
| `profiles/common/xdg-config-home/nvim/snippets/` | friendly-snippets | MIT | `profiles/common/xdg-config-home/nvim/snippets/NOTICE.md` |
| `profiles/common/home+.codex/skills/git-commit/` | github/awesome-copilot | MIT | `profiles/common/home+.codex/skills/git-commit/NOTICE.md` |
| `profiles/common/xdg-config-home/zsh/modules/{compinit,direnv,fzf,utilities,zoxide}/` | Zim modules, zim-zoxide | MIT | `NOTICE.md` in each directory |
| `profiles/common/xdg-config-home/nvim/syntax/asciidoctor.vim` | vim-asciidoctor | MIT | file header |
| `all` alias in `profiles/desktop/xdg-config-home/git/config` | simnalamburt/.dotfiles | MIT | comment in the file |
| `profiles/common/xdg-config-home/nvim/syntax/navi.vim` | Vim `syntax/sh.vim` | Vim License, kept | file header, `LICENSES/Vim.txt` |
| `20-no-embedded.conf` in `profiles/desktop-kde/` and `profiles/desktop-linux/` | ArchWiki | GFDL-1.3-only, kept | `20-no-embedded.conf.license` next to each file, `LICENSES/GFDL-1.3-only.txt` |

Note on the kept `20-no-embedded.conf` row:

- The `20-no-embedded.conf` files are unmodified copies from <https://wiki.archlinux.org/title/font_configuration>, whose license is GFDL 1.3 (<https://wiki.archlinux.org/title/ArchWiki:Copyrights>). They are an aggregate with the rest of this repository and stay under GFDL-1.3-only.

Git submodules (see `.gitmodules`) are independent projects under their own licenses.
