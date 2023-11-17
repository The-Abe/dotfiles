-- Highlight on yank
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank()
	end,
	group = highlight_group,
	pattern = "*",
})

-- Close temp windows on "q"
vim.api.nvim_create_autocmd({ "FileType" }, {
	pattern = { "qf", "help", "man", "lspinfo" },
	callback = function()
		vim.api.nvim_buf_set_keymap(0, "n", "q", "<cmd>q!<cr>", { noremap = true, silent = true })
		vim.cmd([[
      set nobuflisted
      ]])
	end,
})

-- Open certain windows to the right
vim.api.nvim_create_autocmd({ "FileType" }, {
	pattern = { "help", "man" },
	callback = function()
		vim.cmd([[wincmd L]])
	end,
})

-- Auto write markdown files on exiting insert mode
-- Also replace some characters
vim.api.nvim_create_autocmd({ "InsertLeave" }, {
	pattern = { "*.md" },
	callback = function()
		vim.cmd([[ %s/–/-/ge ]])
		vim.cmd([[ %s/’/'/ge ]])
		vim.cmd([[ %s/“/"/ge ]])
		vim.cmd([[ %s/”/"/ge ]])
		vim.cmd([[write]])
	end,
})

-- Trailing whitespace and create directory structure on save file
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
	pattern = { "*" },
	callback = function()
		vim.cmd([[:%s/\s\+$//e]])
		-- Don't create directory structure for scp files
		if vim.fn.expand("%:h") ~= "^scp://" then
			return
		end
		if vim.fn.isdirectory(vim.fn.expand("%:h")) == 0 then
			vim.fn.mkdir(vim.fn.expand("%:h"))
		end
	end,
})

-- Open quickfix window on populate
vim.api.nvim_create_autocmd({ "QuickFixCmdPost" }, {
	callback = function()
		vim.cmd([[copen]])
	end,
})

-- Reopen last position on file open
vim.api.nvim_create_autocmd({ "BufReadPost" }, {
	callback = function()
		vim.cmd([[normal! g`"]])
	end,
})

-- Work related strings that I always want highlighted
vim.api.nvim_create_autocmd({ "BufReadPost" }, {
	callback = function()
		vim.cmd([[ syntax match Kayako '\v<[A-Z]{3}-\d{3}-\d{5}>' containedin=mdComplete,mdProject ]])
		vim.cmd([[ syntax match Change '\v<CH\d+>' containedin=mdComplete,mdProject ]])
		vim.cmd([[ hi link Change String ]])
		vim.cmd([[ hi link Kayako String ]])
	end,
})
