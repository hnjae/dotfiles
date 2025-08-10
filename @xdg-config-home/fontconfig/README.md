---
date_before: 2023-08-10
lastmod: 2025-04-30T15:58:40+0900
---


## tl;dr

- run `fc-cache -vf` to refresh cache

  `fc-match monospace -a`

- run `fc-match <font>` 로 매칭된 폰트 체크

  ```sh
  fc-match Monospace
  ```

### System fontconfig 설정

`/run/current-system/etc/fonts` 참고

### Nerd Fonts 차이

> - Pick your font family:
>   - If you are limited to monospaced fonts (because of your terminal, etc) then pick a font with `Nerd Font Mono` (or `NFM`).
>   - If you want to have bigger icons (usually around 1.5 normal letters wide) pick a font without `Mono` i.e. `Nerd Font` (or `NF`). Most terminals support this, but ymmv.
>   - If you work in a proportional context (GUI elements or edit a presentation etc) pick a font with `Nerd Font Propo` (or `NFP`).
>
> <https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/FiraCode#tldr> accessed 2025-04-30

### 주의점

<https://www.wp-vps.com/arch-manjaro-에서-chrome사용시-한글이-겹치고-깨져서-나올떄.html> 2023-03-10
위 이슈로 wqy_microhei 는 사용하지 말 것.

## Font in use

- Unicode Font
  - 한자 (일본식 자형)
    - ttf-hanazono (sans-serief)(확장 A~F 영역 폰트)
    - [cutra_AppendingToHanaMin (확장 G 영역 폰트)](http://ko.glyphwiki.org/wiki/Group:cutra_AppendingToHanaMin)
    - ttf-plangothic (serif)(가나 보충, 가나 확장 A)
  - others
    - ttf-tibetan-machine (Tibetan Font)
    - ttf-jomolhari (Tibetan 종카 문자)
    - lohit-fonts (Indic TrueType Fonts)(Oriya Fonts)
    - Paduk Fonts (Miyanma)
- For MS font subsititution
  - ipa-fonts ttf-liberation ttf-caladea ttf-carlito
  - ttf-gelasio-ib ttf-selawik ttf-tahoma
- Emoji
  - otf-openmoji
  - Noto Color Emoji (noto-fonts-color-emoji)

[백괴사전 윤희코드 특수 문자](https://uncyclopedia.kr/wiki/도움말:윤희코드_특수_문자) 참고

## 기타

- Pretendard

- RIDIBatang
