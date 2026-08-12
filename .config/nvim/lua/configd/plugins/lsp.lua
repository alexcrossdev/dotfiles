return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"mason-org/mason.nvim",
		"mason-org/mason-lspconfig.nvim",
		"hrsh7th/cmp-nvim-lsp",
	},
	config = function()
		require("mason").setup({ 
			ui = { register_user_commands = false } 
		})

		require("mason-lspconfig").setup({ 
			ensure_installed = { "vtsls", "lua_ls" } 
		})

		local capabilities = require("cmp_nvim_lsp").default_capabilities()

		vim.lsp.config("*", {
			capabilities = capabilities,
		})

		vim.lsp.enable({ "vtsls", "lua_ls" })

		vim.api.nvim_create_autocmd("LspAttach", {
			callback = function(args)
				local tele = require("telescope.builtin")
				local opts = { buffer = args.buf }

				vim.keymap.set("n", "gd", tele.lsp_definitions, opts)
				vim.keymap.set("n", "gr", tele.lsp_references, opts)
				vim.keymap.set("n", "gi", tele.lsp_implementations, opts)
				vim.keymap.set("n", "<leader>ds", tele.lsp_document_symbols, opts)
				vim.keymap.set("n", "<leader>ws", tele.lsp_dynamic_workspace_symbols, opts)

				vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
				vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
				vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
			end,
		})
	end,
}
