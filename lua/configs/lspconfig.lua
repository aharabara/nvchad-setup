-- EXAMPLE
local on_attach = require("nvchad.configs.lspconfig").on_attach
local on_init = require("nvchad.configs.lspconfig").on_init
local capabilities = require("nvchad.configs.lspconfig").capabilities

local lspconfig = require "lspconfig"
local servers = { "html", "cssls" }

-- if you just want default config for the servers then put them in a table
local servers = { "html", "cssls", "ts_ls", "clangd", "bashls", "marksman"}

-- lsps with default config
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    on_init = on_init,
    capabilities = capabilities,
  }
end

-- typescript
lspconfig.ts_ls.setup {
  on_attach = on_attach,
  on_init = on_init,
  capabilities = capabilities,
}

lspconfig.phpactor.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  init_options = {
    ["language_server_php_cs_fixer.enabled"] = true,
    ["language_server_php_cs_fixer.bin"] = "/usr/local/bin/php-cs-fixer",
    ["language_server_phpstan.enabled"] = false,
    ["language_server_psalm.enabled"] = false,
  },
}
