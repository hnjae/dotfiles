## tl;dr

### Surround

- use `S` in visual mode.
- 시작 pair 은 whitespace 를 insert, 끝 pair 은 생략한다.

### Textobjects

- flash.nvim 의 `S` 맵핑 사용.

- LazyVim 의 `mini.ai` 설정 (v14.14.0):

  ``` lua
  -- coding.lua
      custom_textobjects = {
        o = ai.gen_spec.treesitter({ -- code block
          a = { "@block.outer", "@conditional.outer", "@loop.outer" },
          i = { "@block.inner", "@conditional.inner", "@loop.inner" },
        }),
        f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }), -- function
        c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }), -- class
        t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" }, -- tags
        d = { "%f[%d]%d+" }, -- digits
        e = { -- Word with case
          { "%u[%l%d]+%f[^%l%d]", "%f[%S][%l%d]+%f[^%l%d]", "%f[%P][%l%d]+%f[^%l%d]", "^[%l%d]+%f[^%l%d]" },
          "^().*()$",
        },
        g = LazyVim.mini.ai_buffer, -- buffer
        u = ai.gen_spec.function_call(), -- u for "Usage"
        U = ai.gen_spec.function_call({ name_pattern = "[%w_]" }), -- without dot in function name



  -- treesitter.lua
  goto_next_start = { ["]f"] = "@function.outer", ["]c"] = "@class.outer", ["]a"] = "@parameter.inner" },
  goto_next_end = { ["]F"] = "@function.outer", ["]C"] = "@class.outer", ["]A"] = "@parameter.inner" },
  goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer", ["[a"] = "@parameter.inner" },
  goto_previous_end = { ["[F"] = "@function.outer", ["[C"] = "@class.outer", ["[A"] = "@parameter.inner" },
  ```

### Snack's Explorer

```lua
        ["<BS>"] = "explorer_up",
        ["l"] = "confirm",
        ["h"] = "explorer_close", -- close directory
        ["a"] = "explorer_add",
        ["d"] = "explorer_del",
        ["r"] = "explorer_rename",
        ["c"] = "explorer_copy",
        ["m"] = "explorer_move",
        ["o"] = "explorer_open", -- open with system application
        ["P"] = "toggle_preview",
        ["y"] = { "explorer_yank", mode = { "n", "x" } },
        ["p"] = "explorer_paste",
        ["u"] = "explorer_update",
        ["<c-c>"] = "tcd",
        ["<leader>/"] = "picker_grep",
        ["<c-t>"] = "terminal",
        ["."] = "explorer_focus",
        ["I"] = "toggle_ignored",
        ["H"] = "toggle_hidden",
        ["Z"] = "explorer_close_all",
        ["]g"] = "explorer_git_next",
        ["[g"] = "explorer_git_prev",
        ["]d"] = "explorer_diagnostic_next",
        ["[d"] = "explorer_diagnostic_prev",
        ["]w"] = "explorer_warn_next",
        ["[w"] = "explorer_warn_prev",
        ["]e"] = "explorer_error_next",
        ["[e"] = "explorer_error_prev",
```

### LazyVim

#### Snacks

- `<c-v>` vsplit
- `<c-s>` split
- `<c-t>` tab

### Macro

`<C-r><C-r>b` 를 누르면 `b` 에 저장된 매크로가 출력됨.

``` vim
let @w='wyw$a = #(^M    [^[pbg~w$a, "^[pa"],^M#^[pa^M);^[0xx$'
```

이후 식으로 사용하면 된다.

### Replace character

- 는 null character 을 입력하게 됨. 로̊ replace 하면 된다.
- `:%s/\<foo\>/bar/gc` 가 confirmation 하면서 바꾸기.

### Insert Mode Tips

`<c-d>`, `<c-t>` 로 Insert 모드에서 인덴트를 조절할 수 있다.

### Incremental 한 숫자 리스트 만들기

Visual 로 숫자들 선택 후, `g<C-a>`

### Sort lines

`:'<,'>sort`

### 모든 라인 끝에 문자열 추가

`:%norm A<추가할 string>`

`%`: 모든 라인에 해당 명령 수행
`norm`: 다음의 normal command를 수행
`A`: `Append`
