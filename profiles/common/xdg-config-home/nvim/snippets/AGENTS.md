# `snippets/`

## 개요

- Snippets are vscode-format JSON loaded by LuaSnip's `from_vscode` loader. Only files registered in `package.json` (`contributes.snippets`, one entry per file with its languages) are loaded, so register every new file there. Other formats, such as snipmate `.snippets`, are not read.
- Files derived from friendly-snippets carry the `-friendly` suffix (`foo-friendly.json`); snippets written by the maintainer have no suffix, and directory names carry none either. When a maintainer snippet duplicates a friendly-snippets one, delete the friendly-snippets entry.
- `REUSE.toml` gives every `*-friendly.json` the upstream holder, so never add the suffix to an own file. An own file whose body quotes license text or SPDX tags (such as `license.json`) needs a `.license` sidecar, because REUSE would otherwise read the body as licensing data.

## 이름 명명 도식

### `s` prefix

> `markdown`,`asciidoc`, `direnv` 등과 같은 파일타입에서는 `s` 로 시작하는 prefix 를 만들자.

이유: `cmp` 과 같은 autocomplete 플러그인에서 찾기 쉽기 위해.

### `boilerplate` prefix

boilerplate 을 작성

### `recipes` 파일명

언어의 syntax 가 아니라, 유용한 코드 조합.

### 기타

- 함수 선언 prefix 는 3글자로 통일 (`fun`,`def`, ...) (예외: `fn`)
- `shebang` 의 prefix 는 `shebang` 과 `#env` (`env` 를 쓴다면)
- `else if` 에는 반드시 `elif` prefix 도 추가할 것.
- `import`: `im`, `from xxx import yyy`: `fim`
- `prefix`, `description`, `body` 순으로 적을 것. cmp 등에서 description → body 순서로 보여지기 때문에.
- In a JSON `body`, write a literal backslash as `\\\\` (JSON escape plus snippet escape) and a literal `$` as `\\$`; LaTeX `\begin` is `"\\\\begin"`. Keep notes and samples out of this tree: a file that is not a registered snippet file does nothing.

## 같이 보기

- <https://code.visualstudio.com/docs/editing/userdefinedsnippets>
