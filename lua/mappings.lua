require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- Custom mappings
map("n", "<leader>.", "<cmd>:HopWord<CR>", { desc = "Hop through words" })
map("n", "<leader>,", "<cmd>:HopNodes<CR>", { desc = "Hop through treesitter nodes." })
map("n", "<leader>4", "<cmd>terminal<CR>", { desc = "Open Terminal" })
map("n", "<leader>5", "<cmd>LazyDocker<CR>", { desc = "Open LazyDocker" })
map("n", "<leader>9", "<cmd>LazyGit<CR>", { desc = "Open LazyGit" })
map("n", "<leader>0", "<cmd>Telescope projects<CR>", { desc = "List projects" })

map("n", "<leader>tl", function()
    require("custom.aws-plugin").show_tasks()
end, { desc = "AWS action" })


map("n", "<leader>te", function()
    require("custom.aws-plugin").execute_task()
end, { desc = "AWS action" })

-- map("n", "<leader>fmm", function() require("conform").format() end, { desc = "Hop through words" })
map("n", "<leader><enter>", function()
    require("actions-preview").code_actions()
end, { desc = "LSP code action" })

-- map("t", "<leader>h", function()
--     require("nvchad.term").toggle {pos = "sp", id = "default"}
-- end, { desc = "Toggle horizontal term" })

map("v", ">", ">gv", { desc = "Indent" })
map("v", "<", "<gv", { desc = "Indent" })

map("n", "<leader>1", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle nvimtree" })
map("n", "<leader>e", "<cmd>NvimTreeFocus<CR>", { desc = "Focus nvimtree" })

map("n", "<leader><leader>", "<cmd>Telescope find_files<CR>", { desc = "Search through last used files." })
-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
--

