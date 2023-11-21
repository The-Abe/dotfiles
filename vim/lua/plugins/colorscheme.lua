return {
	{
		-- Color scheme
		"folke/tokyonight.nvim",
		config = function()
			vim.cmd([[ colorscheme tokyonight-night ]])
			vim.cmd([[ hi Comment guifg=#bbbbbb ]])
		end,
		init = function()
			vim.o.termguicolors = true
		end
	},
}
