return {
	{
		'sainnhe/gruvbox-material',
		config = function ()
			vim.g.gruvbox_material_backgrounk = 'hard'
			vim.g.gruvbox_material_better_performance = 1
			vim.g.gruvbox_material_transparent_background = 0
			vim.g.gruvbox_material_dim_inactive_windows = 1
			vim.g.gruvbox_material_ui_contrast = 'high'
			vim.g.gruvbox_material_show_eob = 0
			vim.g.gruvbox_material_float_style = 'dim'
			vim.cmd([[colorscheme gruvbox-material]])
			vim.cmd('hi TelescopeBorder guifg=#e78a4e guibg=#282828')
		end
	},

}
