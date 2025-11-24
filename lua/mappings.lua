require "nvchad.mappings"
local neotest = require("neotest")
-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- Custom mappings
map("n", "<leader>.", "<cmd>:HopWord<CR>", { desc = "Hop through words" })
map("n", "<leader>,", "<cmd>:HopNodes<CR>", { desc = "Hop through treesitter nodes." })

vim.keymap.set('n', '<leader>1', function()
   vim.cmd((vim.bo.filetype == 'oil') and 'bd' or 'Oil')
end)
-- map("n", "<leader>1", "<CMD>Oil<CR>", { desc = "Open parent directory" })
-- map("n", "<leader>1x", function() require("oil").close() end, { desc = "Open parent directory" })
map("n", "<leader>4", "<cmd>terminal<CR>", { desc = "Open Terminal" })
map("n", "<leader>5", "<cmd>LazyDocker<CR>", { desc = "Open LazyDocker" })
map("n", "<leader>9", "<cmd>LazyGit<CR>", { desc = "Open LazyGit" })
map("n", "<leader>0", "<cmd>Telescope projects<CR>", { desc = "List projects" })

map("n", "<A-Up>", ":m .-2<CR>")
map("n", "<A-Down>", ":m .+1<CR>")

map("n", "<leader>te", neotest.run.run)
map("n", "<leader>tf", function()
    neotest.run.run(vim.fn.expand("%"));
end)

-- map("n", "<leader>tl", function()
--     require("custom.aws-plugin").show_tasks()
-- end, { desc = "AWS action" })
--
--
-- map("n", "<leader>te", function()
--     require("custom.aws-plugin").execute_task()
-- end, { desc = "AWS action" })

map("n", "<leader>fm", function() require("conform").format() end, { desc = "Format document" })
map("n", "<leader>ca", function()
    require("actions-preview").code_actions()
end, { desc = "LSP code action" })

-- map("t", "<leader>h", function()
--     require("nvchad.term").toggle {pos = "sp", id = "default"}
-- end, { desc = "Toggle horizontal term" })

map("v", ">", ">gv", { desc = "Indent left" })
map("v", "<", "<gv", { desc = "Indent righ" })
-- map("n", "<S->>", ">gv", { desc = "Indent left" })
-- map("n", "<S-<>", "<gv", { desc = "Indent right" })
map("n", "me", "<cmd>mo$g;<CR>g;", { desc = "Move line to the end of file" })
map("n", "mpe", "dd}Pg;g;", { desc = "Move line to the end of file" })
map("n", "mps", "dd{jpg;g;", { desc = "Move line to the end of file" })

-- map("n", "<leader>1", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle nvimtree" })
map("n", "<leader>e", "<cmd>NvimTreeFocus<CR>", { desc = "Focus nvimtree" })

map("n", "<leader><leader>", "<cmd>Telescope find_files<CR>", { desc = "Search through last used files." })
-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
--

