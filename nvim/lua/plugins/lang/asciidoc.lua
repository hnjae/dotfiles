-- TODO: map preview at <leader>cp <2025-04-10>
---@type LazySpec[]
return {
  {
    [1] = "nvim-treesitter",
    optional = true,
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      table.insert(opts.ensure_installed, "asciidoc")
      -- opts.highlight = opts.highlight or {}
      -- opts.highlight.additional_vim_regex_highlighting = true

      --[[
      ```
      <2025-04-09>

      Parser/Features         H L F I J
        - asciidoc            . . . . .
      ```
      ]]

      LazyVim.on_load("nvim-treesitter", function()
        require("nvim-treesitter.parsers").get_parser_configs().asciidoc = {
          install_info = {
            url = "https://github.com/cpkio/tree-sitter-asciidoc",
            files = {
              "src/parser.c",
              "src/scanner.c",
            },
            branch = "master",
            generate_requires_npm = false,
            requires_generate_from_grammar = false,
          },
          ft = { "asciidoc" },
          maintainers = { "@cpkio" },
        }
      end)

      -- NOTE: 위 treesitter 설치 후, syntax 가 자동으로 로드되질 않는다. <2025-04-09>

      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "asciidoc" },
        callback = function(args)
          -- HACK: 여기서 바로 syntax 설정을 해도 적용이 되질 않아, defer_fn 으로 딜레이 해서 syntax 로드 <2025-04-09>

          vim.defer_fn(function()
            local has_ts_attached = pcall(vim.treesitter.get_parser, args.buf, "asciidoc")
            if not has_ts_attached then
              vim.notify(
                "Treesitter parser didn't seem to attach for asciidoc even after delay.",
                vim.log.levels.WARN
              )
            end

            -- NOTE: syntax/asciidoc.vim 에 직접 작정한 syntax 파일이 있다.
            vim.bo.syntax = "asciidoc"
          end, 10)
        end,
      })
    end,
  },
  {
    [1] = "habamax/vim-asciidoctor",
    version = false,
    lazy = true,
    cond = false,
    ft = { "asciidoc", "asciidoctor" },
    cmd = {
      "AsciidoctorOpenRAW",
    },
    ---@type LazyKeysSpec[]
    keys = {
      --[[ {
        [1] = require("globals").prefix.buffer .. "p",
        [2] = "<cmd>AsciidoctorOpenRAW<CR>",
        desc = "preview-asciidoc",
        ft = {
          "asciidoc",
          "asciidoctor",
        },
      }, ]]
    },
    init = function()
      -- NOTE: handlr can not handle asciidoc file.
      -- It recognize it as text file.
      local utils = require("utils")
      vim.g.asciidoctor_opener = "!" .. utils.get_browser_cmd()

      vim.g.asciidoctor_folding = 1
      vim.g.asciidoctor_syntax_indented = 1
      vim.g.asciidoctor_fenced_languages = {
        "html",
        "python",
        "java",
        -- "kotlin", -- requires styles/kotlin.vim
        "sh",
        "ruby",
        "dockerfile",
        "sql",
        "c",
        "nix",
        "typescript",
        "javascript",
      }
      --[[ NOTE: <2024-04-08>
    `asciidoctor_fenced_languages` 는 styles/<ft-name>.vim 를 요구하는 것 같음
    kotlin 의 경우 syntax support 가 내장되어 있지 않아, 에러 메시지가 뜸.

    그러나 treesitter 에서 syntax 를 지원해서 별도로 설치 하지는 않을 예정.
    ]]
      vim.g.asciidoctor_syntax_conceal = 1
    end,
  },
  {
    [1] = "tagbar",
    optional = true,
    ft = { "asciidoc", "asciidoctor" },
    -- opts = function()
    -- vim.g.tagbar_type_asciidoctor = {
    --   ["sro"] = '""',
    --   ["sort"] = 0,
    --   ["ctagstype"] = "asciidoc",
    --   ["regex"] = {
    --     "/^(={1,6})[[:space:]\\t]+([^=]+)/\\1 \\2/h,header,AsciiDoctor Headers/",
    --   },
    --   ["kinds"] = {
    --     "h:headings",
    --   },
    -- }
    -- end,
  },
  {
    [1] = "vim-gutentags",
    optional = true,
    ft = { "asciidoc", "asciidoctor" },
  },
}
