return {
	'christoomey/vim-tmux-navigator',
	config = function()
		vim.g.tmux_navigator_no_mappings = 1
		vim.keymap.set('n', '<a-h>', ':TmuxNavigateLeft<cr>')
		vim.keymap.set('n', '<a-j>', ':TmuxNavigateDown<cr>')
		vim.keymap.set('n', '<a-k>', ':TmuxNavigateUp<cr>')
		vim.keymap.set('n', '<a-l>', ':TmuxNavigateRight<cr>')
	end,
}
