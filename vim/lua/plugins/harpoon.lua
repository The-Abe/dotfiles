return {
	{
		'ThePrimeagen/harpoon',
		after = 'telscope.nvim',
		config = function()
			require('harpoon').setup({
				global_settings = {
					save_on_toggle = true,
					save_on_change = true,
					excluded_filetypes = { "harpoon" },
				},
			})
			require('telescope').load_extension('harpoon')
			vim.keymap.set('n', '<leader>hx', require('harpoon.mark').add_file, { silent = true, desc = 'Add mark' })
			vim.keymap.set('n', '<leader>hn', require('harpoon.ui').nav_next, { silent = true, desc = 'Next' })
			vim.keymap.set('n', '<leader>hp', require('harpoon.ui').nav_prev, { silent = true, desc = 'Previous' })
			vim.keymap.set('n', "<leader>hh", ':Telescope harpoon marks<CR>', { silent = true, desc = 'Marks' })
		end,
	}
}
