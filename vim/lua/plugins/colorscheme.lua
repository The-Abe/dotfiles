return {
	{
		-- Color scheme
		"catppuccin/nvim",
		config = function()
			vim.cmd([[ colorscheme catppuccin-mocha ]])
		end,
		init = function()
			vim.o.termguicolors = true
		end
	},
}
