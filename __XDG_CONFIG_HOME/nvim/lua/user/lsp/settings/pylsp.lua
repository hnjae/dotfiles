--[[
pycodestyle 에서 ignore 에 추가하면 format할때도 ignore 된다.
]]

return {
  settings = {
    pylsp = {
      plugins = {
        ---------------------------
        -- linter
        ---------------------------
        -- style check
        pycodestyle = {enabled = false},
        -- various errors
        pyflakes = {enabled = true},
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
        -- missing-function-docstring 일 경우 ERROR 를 내뱉어서 사용X
        pydocstyle = { enabled = false },
        ---------------------------

        ---------------------------
        -- rope
        ---------------------------
        -- rope_completion 은 그 내용을 보여주지 않는다. 2022-05-09
        rope_completion = {enabled = false},

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
