-- Mapleader
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local map = vim.keymap.set

-- Control
map("i", "jj", "<Esc>", { desc = "Exit insert mode" })
map({"n", "x"}, "<leader>ww", vim.cmd.write, { desc = "Write file" })
map({"n", "x"}, "<leader>qq", vim.cmd.quit, { desc = "Quit file" })
map({"n", "x"}, "<leader>xx", vim.cmd.wq, { desc = "Write and quit file" })

-- Navigation
local modes = { "n", "i", "v" }
for _, mode in ipairs(modes) do
    map(mode, "<Up>", "<Nop>", { silent = true })
    map(mode, "<Down>", "<Nop>", { silent = true })
    map(mode, "<Left>", "<Nop>", { silent = true })
    map(mode, "<Right>", "<Nop>", { silent = true })
    map(mode, "<BS>", "<Nop>", { silent = true })
    map(mode, "<Del>", "<Nop>", { silent = true })
end

map("n", "<C-h>", "<C-w>h")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-l>", "<C-w>l")

map("n", "<leader>sh", ":split<cr>")
map("n", "<leader>sv", ":vsplit<cr>")

-- Search and move
map("n", "<leader>pv", vim.cmd.Ex, { desc = "Open Netrw" })

-- Man
map("n", "<leader>mp", ":vert Man", { desc = "Man buffer" })
