# nvim-lint CWD 설정 가이드

nvim-lint에서 linter가 실행되는 작업 디렉토리(cwd)를 제어하는 방법을 정리한 문서입니다.

## 목차

1. [기본 개념](#기본-개념)
2. [CWD 설정 방법](#cwd-설정-방법)
3. [프로젝트 루트 자동 감지](#프로젝트-루트-자동-감지)
4. [lazy.nvim 설정 예시](#lazynvim-설정-예시)

## 기본 개념

nvim-lint는 linter가 실행되는 작업 디렉토리(cwd)를 조절하는 옵션을 제공합니다. 이는 monorepo나 특정 디렉토리를 기준으로 linter를 실행해야 하는 경우 유용합니다.

### CWD 결정 우선순위

다음 순서로 cwd가 결정됩니다:

1. `opts.cwd` - `try_lint()` 호출 시 전달한 옵션
2. `linter.cwd` - linter 정의의 cwd 필드
3. `vim.fn.getcwd()` - 현재 Neovim의 작업 디렉토리

## CWD 설정 방법

### 방법 1: try_lint() 호출 시 옵션으로 지정

```lua
require("lint").try_lint("mylinter", { cwd = "/path/to/directory" })
```

### 방법 2: Linter 정의에서 cwd 필드 설정

문자열로 직접 지정:

```lua
local mylinter = require('lint').linters.mylinter
mylinter.cwd = '/path/to/directory'
```

함수로 동적 지정:

```lua
local mylinter = require('lint').linters.mylinter
mylinter.cwd = function()
  return vim.fn.getcwd()
end
```

## 프로젝트 루트 자동 감지

특정 파일(예: `package.json`, `pyproject.toml`, `.git`)이 있는 디렉토리를 찾아 cwd로 설정할 수 있습니다.

### 방법 1: vim.fs.root() 사용 (Neovim 0.10+, 권장)

```lua
local lint = require('lint')

lint.linters.eslint = (function()
  local original = lint.linters.eslint

  return function()
    local linter = original()

    -- .git, package.json, node_modules 중 하나가 있는 루트 찾기
    local root = vim.fs.root(0, {'.git', 'package.json', 'node_modules'})
    if root then
      linter.cwd = root
    end

    return linter
  end
end)()
```

### 방법 2: vim.fs.find() 사용 (Neovim 0.8+)

```lua
local lint = require('lint')

lint.linters.eslint = (function()
  local original = lint.linters.eslint

  return function()
    local linter = original()

    -- package.json을 찾아 그 디렉토리를 cwd로 설정
    local root_files = vim.fs.find({'package.json'}, {
      upward = true,
      stop = vim.loop.os_homedir(),
      path = vim.fs.dirname(vim.api.nvim_buf_get_name(0)),
    })

    if root_files[1] then
      linter.cwd = vim.fs.dirname(root_files[1])
    end

    return linter
  end
end)()
```

## lazy.nvim 설정 예시

### 기본 설정

```lua
{
  "mfussenegger/nvim-lint",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local lint = require("lint")

    -- 파일 타입별 linter 설정
    lint.linters_by_ft = {
      javascript = { "eslint" },
      typescript = { "eslint" },
      python = { "ruff" },
      lua = { "luacheck" },
    }

    -- eslint: package.json이 있는 디렉토리에서 실행
    lint.linters.eslint = (function()
      local original = lint.linters.eslint
      return function()
        local linter = original()

        -- package.json 찾기
        local root = vim.fs.root(0, { "package.json", ".git" })
        if root then
          linter.cwd = root
        end

        return linter
      end
    end)()

    -- ruff: pyproject.toml이 있는 디렉토리에서 실행
    lint.linters.ruff = (function()
      local original = lint.linters.ruff
      return function()
        local linter = original()

        -- Python 프로젝트 루트 찾기
        local root = vim.fs.root(0, {
          "pyproject.toml",
          "setup.py",
          "requirements.txt",
          ".git",
        })
        if root then
          linter.cwd = root
        end

        return linter
      end
    end)()

    -- Autocmd 설정: 파일 저장 시 lint 실행
    local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
    vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
      group = lint_augroup,
      callback = function()
        require("lint").try_lint()
      end,
    })
  end,
}
```

### 실용적인 다중 언어 지원 설정

```lua
{
  "mfussenegger/nvim-lint",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local lint = require("lint")

    lint.linters_by_ft = {
      javascript = { "eslint" },
      typescript = { "eslint" },
      javascriptreact = { "eslint" },
      typescriptreact = { "eslint" },
      python = { "ruff", "mypy" },
      lua = { "luacheck" },
      markdown = { "markdownlint" },
      go = { "golangcilint" },
    }

    -- 프로젝트 루트를 찾는 헬퍼 함수
    local function find_root(markers)
      return vim.fs.root(0, markers)
    end

    -- JavaScript/TypeScript 프로젝트
    local js_root_markers = { "package.json", ".git", "tsconfig.json" }

    lint.linters.eslint = (function()
      local original = lint.linters.eslint
      return function()
        local linter = original()
        local root = find_root(js_root_markers)
        if root then
          linter.cwd = root
        end
        return linter
      end
    end)()

    -- Python 프로젝트
    local py_root_markers = { "pyproject.toml", "setup.py", "requirements.txt", ".git" }

    lint.linters.ruff = (function()
      local original = lint.linters.ruff
      return function()
        local linter = original()
        local root = find_root(py_root_markers)
        if root then
          linter.cwd = root
        end
        return linter
      end
    end)()

    lint.linters.mypy = (function()
      local original = lint.linters.mypy
      return function()
        local linter = original()
        local root = find_root(py_root_markers)
        if root then
          linter.cwd = root
        end
        return linter
      end
    end)()

    -- Go 프로젝트
    lint.linters.golangcilint = (function()
      local original = lint.linters.golangcilint
      return function()
        local linter = original()
        local root = find_root({ "go.mod", ".git" })
        if root then
          linter.cwd = root
        end
        return linter
      end
    end)()

    -- Autocmd 설정
    local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
    vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
      group = lint_augroup,
      callback = function()
        require("lint").try_lint()
      end,
    })

    -- 키맵 설정 (선택사항)
    vim.keymap.set("n", "<leader>l", function()
      require("lint").try_lint()
    end, { desc = "Trigger linting for current file" })
  end,
}
```

### Neovim 0.8/0.9용 설정 (vim.fs.root가 없는 경우)

```lua
{
  "mfussenegger/nvim-lint",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local lint = require("lint")

    lint.linters_by_ft = {
      javascript = { "eslint" },
      python = { "ruff" },
    }

    -- vim.fs.find를 사용하는 버전
    local function find_root(markers)
      local root_files = vim.fs.find(markers, {
        upward = true,
        stop = vim.loop.os_homedir(),
        path = vim.fs.dirname(vim.api.nvim_buf_get_name(0)),
      })

      if root_files[1] then
        return vim.fs.dirname(root_files[1])
      end
      return nil
    end

    lint.linters.eslint = (function()
      local original = lint.linters.eslint
      return function()
        local linter = original()
        local root = find_root({ "package.json", ".git" })
        if root then
          linter.cwd = root
        end
        return linter
      end
    end)()

    -- Autocmd
    local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
    vim.api.nvim_create_autocmd({ "BufWritePost" }, {
      group = lint_augroup,
      callback = function()
        require("lint").try_lint()
      end,
    })
  end,
}
```

## 언어별 루트 마커 예시

### JavaScript/TypeScript
```lua
{ "package.json", "tsconfig.json", "jsconfig.json", ".git" }
```

### Python
```lua
{ "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", "Pipfile", ".git" }
```

### Go
```lua
{ "go.mod", ".git" }
```

### Rust
```lua
{ "Cargo.toml", ".git" }
```

### Ruby
```lua
{ "Gemfile", ".git" }
```

## 참고 사항

- linter를 함수로 wrapping할 때는 원본 linter를 먼저 호출한 후 수정해야 합니다
- `vim.fs.root()` (Neovim 0.10+)가 `vim.fs.find()`보다 간결하고 권장됩니다
- 프로젝트 루트를 찾지 못한 경우 기본 cwd(현재 디렉토리)가 사용됩니다
- 동적으로 cwd를 계산하므로 lint가 실행될 때마다 현재 버퍼 기준으로 루트를 찾습니다

## 실제 사용 예시

nvim-lint 저장소 내의 다음 파일들이 좋은 참고 예시입니다:

- `lua/lint/linters/swiftlint.lua` - `.swiftlint.yml` 파일 찾기
- `lua/lint/linters/vulture.lua` - git 루트 찾기
- `lua/lint/linters/perlcritic.lua` - `.perlcriticrc` 파일 찾기
