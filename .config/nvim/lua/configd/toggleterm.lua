local function toggleterm_shell()
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

require("toggleterm").setup({
	shell = toggleterm_shell(),
})
