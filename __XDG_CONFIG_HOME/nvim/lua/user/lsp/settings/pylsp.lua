--[[
pycodestyle 에서 ignore 에 추가하면 format할때도 ignore 된다.
]]

local M = {}

M.unavailable = {
  -- [vim.lsp.buf.range_formatting] = true
  -- [vim.lsp.buf.range_formatting] = true
  [vim.lsp.buf.formatting] = true
}

M.opts = {
  settings = {
    pylsp = {
      plugins = {
        ---------------------------
        -- linter
        ---------------------------
        -- style check
        pycodestyle = {enabled = false},
        -- missing-function-docstring 일 경우 ERROR 를 내뱉어서 사용X
        pydocstyle = {
          enabled = false,
          -- ignroe = {},
        },

        -- linter to detect various error
        -- var not use 를 warning 로 내뿜어서 (2022-07-02)
        -- import but not use 를 warning 으로 내뿜음.
        -- 따로 설정도 불가능 (2022-07-02)
        pyflakes = {enabled = false},

        -- complexity check
        mccabe = {enabled = true},


        -- pycodestyle = { ignore = { } },,
        pylint = {
          enabled = true,
          args = {
            "--disable",
            -- "W0511,W0611,C0411"
            "W0511,W0611,W0612,W0613,C0114,C0116,C0301,C0411"
            -- W0511: fix-me
            -- W0611: unused-import  -- checked in pyflakes
            -- W0612: unused-variable
            -- W0613: unused-argument
            -- C0103: invalid-name
            -- C0114: missing-module-docstring
            -- C0116: missing-function-docstring
            -- C0301: line-too-long
            -- C0411: wrong-import-order
          },
        },
        ---------------------------
        --error checking?
        ---------------------------
        -- error checking (disabled by default 2022-07-02)
        -- assigned not use, import not use 가 warning (2022-07-02)
        -- 해당 기능은 pyright 에서 하면 될것 같음.
        -- 이건 설정은 가능
        flake8 = {enabled = false},

        ---------------------------
        -- rope
        ---------------------------
        rope_completion = {enabled = true, eager=true},

        ---------------------------
        -- jedi
        ---------------------------
        jedi_completion = {enabled = true},
        jedi_definiton = {enabled = true},
        jedi_hover = {enabled  = true},
        jedi_references = {enabled = true},
        jedi_signature_help = {enabled = true},
        jedi_symbols = {enabled = true, all_scopes = true},
      },
    },
  }
}

return M
