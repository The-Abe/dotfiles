return {
	{
		-- Status line
		"nvim-lualine/lualine.nvim",
		opts = {
			options = {
				icons_enabled = true,
				theme = "tokyonight",
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
					"branch",
					"diff",
					{ "diagnostics", symbols = { error = "E", warn = "W", info = "I", hint = "H" } },
				},
				lualine_x = { "filetype" },
				lualine_y = {},
				lualine_z = {},
			},
			inactive_sections = {
				lualine_a = { "mode" },
				lualine_b = {},
				lualine_c = {
					"branch",
					"diff",
					{ "diagnostics", symbols = { error = "E", warn = "W", info = "I", hint = "H" } },
				},
				lualine_x = { "filetype" },
				lualine_y = {},
				lualine_z = {},
			},
			winbar = {
				lualine_c = {
					{
						'buffers',
						show_filename_only = false,
						hide_filename_extension = false,
						show_modified_status = true,
						filetype_names = {
							TelescopePrompt = 'Telescope',
							fzf = 'FZF',
						},
						use_mode_colors = true,
						buffers_color = {
							active = 'lualine_winbar_normal',
							inactive = 'CursorLineNr',
						},
						symbols = {
							modified = ' ●',
							alternate_file = '',
							directory =  '',
						},
					},
				},
			},
			inactive_winbar = {
				lualine_c = {
					{
						'buffers',
						show_filename_only = false,
						hide_filename_extension = false,
						show_modified_status = true,
						filetype_names = {
							TelescopePrompt = 'Telescope',
							fzf = 'FZF',
						},
						use_mode_colors = true,
						buffers_color = {
							active = 'lualine_winbar_normal',
							inactive = 'CursorLineNr',
						},
						symbols = {
							modified = ' ●',
							alternate_file = '',
							directory =  '',
						},
					},
				},
			},
			extensions = { "quickfix", "fugitive", "fzf", "lazy", "man" },
		},
	},
}
