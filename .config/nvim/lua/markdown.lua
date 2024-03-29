-- Buffer local settings for markdown files

-- Convience function for setting buffer local keymaps
local bmap = function(mode, key, cmd, opts)
	vim.api.nvim_buf_set_keymap(0, mode, key, cmd, opts)
end

-- Toggle todo items and sort the list
-- Always saves on toggle
-- Adds a timestamp on completion
function Toggle_todo()
	if string.match(vim.api.nvim_get_current_line(), "- %[ %]") ~= nil then
		vim.cmd("s/- \\[ \\]/- [x] " .. vim.fn.strftime("%Y-%m-%d %H:%M") .. "/g")
	elseif string.match(vim.api.nvim_get_current_line(), "- %[x%]") ~= nil then
		vim.cmd([[ s/- \[x\] \d\+-\d\+-\d\+ \d\+:\d\+/- [ ]/ ]])
	elseif string.match(vim.api.nvim_get_current_line(), "^%s*- ") ~= nil then
		vim.cmd([[ s/- /- [ ] / ]])
	else
		vim.cmd("normal $^i- [ ] ")
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

-- Create a new line in markdown and consider lists
function NewListLine()
	if string.match(vim.api.nvim_get_current_line(), "^%s*- %[.%]") ~= nil then
		vim.api.nvim_feedkeys("o- [ ] ", "n", false)
	elseif string.match(vim.api.nvim_get_current_line(), "^%s*-") ~= nil then
		vim.api.nvim_feedkeys("o- ", "n", false)
	else
		vim.api.nvim_feedkeys("o", "n", false)
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
		bmap(
			"n",
			"o",
			"<cmd>lua NewListLine()<cr>",
			{ noremap = true, silent = true, desc = "Create a new line in markdown and consider lists." }
		)
		bmap("n", "<tab>", "/[[\\zs.\\+\\]\\]<cr>", { noremap = true, silent = true, desc = "Search for links" })
		bmap("n", "<s-tab>", "?[[\\zs.\\+\\]\\]<cr>", { noremap = true, silent = true, desc = "Search for links" })
		bmap("n", "<s-l>", "<cmd>lua MdHeaderUp()<cr>", {})
		bmap("n", "<s-h>", "<cmd>lua MdHeaderDown()<cr>", {})
		bmap(
			"n",
			"<leader>mn",
			":lua require'zk.commands'.get('ZkNew')({ title = vim.fn.input('Title: '), dir = 'Notes' })<cr>",
			{ desc = "New Note" }
		)
		bmap(
			"n",
			"<leader>mv",
			":lua require'zk.commands'.get('ZkNew')({ title = vim.fn.input('Vergadering: '), dir = 'Notes', template = '/home/abe/Obsidian/.zk/templates/vergadering.md'})<cr>",
			{ desc = "Vergadering Notulen" }
		)
		bmap("n", "<leader><space>", "<Cmd>ZkNotes { sort = { 'modified' } }<CR>", { desc = "Search Notes" })
		bmap("n", "<leader>mt", "<Cmd>ZkTags { sort = { 'note-count' } }<CR>", { desc = "Search Tags" })
		bmap("n", "<leader>mb", "<Cmd>ZkBacklinks<CR>", { desc = "Search Backlinks" })
		bmap(
			"n",
			"<leader>mo",
			"<Cmd>ZkNotes { sort = { 'modified' }, orphan = true }<CR>",
			{ desc = "Search Orphans" }
		)
		bmap("v", "<cr>", ":'<,'>ZkNewFromTitleSelection<CR>", { desc = "New Note From Selection" })
		bmap("n", "<cr>", "<Cmd>lua vim.lsp.buf.definition()<CR>", { desc = "Goto Note" })
		bmap("n", "<leader>mu", "<cmd>silent !$HOME/Obsidian/.bin/update<cr>", { desc = "Update notes", silent = true })
		bmap("n", "<leader>mr", '<cmd>silent !$HOME/Obsidian/.bin/md "%:p"<cr>', { desc = "Read", silent = true })
		bmap("n", "<leader>ms", "vip:'<,'>sort<cr>", { desc = "Sort list" })
		bmap("n", "<leader>mf", "vip:'<,'>Tabularize /|<cr>", { desc = "Format Table" })
		bmap(
			"n",
			"<leader>mw",
			'<cmd>silent !$HOME/Obsidian/.bin/convert_to_wiki "%:p"<cr>',
			{ desc = "Convert to Wiki", silent = true }
		)
		bmap(
			"n",
			"<leader>md",
			':silent ![ -d ".trash/%:.:h" ] || mkdir ".trash/%:.:h"; mv "%:." "$HOME/Obsidian/.trash/%:."<cr>:bd!<cr>',
			{ desc = "Delete To Trash", silent = true }
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
		vim.cmd("syntax match mdTitleTail '\\zs#\\ze ' conceal cchar=§")
		vim.cmd("syntax match mdTitleStart '\\zs#\\ze#' conceal cchar=⋅")
		vim.cmd([[ syntax match mdTodoTag '\v\@\S+' containedin=mdComplete contains=Change,Katako ]])
		vim.cmd([[ syntax match mdTime '\v<\d{2}:\d{2}>' containedin=mdComplete ]])
		vim.cmd([[ syntax match mdDate '\v<\d{4}-\d{2}-\d{2}>' containedin=mdComplete ]])
		vim.cmd([[ syntax match mdUrl '\v<https?://[^ ]*>' containedin=mdComplete ]])
		vim.cmd([[ syntax match mdComplete '\v- \[x\].*$' contains=Kayako,Change ]])
		vim.cmd([[ hi link mdLink Label ]])
		vim.cmd([[ hi link Conceal Number ]])
		vim.cmd([[ hi link mdComplete NonText ]])
		vim.cmd([[ hi link mdTime Number ]])
		vim.cmd([[ hi link mdDate Number ]])
		vim.cmd([[ hi link mdUrl Keyword ]])
		vim.cmd([[ hi link mdTodoTag Label ]])
		--vim.cmd([[ hi link @lsp.type.enumMember.markdown Macro ]])
		vim.cmd([[ hi! link markdownItalic TSType ]])
		vim.cmd([[ hi! link markdownBold MarkdownH3 ]])
		vim.cmd([[ hi! link @text.title.1 MarkdownH1 ]])
		vim.cmd([[ hi! link @text.title.2 MarkdownH2 ]])
		vim.cmd([[ hi! link @text.title.3 MarkdownH3 ]])
		vim.cmd([[ hi! link @text.title.4 MarkdownH4 ]])
		vim.cmd([[ hi! link @text.title.5 MarkdownH5 ]])
		vim.cmd([[ hi! link @text.title.6 MarkdownH6 ]])
	end,
})
