
## 디렉토리 구조

다음 순서대로 import 된다.

```
.
├── visual/ # Tweaking aesthetic settings of default LazyVim plugins (e.g. icon)
├── overrides/ # Tweaking settings of default LazyVim plugins
├── lazydev/ # Tweaking lazydev settings of default LazyVim plugins
├── replacements/ # Disabling LazyVim defaults and using alternatives
└── extends/ # Adding NEW plugins/functionality not in LazyVim & not language-specific
├── lang/ # Language-specific settings & plugins
```

### lazydev

`LazyVim` 에서 관리하는 플러그인들의 설정만 모음. `overrides` 가 너무 커져 별도로 뺌.

## 기타

#### `icons`

- `outline` 류의 아이콘을 사용한다.
- `nf-fa-`, `nf-oct-` 종류는 아이콘이 비정상적으로 크다. 가능하면 사용하지 말자.
    - e.g.:
        -  : nf-oct-skip
        -  : nf-fa-ban
        -  : nf-seti-github
        -  : nf-seti-db
        -  : nf-dev-firefox
        -  : nf-dev-sqldeveloper
        - 󰀚 : nf-md-adjust
        - 󰠆 : nf-md-basketball
        -  : nf-cod-error
        -  : nf-cod-circle_slash
        -  : nf-cod-github

## Cheat Sheet

#### `:map-table`

```help
       *map-table*
         Mode  | Norm | Ins | Cmd | Vis | Sel | Opr | Term | Lang | ~
Command        +------+-----+-----+-----+-----+-----+------+------+ ~
[nore]map      | yes  |  -  |  -  | yes | yes | yes |  -   |  -   |
n[nore]map     | yes  |  -  |  -  |  -  |  -  |  -  |  -   |  -   |
[nore]map!     |  -   | yes | yes |  -  |  -  |  -  |  -   |  -   |
i[nore]map     |  -   | yes |  -  |  -  |  -  |  -  |  -   |  -   |
c[nore]map     |  -   |  -  | yes |  -  |  -  |  -  |  -   |  -   |
v[nore]map     |  -   |  -  |  -  | yes | yes |  -  |  -   |  -   |
x[nore]map     |  -   |  -  |  -  | yes |  -  |  -  |  -   |  -   |
s[nore]map     |  -   |  -  |  -  |  -  | yes |  -  |  -   |  -   |
o[nore]map     |  -   |  -  |  -  |  -  |  -  | yes |  -   |  -   |
t[nore]map     |  -   |  -  |  -  |  -  |  -  |  -  | yes  |  -   |
l[nore]map     |  -   | yes | yes |  -  |  -  |  -  |  -   | yes  |
```

#### 유용한 vim 함수

- `vim.list_extends`
- `vim.tbl_filter`
- `vim.tbl_contains`
- `vim.tbl_deep_extend`
