
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
