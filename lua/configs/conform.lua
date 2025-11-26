local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    php = { "php" },
    css = { "prettier" },
    typescript = { "prettier" },
    typescriptreact = { "prettier" },
    javascript = { "prettier" },
    javascriptreact = { "prettier" },
    -- yaml = { "yamlfmt" },
  },
  format_on_save = {
    lsp_fallback = true,
    async = true,
    timeout_ms = 1000,
  },
  notify_on_error = true,
  formatters = {
    php = {
      command = "php-cs-fixer",
      args = {
        "fix",
        "$FILENAME",
        -- "--config=/your/path/to/config/file/[filename].php",
        "--allow-risky=yes", -- if you have risky stuff in config, if not you dont need it.
      },
      stdin = false,
    },
  },

  -- format_on_save = {
  --   -- These options will be passed to conform.format()
  --   timeout_ms = 500,
  --   lsp_fallback = true,
  -- },
}

return options
