local create_cmd = vim.api.nvim_create_autocmd
local map = vim.keymap.set

-- Yank autocommands
create_cmd("TextYankPost", {
        callback = function()
                vim.highlight.on_yank({
                        higroup = "IncSearch",
                        timeout = 200,
                })
        end,
})

-- Lsp
create_cmd("LspAttach", {
	callback = function(args)
		local tele = require("telescope.builtin")
		local opts = { buffer = args.buf }

		map("n", "gd<CR>", tele.lsp_definitions, opts)
		map("n", "gr", tele.lsp_references, opts)
		map("n", "gi", tele.lsp_implementations, opts)
		map("n", "<leader>ds", tele.lsp_document_symbols, opts)
		map("n", "<leader>ws", tele.lsp_dynamic_workspace_symbols, opts)

		map("n", "K", vim.lsp.buf.hover, opts)
          	map("n", "<leader>rn", vim.lsp.buf.rename, opts)
          	map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
	end,
})
