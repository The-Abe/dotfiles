return {
	{
		-- Color scheme
		"catppuccin/nvim",
		config = function()
			vim.cmd([[ colorscheme catppuccin-mocha ]])
			require("catppuccin").setup({
				flavour = "mocha", -- latte, frappe, macchiato, mocha
				background = { -- :h background
					light = "latte",
					dark = "mocha",
				},
				transparent_background = true, -- disables setting the background color.
				dim_inactive = {
					enabled = true, -- dims the background color of inactive window
					shade = "dark",
					percentage = 0.15, -- percentage of the shade to apply to the inactive window
				},
				no_italic = true, -- Force no italic
				no_bold = true, -- Force no bold
				no_underline = false, -- Force no underline
				integrations = {
					cmp = true,
					gitsigns = true,
					nvimtree = true,
					treesitter = true,
				},
				color_overrides = {
					all = {
						base = "#262626",
					},
				},
			})
		end,
		init = function()
			vim.o.termguicolors = true
		end
	},
}
