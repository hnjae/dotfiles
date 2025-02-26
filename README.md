## 코드 구조를 까먹는 스스로를 위해 작성한 Cheatsheet

### 코드 스트럭처

기본적으로 LazyVim 에서 따옴.

* `lua/config`:
  * neovim 자체 설정
* `lua/plugins`:
  * 플러그인 스펙들
* `lua/utils`:
  * 내가 필요해서 작성한 유틸 함수/평가된 값들
* `lua/val`:
  * 설정 전역적으로 참조하는 상수값.
  * 맵핑 prefix, 키워드 등에 사용. (일관된 맵핑을 위해)
  * `lua/val/plugins`:
    * 전역적으로 참조되는 플러그인의 설정 (e.g. lualine) 을 선언
* `lua/state`:
  * 설정에서 전역적으로 참조하는 변수 값.
  * neovim 이 이미 실행되면 변하지 않는데, `state` 라는 명명은 좋지 않은 것 같음. `lua/var` 로 수정하자.

### 내가 작성한 유용한 utils

- `require("utils").is_plugin("gitsigns.nvim")` 식으로 어느 플러그인이 사용되고 있는지 조회할 수 있음.
- `require("utils.plugin").on_load("nvim-cmp", <callback>)` 식으로 어느 플러그인 로드될때 콜백할 함수를 설정할 수 있음.

### 특별한 플러그인 Spec

#### "nvim-tree/nvim-web-devicons"

특정 파일타입, 파일명의 아이콘을 관리

#### "onsails/lspkind.nvim"

lsp 관련 아이콘을 관리

### 플러그인의 `opts` 스펙만을 사용해서 설정하지 않는 플러그인들

다음 플러그인들은 플러그인의 `opts` 스펙만으로는 설정이 버거워 별도의 스펙을 사용한다.

#### `nvim-lualine/lualine.nvim`

* `opts` 로 `myLualineOpts` 사용
* `lua/state/luline-ft-data` 로 아이콘 관리
* `require("val/plugins/lualine")`

#### `hrsh7th/nvim-cmp`

`opts` 로 `myCmpOpts` 사용

####  `neovim/nvim-lspconfig`,

* `myLspconfigOpts` 사용

#### `nvim-treesitter/nvim-treesitter`,

* `require("state.treesitter-langs")` 로 `opts.ensure_installed` 관리
  * `opts.ensure_installed` 가 리스트라 중복값 등록 방지를 위해 별도로 뺌
* `require("utils").is_treesitter` 플래그로 treesitter 사용 여부 결정하는 구조를 가짐.
