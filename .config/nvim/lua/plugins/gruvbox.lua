return {
	{
		'sainnhe/gruvbox-material',
		config = function ()
			vim.g.gruvbox_material_backgrounk = 'soft'
			vim.g.gruvbox_material_foreground = 'material'
			vim.g.gruvbox_material_ui_contrast = 'high'
			vim.g.gruvbox_material_inlay_hints_background = 'dimmed'
			vim.g.gruvbox_material_diagnostic_text_highlight = 1
			vim.g.gruvbox_material_diagnostic_virtual_text = 'colored'
			vim.g.gruvbox_enable_bold = 1
			vim.g.gruvbox_enable_italic = 1
			vim.g.gruvbox_material_better_performance = 1
			vim.g.gruvbox_material_transparent_backgrounk = 0
			vim.g.gruvbox_material_dim_inactive_windows = 1
			vim.g.gruvbox_material_ui_contrast = 'high'
			vim.g.gruvbox_material_show_eob = 0
			vim.g.gruvbox_material_float_style = 'bright'
			vim.cmd([[colorscheme gruvbox-material]])
			vim.cmd('hi TelescopeBorder guifg=#e78a4e guibg=#282828')
		end
	},

}
