---@meta

---@class LspSpec
---@field setup_lspconfig? fun(lspconfig: table, opts: LspconfigSetupOptsSpec): nil
---@field get_null_ls_sources? fun(null_ls: table, null_ls_utils: table): table[]
---@field get_conform_opts? fun(): table
