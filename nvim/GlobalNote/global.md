### tl;dr

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
  ["ip"] = { query = "@parameter.inner",  desc = "@parameter.inner" },
  ["ap"] = { query = "@parameter.outer",  desc = "@parameter.outer" },
  --
  ["aC"] = { query = "@class.outer",      desc = "@class.outer" },
  ["iC"] = { query = "@class.inner",      desc = "@class.inner" },
  --
  ["ax"] = { query = "@call.outer",       desc = "@call.outer" },
  ["ix"] = { query = "@call.inner",       desc = "@call.inner" },

  -- go, js, tex, lua, py, rs, ts
  ["ak"] = { query = "@block.outer",      desc = "@block.outer" },
  ["ik"] = { query = "@block.inner",      desc = "@block.inner" },
  ```

#### Replace character with new line

\n 는 null character 을 입력하게 됨. \r 로 replace 하면 된다.

#### Incremental 한 숫자 리스트 만들기

Visual 로 숫자들 선택 후, `g<C-a>`
