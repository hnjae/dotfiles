return {
  [1] = "snacks.nvim",
  optional = true,
  ---@type snacks.Config
  opts = {
    picker = {
      sources = {
        explorer = {
          -- auto_close = true,

          -- layout = { preset = "vscode" },
          layout = {
            preset = "sidebar",
            layout = {
              width = 31, -- default 50
            },
          },
          actions = {
            explorer_add_file = function(picker)
              local Tree = require("snacks.explorer.tree")
              local uv = vim.uv or vim.loop

              Snacks.input({
                prompt = "Add a new file",
              }, function(value)
                if not value or value:find("^%s$") then
                  return
                end
                local path = svim.fs.normalize(picker:dir() .. "/" .. value)
                local parent_dir = vim.fs.dirname(path)
                if uv.fs_stat(path) then
                  Snacks.notify.warn("File already exists:\n- `" .. path .. "`")
                  return
                end

                vim.fn.mkdir(parent_dir, "p")
                io.open(path, "w"):close()
                Tree:open(parent_dir)
                Tree:refresh(parent_dir)
                require("snacks.explorer.actions").update(picker, { target = path })
              end)
            end,
            explorer_add_dir = function(picker)
              local Tree = require("snacks.explorer.tree")

              Snacks.input({
                prompt = "Add a new directory",
              }, function(value)
                if not value or value:find("^%s$") then
                  return
                end
                local dir = svim.fs.normalize(picker:dir() .. "/" .. value)
                vim.fn.mkdir(dir, "p")
                Tree:open(dir)
                Tree:refresh(dir)
                require("snacks.explorer.actions").update(picker, { target = dir })
              end)
            end,
          },

          win = {
            list = {
              keys = {
                -- disable defaults:
                ["a"] = function() end, -- "explorer_add",
                ["<leader>/"] = function() end, -- "picker_grep",
                ["y"] = function() end, -- "explorer_yank",
                ["m"] = function() end, -- "explorer_move",
                ["c"] = function() end, -- "explorer_copy",

                -- file picker 랑 동작 통일:
                ["<c-t>"] = "tab", -- default: terminal
                ["<c-v>"] = "edit_vsplit",
                ["<c-s>"] = "edit_split",

                -- ?
                ["<c-r>"] = "terminal", -- terminal 맵핑 옮김
                ["<c-o>"] = "edit_split", -- netrw 의 `o` 에서 따옴

                -- NEW & replace:
                ["P"] = "edit_split", -- netrw alike; default: toggle_preview; netrw: browes-in-previously-used-window
                ["p"] = "toggle_preview", -- netrw alike;
                ["o"] = "edit_split", -- netrw 랑 동작 일치화; default: explorer_open <2025-04-24>
                ["H"] = "list_top", -- netrw 랑 동작 일치화
                ["v"] = "edit_vsplit", -- netrw 랑 동작 일치화
                ["t"] = "tab", -- netrw 랑 동작 일치화

                ["%"] = "explorer_add_file", -- netrw 랑 동작 일치화
                ["d"] = "explorer_add_dir", -- netrw 랑 동작 일치화 (netrw: create directory)
                ["D"] = "explorer_del", -- netrw 랑 동작 일치화

                ["gx"] = "explorer_open", -- netrw 랑 동작 일치화
                ["gh"] = "toggle_hidden", -- netrw 랑 동작 일치화
                ["gi"] = "toggle_ignore",
                ["I"] = "toggle_help_input", -- default: toggle_ignore; netrw: toggle banner
                ["mg"] = "picker_grep", -- netrw 랑 동작 일치화

                --
                ["mc"] = { "explorer_yank", mode = { "n", "x" } }, -- netrw-alike
                ["mp"] = "explorer_paste",
                ["gm"] = "explorer_move",
                ["gc"] = "explorer_copy",

                -- default:
                ["r"] = "explorer_rename",
              },
            },
          },
        },
      },
    },
  },
  keys = function(_, keys)
    local snacks = require("snacks")

    vim.list_extend(keys, {
      {
        [1] = "<leader>fe",
        [2] = function()
          -- snacks.explorer(vim.tbl_extend("force", opts, {
          --   cwd = LazyVim.root(),
          -- }))
          snacks.explorer({
            cwd = LazyVim.root(),
          })
        end,
        desc = "Explorer Snacks (root dir)",
      },
      {
        [1] = "<leader>fE",
        [2] = function()
          -- snacks.explorer(vim.tbl_extend("force", opts, {
          --   cwd = vim.fn.expand("%:h"),
          -- }))
          snacks.explorer({
            cwd = vim.fn.expand("%:h"),
          })
        end,
        desc = "Explorer Snacks (cwd)",
      },
      { [1] = "<leader>e", [2] = "<leader>fe", desc = "Explorer Snacks (root dir)", remap = true },
      { [1] = "<leader>E", [2] = "<leader>fE", desc = "Explorer Snacks (cwd)", remap = true },
    })

    return keys
  end,
}
