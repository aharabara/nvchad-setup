require "nvchad.options"

-- add yours here!

-- local o = vim.o
-- o.cursorlineopt ='both' -- to enable cursorline!
vim.o.shiftwidth = 4
vim.o.tabstop = 4
vim.o.softtabstop = 4

-- Enable folding
vim.o.foldmethod = 'expr'
vim.o.foldlevelstart = 99  -- Start with all folds open

-- Optionally, you can set the fold column width
vim.o.foldcolumn = '1'

-- vim.opt.foldmethod = 'syntax'
vim.opt.foldenable = true
vim.o.foldexpr = 'nvim_treesitter#foldexpr()'

-- vim.api.nvim_exec([[
-- augroup MarkdownFolding
--   autocmd!
--   autocmd Syntax markdown syntax region TodoDone start='^- \[x\]' end='$' fold
-- augroup END
-- ]], false)
