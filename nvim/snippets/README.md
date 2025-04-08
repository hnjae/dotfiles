# `snippets/`

## 개요

- friendly-snippets 의 [eff286 (2024-12-02)](https://github.com/rafamadriz/friendly-snippets/commit/efff286dd74c22f731cdec26a70b46e5b203c619) 에서 분기하였다 (2025-04-08).
- 유지보수의 용이성을 위해 내가 관리하는 snippets에는 `-2`를 붙여 작성하며, 기존 friendly-snippets과 중복되면 friendly-snippets의 값을 지운다.

## 이름 명명 도식

### `s` prefix

> `markdonw`,`asciidoc`, `direnv` 등과 같은 파일타입에서는 `s` 로 시작하는 prefix 를 만들자.

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

## 같이 보기

- <https://code.visualstudio.com/docs/editing/userdefinedsnippets>
