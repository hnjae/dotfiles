---
date: 2026-03-15T13:03:58+0900
lastmod: 2026-03-15T13:03:58+0900
---

## tl;dr

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

## Scheme 작성 가이드

light variant 에서는 다음 규칙을 따른다.

- ANSI 8 은 각종 프로그램에서 comments 용도로 쓰인다. 어두운 계열을 사용할 것.
- ANSI Bright 이 더 어두운 색을 사용
    - base08–base0e (except base09) 와 base12–base17 swap
