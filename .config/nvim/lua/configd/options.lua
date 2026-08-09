-- Line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Search behavior
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = false

-- Tabs and indentation
vim.opt.expandtab = true
vim.opt.shiftwidth = 8
vim.opt.tabstop = 8
vim.opt.smartindent = true

-- UI and behavior
vim.opt.termguicolors = true
vim.opt.cursorline = true
vim.opt.signcolumn = "yes"
vim.opt.mouse = ""
vim.opt.wrap = false
vim.opt.scrolloff = 8

-- Backups and performance
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undofile = true
vim.opt.undodir = vim.fn.expand("~/.local/state/nvim/undo//")
vim.opt.updatetime = 200

-- Split behavior
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Clipboard integrations
vim.opt.clipboard = "unnamedplus"

-- Invisible characters and whitespace markers
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- Code folding
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99

-- Completion menu behavior
vim.opt.completeopt = { "menu", "menuone", "noselect" }
vim.opt.pumheight = 5

-- Command line
vim.opt.showmode = true
vim.opt.shortmess:append("c")

-- Virtual text
vim.opt.breakindent = true
vim.opt.colorcolumn = "100"
