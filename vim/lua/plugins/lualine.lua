return {
	{
		-- Status line
		"nvim-lualine/lualine.nvim",
		opts = {
			options = {
				icons_enabled = true,
				theme = "tokyonight",
				component_separators = "|",
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
				lualine_c = { "buffers" },
			},
			inactive_winbar = {
				lualine_c = { "buffers" },
			},
			extensions = { "quickfix", "fugitive", "fzf", "lazy", "man" },
		},
	},
}
