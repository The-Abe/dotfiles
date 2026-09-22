vim.pack.add {
  { src = 'https://github.com/stevearc/oil.nvim', version = vim.version.range '*' },
}

require('oil').setup()

vim.keymap.set('n', '<leader>ff', '<CMD>Oil<CR>', { desc = 'Open parent directory' })
vim.keymap.set('n', '<leader>fh', '<CMD>Oil ~<CR>', { desc = 'Open home directory' })
vim.keymap.set('n', '<leader>fr', '<CMD>Oil /<CR>', { desc = 'Open root directory' })
