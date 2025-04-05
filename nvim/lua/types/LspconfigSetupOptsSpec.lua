--- @meta

-- NOTE: `:help lspconfig-setup` <2024-02-02>
-- vim.lsp.start

--- @class LspconfigEachServerOptions
--- @field settings LspconfigSetupOptsSpec

--- @class LspconfigSetupOptsSpec
--- @field root_dir fun(filename: string, bufnr: number)
--- @field name string
--- @field filetypes string[]?
--- @field autostart boolean
--- @field single_file_support boolean?
--- @field on_new_config fun(new_config: table, new_root_dir: string)
--- @field capabilities table <string, string|table|boolean|function>
--- @field cmd string[]
--- @field handlers function[]
--- @field init_options table <string, string|table|boolean>
--- @field on_attach fun(client: number, bufnr: number)
--- @field settings table <string, string|table|boolean>
