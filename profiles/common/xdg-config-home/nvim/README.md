---
title: NOTE
date: 2025-04-07T17:30:03+0900
lastmod: 2026-01-05T15:20:25+0900
---

## 같이 보기

- colorscheme:
  <https://vimcolorschemes.com/i/trending/b.light>

## Prerequisites

- `make`: `LuaSnip` 을 위해 필요

### Mason

`mason` 에서의 패키지 설치를 위해 다음의 패키지들이 필요합니다. 만일 dependency 가 충족되지 않으면 설치를 건너뛰게 됩니다.

#### 예시

- `unzip`: e.g. stylua, codelldb, java-debug-adapter, java-test, tflint, ast-grep
- `npm`: prettier
- `go`: goimports, gofumpt, delve
- `python3`: ansible-lint, cmakelang, cmakelint, sqlfluff

## TODO

- [ ] lualine 의 확장성이 너무 안좋다. <https://github.com/rebelot/heirline.nvim> 대체를 고민하자. 2025-04-08
- [ ] bufferline: 이름 없는 탭 닫기

### Neovim 0.11.0

<https://www.youtube.com/watch?v=ZiH59zg59kg>

- <https://x.com/Neovim/status/1898016686097187266>

  > Use ]] / [[ in :terminal to jump to next/previous shell prompt. ":help terminal-osc133" shows how to create signs, too.

### Neovim 0.12.0

- [feat(lsp): support textDocument/documentColor #33440](https://github.com/neovim/neovim/pull/33440)
