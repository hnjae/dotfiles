
## 디렉토리 구조

```
.
├── lang/ # Language-specific settings & plugins
├── overrides/ # Tweaking settings of default LazyVim plugins
├── replacements/ # Disabling LazyVim defaults and using alternatives
└── extends/ # Adding NEW plugins/functionality not in LazyVim & not language-specific
```

### `lang`

`nvim-lint` 가 `cwd` 를 함수로 넘길 수 없는 이상, `cwd` 를 설정해야하는 linter 는 `none-ls` 를 사용하자.

## 기타

#### `icons`

- `nf-fa-`, `nf-oct-` 종류는 아이콘이 비정상적으로 큰 것 같다. 가능하면 사용하지 말자.
  - e.g.:
    -  : nf-fa-ban
    -  : nf-oct-skip
    -  : nf-seti-github
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
