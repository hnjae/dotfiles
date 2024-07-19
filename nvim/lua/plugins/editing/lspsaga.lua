-- alternative: https://github.com/utilyre/barbecue.nvim

---@type LazySpec
local M = {
  [1] = "nvimdev/lspsaga.nvim",
  lazy = true,
  event = "LspAttach",
  enabled = true,
  dependencies = {
    { [1] = "nvim-tree/nvim-web-devicons", optional = true },
    "nvim-treesitter/nvim-treesitter",
  },
  opts = function()
    local utils = require("utils")
    local map_keyword = require("val").map_keyword

    local ret = {
      scroll_preview = {
        scroll_down = "<C-f>",
        scroll_up = "<C-b>",
      },
      code_action = {
        show_server_name = true,
        extend_gitsigns = utils.is_plugin("gitsigns.nvim"),
      },

      lightbulb = {
        -- NOTE: textDocument/codeAction 을 지원안할 경우, 에러 메시지 송출 <2024-04-07>
        enable = false,
      },

      hover = {
        open_cmd = "!" .. utils.get_browser_cmd(),
      },
      symbol_in_winbar = {
        -- alternatives https://github.com/utilyre/barbecue.nvim
        -- Breadcrumbs
        enable = not utils.is_plugin("lualine.nvim"),
        delay = 500, -- default: 300
      },
      diagnostic = {
        extend_relatedInformation = true,
        exec_action = map_keyword.execute,
      },
      finder = {
        -- methods = {},
        keys = {
          -- shuttle = "[w",
          -- toggle_or_open = "o",
          vsplit = map_keyword.vsplit,
          split = map_keyword.split,
          tabe = map_keyword.tab,
          -- tabnew = "r",
          -- quit = "q",
          -- close = "<C-c>k",
        },
      },

      -- require(lspsaga.symbol.winbar).get_bar()
      definition = {
        width = 0.6,
        height = 0.5,
        save_pos = false,
        keys = {
          edit = string.format("<C-c>%s", map_keyword.current),
          tabe = string.format("<C-c>%s", map_keyword.tab),
          vsplit = string.format("<C-c>%s", map_keyword.vsplit),
          split = string.format("<C-c>%s", map_keyword.split),
          -- quit = "q",
          -- close = "<C-c>k",
        },
      },
    }

    if require("utils").enable_icon then
      ret.ui = {
        border = "rounded",
        devicons = true,
        expand = "", -- nf-cod-expand_all
        collapse = "", -- nf-cod-collapse_all
        code_action = require("val").icons.signs.code_action,
        actionfix = " ", -- nf-cod-lightbulb_autofix
        imp_sign = "", -- nf-cod-wand
      }
    else
      ret.ui = {
        devicons = false,
        code_action = "!",
        actionfix = "!F",
        imp_sign = "I",
      }
    end
    return ret
  end,
  cmd = {
    "Lspsaga",
  },
  ---@type fun(LazyPlugin, keys: LazyKeysSpec[]): nil
  keys = function(_, keys)
    local val = require("val")
    local map_keyword = val.map_keyword
    local prefix = val.prefix

    vim.api.nvim_create_autocmd("LspAttach", {
      callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)

        local keymap_opts = { buffer = args.buf }
        local mappings = {
          ["textDocument/definition"] = {
            lhs = prefix.peek .. "d",
            rhs = "<cmd>Lspsaga peek_definition<CR>",
            desc = "peek-definition (lspsaga)",
          },
          ["textDocument/typeDefinition"] = {
            lhs = prefix.peek .. "p",
            rhs = "<cmd>Lspsaga peek_type_definition<CR>",
            desc = "peek-type-definition (lspsaga)",
          },
          ["textDocument/publishDiagnostic"] = {
            {
              -- overrides neovim's default keymap
              lhs = "[d",
              rhs = function()
                require("lspsaga.diagnostic"):goto_prev()
              end,
              desc = "prev-diagnostic",
            },
            {
              -- overrides neovim's default keymap
              lhs = "]d",
              rhs = function()
                require("lspsaga.diagnostic"):goto_next()
              end,
              desc = "next-diagnostic",
            },
            {
              lhs = "[r",
              rhs = function()
                require("lspsaga.diagnostic"):goto_prev({
                  severity = vim.diagnostic.severity["ERROR"],
                })
              end,
              desc = "prev-diagnostic-error",
            },
            {
              lhs = "]r",
              rhs = function()
                require("lspsaga.diagnostic"):goto_next({
                  severity = vim.diagnostic.severity["ERROR"],
                })
              end,
              desc = "next-diagnostic-error",
            },
            {
              lhs = "[w",
              rhs = function()
                require("lspsaga.diagnostic"):goto_prev({
                  severity = vim.diagnostic.severity["WARN"],
                })
              end,
              desc = "prev-diagnostic-warn",
            },
            {
              lhs = "]w",
              rhs = function()
                require("lspsaga.diagnostic"):goto_next({
                  severity = vim.diagnostic.severity["WARN"],
                })
              end,
              desc = "next-diagnostic-warn",
            },
          },
        }
        for method, specs in pairs(mappings) do
          if client.supports_method(method) then
            for _, spec in ipairs(specs.rhs and { specs } or specs) do
              vim.keymap.set(
                spec.mode and spec.mode or "n",
                spec.lhs,
                spec.rhs,
                vim.tbl_extend("error", keymap_opts, { desc = spec.desc })
              )
            end
          end
        end

        local mappings2 = {
          {
            methods = {
              "textDocument/implementation",
              "textDocument/references",
            },
            specs = {
              {
                -- print references and implementation in popup window
                lhs = string.format(
                  "%s%s%s",
                  prefix.buffer,
                  map_keyword.lsp,
                  "f"
                ),
                rhs = "<cmd>Lspsaga finder<CR>",
                desc = "lspsaga-finder",
              },
            },
          },
        }
        local check_methods = function(methods)
          for _, method in ipairs(methods) do
            if client.supports_method(method) then
              return true
            end
          end
          return false
        end

        for _, mapping in ipairs(mappings2) do
          if check_methods(mapping.methods) then
            for _, spec in ipairs(mapping.specs) do
              vim.keymap.set(
                spec.mode and spec.mode or "n",
                spec.lhs,
                spec.rhs,
                vim.tbl_extend("error", keymap_opts, { desc = spec.desc })
              )
            end
          end
        end
      end,
    })
  end,
  config = function(_, opts)
    require("lspsaga").setup(opts)

    -- overrides neovim's default functions
    vim.lsp.buf.hover = function()
      vim.api.nvim_command("Lspsaga hover_doc")
    end
    vim.lsp.buf.rename = function()
      vim.api.nvim_command("Lspsaga rename")
    end
    vim.lsp.buf.code_action = function()
      vim.api.nvim_command("Lspsaga code_action")
    end
    vim.lsp.buf.definition = function()
      vim.api.nvim_command("Lspsaga goto_definition")
    end
    vim.lsp.buf.incoming_calls = function()
      vim.api.nvim_command("Lspsaga incoming_calls")
    end
    vim.lsp.buf.outgoing_calls = function()
      vim.api.nvim_command("Lspsaga outgoing_calls")
    end
    vim.lsp.buf.goto_type_definition = function()
      vim.api.nvim_command("Lspsaga goto_type_definition")
    end

    -- 아래 방식으로 작동 안됨.
    -- local lspsaga_diagnostic = require("lspsaga.diagnostic")
    -- vim.diagnostic.goto_prev = function(...)
    --   lspsaga_diagnostic:goto_prev(...)
    -- end
    -- vim.diagnostic.goto_next = function(...)
    --   local args = { ... }
    --   lspsaga_diagnostic:goto_next({
    --     severity = args[1].severity,
    --   })
    -- end
  end,
  specs = {
    {
      [1] = "nvim-lualine/lualine.nvim",
      optional = true,
      opts = function(_, opts)
        -- :h lualine-Custom-components
        local modules = require("lualine_require").lazy_require({
          lspsaga = "lspsaga.symbol.winbar",
        })

        local disabled_buftypes = {
          "picker",
          "prompt",
          "nofile",
          "nowrite",
          "quickfix",
          "terminal",
        }

        local component = {
          [1] = modules.lspsaga.get_bar,
          cond = function()
            return not vim.tbl_contains(disabled_buftypes, vim.bo.buftype)
          end,
          fmt = function(str)
            -- NOTE: nil 이 아닌  "nil" 이거 오타 아님. <2024-04-05>
            return str == "nil" and "" or str
          end,
        }

        table.insert(opts.tabline.lualine_a, component)
      end,
    },
  },
}

return M
