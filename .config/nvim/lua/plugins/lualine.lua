return {
	{
		-- Status line
		"nvim-lualine/lualine.nvim",
		opts = {
			options = {
				icons_enabled = true,
				theme = "auto",
				component_separators = "",
				section_separators = "",
				disabled_filetypes = {
					"NvimTree",
				},
			},
			sections = {
				lualine_a = { "mode" },
				lualine_b = {},
				lualine_c = {
					{
						'buffers',
						show_filename_only = false,
						hide_filename_extension = true,
						show_modified_status = true,
						filetype_names = {
							TelescopePrompt = 'Telescope',
							fzf = 'FZF',
						},
						use_mode_colors = true,
						buffers_color = {
							active = 'StatusLine',
							inactive = 'StatusLineNC',
						},
						symbols = {
							modified = ' ●',
							alternate_file = '',
							directory =  '',
						},
					},
				},
				lualine_x = {
					"branch",
					"diff",
					{ "diagnostics", symbols = { error = "E", warn = "W", info = "I", hint = "H" } },
				},
				lualine_y = { 'filetype' },
				lualine_z = { 'location' },
			},
			inactive_sections = {
				lualine_a = { "mode" },
				lualine_b = {},
				lualine_c = {
					{
						'buffers',
						show_filename_only = false,
						hide_filename_extension = true,
						show_modified_status = true,
						filetype_names = {
							TelescopePrompt = 'Telescope',
							fzf = 'FZF',
						},
						use_mode_colors = true,
						buffers_color = {
							active = 'StatusLine',
							inactive = 'StatusLineNC',
						},
						symbols = {
							modified = ' ●',
							alternate_file = '',
							directory =  '',
						},
					},
				},
				lualine_x = {},
				lualine_y = { 'filetype' },
				lualine_z = { 'location' },
			},
			extensions = { "quickfix", "fugitive", "fzf", "lazy", "man", "mason" },
		},
	},
}
