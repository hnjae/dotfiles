---
date: 2025-06-17T17:39:45+0900
lastmod: 2025-06-22T20:18:34+0900
---

- 이거 작동하지 않는다. (v0.27)
- 당분간은 tinted-builder-rust 로 직접 scheme 을 빌드하자.

## 작성 가이드

- light variant 에서는 base24 에서 정의한 것과 다르게 작성한다. 다음 규칙을 따른다.
    - bright color (ANSI 9+) 는 normal color (ANSI 0+) 보다 밝다.
        - ※ ANSI 0 (base01) 와, ANSI 8 (base02) 은 예외. ANSI 0 가 ANSI 8 보다 밝다.
    - ANSI 8 은 각종 프로그램에서 comments 용도로 쓰이기 때문에, ANSI 7 (base07) 보다는 밝되, 어두운 색을 사용한다.

## TODO

- kanagawa 는 0.1.0 spec 을 따르지 않음.
