return {
	{
		-- Color scheme
		"catppuccin/nvim",
		config = function()
			require("catppuccin").setup({
				flavour = "mocha", -- latte, frappe, macchiato, mocha
				background = { -- :h background
					light = "latte",
					dark = "mocha",
				},
				transparent_background = false, -- disables setting the background color.
				dim_inactive = {
					enabled = true, -- dims the background color of inactive window
				},
				no_italic = true,
				no_bold = false,
				no_underline = false,
				integrations = {
					cmp = true,
					gitsigns = true,
					nvimtree = true,
					treesitter = true,
					flash = true,
					harpoon = true,
					telescope = true,
					indent_blankline = {
						enabled = true,
						scope_color = "text",
					},
					markdown = true,
					native_lsp = {
						enabled = true,
					},
					treesitter_context = true,
					which_key = true
				},
				color_overrides = {
					all = {
						mantle = "#1c1c1c",
						base = "#262626",
					},
				},
			})
			vim.cmd([[ colorscheme catppuccin-mocha ]])
		end,
		init = function()
			vim.o.termguicolors = true
		end
	},
}
