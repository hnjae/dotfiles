---
date: 2026-03-15T13:03:58+0900
lastmod: 2026-03-15T13:03:58+0900
---

## tl;dr

- <https://github.com/tinted-theming/base24/blob/main/styling.md>

### Generate scheme from image

```sh
tinty generate-scheme \
    --system base16 \
    --variant dark \
    --name "My Theme" \
    --slug my-theme \
    --author "Your Name" \
    --save /path/to/image.png
```

`~/.local/share/tinted-theming/tinty/custom-schemes/base16/my-theme.yaml` 에 자동으로 생성

### Other commands

```sh
tinty install                      # install schemes from repo
tinty list --custom-schemes        # 목록에 나타나는지 확인
tinty apply base16-my-custom-theme # 적용
```

## NOTE

- base03(ANSI 8) 은 BAT 에서 comments 용도로 쓰인다. 어두운 계열을 사용할 것.
- `fzf` 는 base03(ANSI 8) 를 fg 로, base07(ANSI 15) 를 bg 로 쓰인다. 둘의 색상 차이가 있어야 할 것.

## Scheme 작성 가이드

light variant 에서는 다음 규칙을 따른다.

- ANSI Bright 이 더 어두운 색을 사용
    - base08–base0e (except base09) 와 base12–base17 swap
