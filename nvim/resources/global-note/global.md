### tl;dr

#### Surround

* use `S` in visual mode.
* 시작 pair 은 whitespace 를 insert, 끝 pair 은 생략한다.

#### Textobjects

  ```lua
  -- sh, css, fish, go, js, lua, py, rs, ts, yaml
  ["as"] = { query = "@statement.outer",  desc = "@statement.outer" }, -- override sentence (won't override if not supported)
  ["aa"] = { query = "@assignment.outer", desc = "@assignment.outer" },
  ["ia"] = { query = "@assignment.inner", desc = "@assignment.inner" },
  ["la"] = { query = "@assignment.lhs",   desc = "@assignment.lhs" },
  ["ra"] = { query = "@assignment.rhs",   desc = "@assignment.rhs" },

  ["a/"] ={ query = "@comment.outer",  desc = "@comment.outer" },
  ["a*"] ={ query = "@comment.outer",  desc = "@comment.outer" },
  ["ac"] ={ query = "@comment.outer",  desc = "@comment.outer" },

  ["am"] = { query = "@function.outer",   desc = "@function.outer" },
  ["im"] = { query = "@function.inner",   desc = "@function.inner" },

  ["al"] = { query = "@loop.outer",       desc = "@loop.outer" },
  ["il"] = { query = "@loop.inner",       desc = "@loop.inner" },
  ["in"] = { query = "@number.inner",     desc = "@number.inner" },
  ["ir"] = { query = "@parameter.inner",  desc = "@parameter.inner" },
  ["ar"] = { query = "@parameter.outer",  desc = "@parameter.outer" },
  --
  ["aC"] = { query = "@class.outer",      desc = "@class.outer" },
  ["iC"] = { query = "@class.inner",      desc = "@class.inner" },
  --
  ["ax"] = { query = "@call.outer",       desc = "@call.outer" },
  ["ix"] = { query = "@call.inner",       desc = "@call.inner" },

  -- go, js, tex, lua, py, rs, ts
  ["ap"] = { query = "@block.outer",      desc = "@block.outer" },
  ["ip"] = { query = "@block.inner",      desc = "@block.inner" },

  ["ao"] = { query = "@conditional.outer", desc = "@conditional.outer" },
  ["io"] = { query = "@conditional.inner", desc = "@conditional.inner" },
  ```

#### Replace character

* \n 는 null character 을 입력하게 됨. \r 로 replace 하면 된다.
* `:%s/\<foo\>/bar/gc` 가 confirmation 하면서 바꾸기.

#### Insert Mode Tips

`<c-d>`, `<c-t>` 로 Insert 모드에서 인덴트를 조절할 수 있다.

#### Incremental 한 숫자 리스트 만들기

Visual 로 숫자들 선택 후, `g<C-a>`

#### Sort lines

`:'<,'>sort`

#### 모든 라인 끝에 추가

`:%norm A<추가할 string>`

`%`: 모든 라인에 해당 명령 수행
`norm`: 다음의 normal command를 수행
`A`: `Append`

#### Chatgpt.nvim

##### Interactive popup

When using ChatGPT and ChatGPTEditWithInstructions, the following keybindings are available:

<C-Enter> [Both] to submit.
<C-y> [Both] to copy/yank last answer.
<C-o> [Both] Toggle settings window.
<C-h> [Both] Toggle help window.
<Tab> [Both] Cycle over windows.
<C-f> [Chat] Cycle over modes (center, stick to right).
<C-c> [Both] to close chat window.
<C-p> [Chat] Toggle sessions list.
<C-u> [Chat] scroll up chat window.
<C-d> [Chat] scroll down chat window.
<C-k> [Chat] to copy/yank code from last answer.
<C-n> [Chat] Start new session.
<C-r> [Chat] draft message (create message without submitting it to server)
<C-r> [Chat] switch role (switch between user and assistant role to define a workflow)
<C-s> [Both] Toggle system message window.
<C-i> [Edit Window] use response as input.
<C-d> [Edit Window] view the diff between left and right panes and use diff-mode commands
When the setting window is opened (with <C-o>), settings can be modified by pressing Enter on the related config. Settings are saved across sections
