return {
	{
		-- Color scheme
		"folke/tokyonight.nvim",
		config = function()
			vim.cmd([[ colorscheme tokyonight ]])
		end,
		init = function()
			vim.o.termguicolors = true
		end
	},
}
