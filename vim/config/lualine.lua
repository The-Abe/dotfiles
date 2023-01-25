local custom_molokai = require'lualine.themes.molokai'
custom_molokai.normal.b.bg = '#262626'
custom_molokai.normal.b.fg = '#eeeeee'
custom_molokai.normal.c.bg = '#4e4e4e'
custom_molokai.normal.c.fg = '#262626'
require('lualine').setup {
	options = {
		theme = custom_molokai,
    component_separators = { left = '', right = '' },
	},
	tabline = {
		lualine_a = {'buffers'}
	},
	sections = {
		lualine_x = {
      function()
        local ret, _ = (vim.bo.fenc or vim.go.enc):gsub("^utf%-8$", "")
        return ret
      end,
      function()
        local ret, _ = vim.bo.fileformat:gsub("^unix$", "")
        return ret
      end,
      'filetype',
		},
    lualine_b = {
      'branch',
      {
        'diff',
        colored = false
      },
			'diagnostics'
    },
    lualine_c = {
      {
        'filename',
        file_status = true,
        newfile_status = true,
        path = 1
      },
			'lsp_progress'
    }
  }
}
