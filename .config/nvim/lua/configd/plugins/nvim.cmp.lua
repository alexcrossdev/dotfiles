return {
	"hrsh7th/nvim-cmp",
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		"L3MON4D3/LuaSnip",
	},
	config = function()
		local cmp = require("cmp")
		cmp.setup({
			snippet = {
				expand = function(args)
					require("luasnip").lsp_expand(args.body)
				end,
			},
			mapping = cmp.mapping.preset.insert({
				["<C-Space>"] = cmp.mapping.complete(),

				["<CR>"] = cmp.mapping.confirm({
					behavior = cmp.ConfirmBehavior.Replace,
					select = true
				}),

				["<Tab>"] = cmp.mapping(function(fallback)
					-- Safely pull luasnip directly from runtime to avoid global nil scoping errors
					local ls = require("luasnip")

					if cmp.visible() then
						cmp.select_next_item()
					elseif ls.expand_or_jumpable() then
						ls.expand_or_jump()
					else
						fallback()
					end
				end, { "i", "s" }),

				["<S-Tab>"] = cmp.mapping(function(fallback)
					local ls = require("luasnip")

					if cmp.visible() then
						cmp.select_prev_item()
					elseif ls.jumpable(-1) then
						ls.jump(-1)
					else
						fallback()
					end
				end, { "i", "s" }),
			}),
			sources = cmp.config.sources({
				{ name = "nvim_lsp" },
			}),
		})
	end,
}
