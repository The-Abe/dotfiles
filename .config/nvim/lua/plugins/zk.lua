-- Note taking
return {
	{
		"mickael-menu/zk-nvim",
		config = function()
			require("zk").setup({
				picker = "telescope",
				lsp = {
					config = {
						cmd = { "zk", "lsp" },
						name = "zk",
					},
				},
				auto_attach = {
					enabled = true,
					filetypes = { "markdown" },
				},
			})
		end,
	},
	{
    'MeanderingProgrammer/markdown.nvim',
    name = 'render-markdown',
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
    config = function()
        require('render-markdown').setup({})
    end,
	}
}
