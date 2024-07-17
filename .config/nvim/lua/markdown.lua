-- Buffer local settings for markdown files

-- Convience function for setting buffer local keymaps
local bmap = function(mode, key, cmd, opts)
	vim.api.nvim_buf_set_keymap(0, mode, key, cmd, opts)
end

-- Toggle todo items and sort the list
-- Always saves on toggle
-- Adds a timestamp on completion
function Toggle_todo()
	if string.match(vim.api.nvim_get_current_line(), "* %[ %]") ~= nil then
		vim.cmd("s/* \\[ \\]/* [x] " .. vim.fn.strftime("%Y-%m-%d %H:%M") .. "/g")
	elseif string.match(vim.api.nvim_get_current_line(), "* %[x%]") ~= nil then
		vim.cmd([[ s/* \[x\] \d\+-\d\+-\d\+ \d\+:\d\+/* [ ]/ ]])
	elseif string.match(vim.api.nvim_get_current_line(), "^%s*- ") ~= nil then
		vim.cmd([[ s/* /* [ ] / ]])
	else
		vim.cmd("normal $^i* [ ] ")
	end
	vim.cmd([[ write ]])
end

-- Move header down a level
function MdHeaderDown()
	if string.match(vim.api.nvim_get_current_line(), "^#") ~= nil then
		vim.cmd([[ s/^#// ]])
	else
		vim.cmd("normal 0")
	end
end

-- Move header up a level
function MdHeaderUp()
	if string.match(vim.api.nvim_get_current_line(), "^#") ~= nil then
		vim.cmd([[ s/^#/##/ ]])
	else
		vim.cmd("normal $")
	end
end

vim.api.nvim_create_autocmd({ "FileType" }, {
	pattern = { "markdown" },
	callback = function()
		vim.opt_local.textwidth = 80
		vim.o.list = false
		bmap(
			"n",
			"<C-Space>",
			"<cmd>lua Toggle_todo()<cr>",
			{ noremap = true, silent = true, desc = "Toggle Todo Item" }
		)
		bmap("n", "<tab>", "/[[\\zs.\\+\\]\\]<cr>", { noremap = true, silent = true, desc = "Search for links" })
		bmap("n", "<s-tab>", "?[[\\zs.\\+\\]\\]<cr>", { noremap = true, silent = true, desc = "Search for links" })
		bmap("n", "<s-l>", "<cmd>lua MdHeaderUp()<cr>", {})
		bmap("n", "<s-h>", "<cmd>lua MdHeaderDown()<cr>", {})
		bmap("n", "<leader>mu", "<cmd>silent !$HOME/Obsidian/.bin/update<cr>", { desc = "Update notes", silent = true })
		bmap("n", "<leader>mr", '<cmd>silent !$HOME/Obsidian/.bin/md "%:p"<cr>', { desc = "Read", silent = true })
		bmap("n", "<leader>ms", "vip:'<,'>sort<cr>", { desc = "Sort list" })
		bmap("n", "<leader>mf", "vip:'<,'>Tabularize /|<cr>", { desc = "Format Table" })
		bmap('i',
			'<C-Enter>',
			'<C-o>o* ',
			{ desc = "Insert list item" }
		)

		-- Syntax highlighting stuff. Mostly for todo items and some conceal stuff for cleaner display
		vim.cmd([[
			syntax region mdLink
			\ matchgroup=mdBrackets
			\ start=/\[\[/ end=/\]\]/
			\ concealends display oneline
			\ contains=mdAliasedLink
		]])
		vim.cmd("syntax match mdAliasedLink '[^\\[\\]]\\+|' contained conceal")
		vim.cmd([[ syntax match mdTodoTag '\v\@\S+' containedin=mdComplete contains=Change,Katako ]])
		vim.cmd([[ syntax match mdTime '\v<\d{2}:\d{2}>' containedin=mdComplete ]])
		vim.cmd([[ syntax match mdDate '\v<\d{4}-\d{2}-\d{2}>' containedin=mdComplete ]])
		vim.cmd([[ hi link mdTime Number ]])
		vim.cmd([[ hi link mdDate Number ]])
		vim.cmd([[ hi link mdTodoTag Label ]])
	end,
})
