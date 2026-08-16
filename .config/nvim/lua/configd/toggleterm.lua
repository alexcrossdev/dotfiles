local Terminal = require("toggleterm.terminal").Terminal

local function nix_shell()
	local cwd = vim.fn.getcwd()
	local flake = vim.fs.find("flake.nix", {
		path = cwd,
		upward = true,
		type = "file",
	})

	if #flake > 0 then
		return "nix develop --command " .. vim.o.shell
	end

	return vim.o.shell
end

local normal = Terminal:new({
	cmd = vim.o.shell,
	direction = "float",
	float_opts = {
		border = "rounded",
	},
})

local nix = Terminal:new({
	cmd = nix_shell(),
	direction = "float",
	float_opts = {
		border = "rounded",
	},
})

local map = vim.keymap.set

map({"n", "t"}, "<C-\\>", function()
	normal:toggle()
end)

map({"n", "t"}, "<C-S-\\>", function()
	nix:toggle()
end)
