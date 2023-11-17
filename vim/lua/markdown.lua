-- Text wrapping on markdown
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
function MdHeaderDown()
	if string.match(vim.api.nvim_get_current_line(), "^#") ~= nil then
		vim.cmd([[ s/^#// ]])
	else
		vim.cmd("normal <<")
	end
end
function MdHeaderUp()
	if string.match(vim.api.nvim_get_current_line(), "^#") ~= nil then
		vim.cmd([[ s/^#/##/ ]])
	else
		vim.cmd("normal >>")
	end
end
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
		vim.api.nvim_buf_set_keymap(
			0,
			"n",
			"<C-Space>",
			"<cmd>lua Toggle_todo()<cr>",
			{ noremap = true, silent = true, desc = "Toggle Todo Item" }
		)
		vim.api.nvim_buf_set_keymap(
			0,
			"n",
			"o",
			"<cmd>lua NewListLine()<cr>",
			{ noremap = true, silent = true, desc = "Create a new line in markdown and consider lists." }
		)
		vim.api.nvim_buf_set_keymap(
			0,
			"n",
			"<tab>",
			"/[[\\zs.\\+\\]\\]<cr>",
			{ noremap = true, silent = true, desc = "Search for links" }
		)
		vim.api.nvim_buf_set_keymap(
			0,
			"n",
			"<s-tab>",
			"?[[\\zs.\\+\\]\\]<cr>",
			{ noremap = true, silent = true, desc = "Search for links" }
		)
		vim.api.nvim_buf_set_keymap(0, "n", "<a-l>", "<cmd>lua MdHeaderUp()<cr>", {})
		vim.api.nvim_buf_set_keymap(0, "n", "<a-h>", "<cmd>lua MdHeaderDown()<cr>", {})
		vim.cmd(
			[[syntax region mdLink matchgroup=mdBrackets start=/\[\[/ end=/\]\]/ concealends display oneline contains=mdAliasedLink]]
		)
		vim.cmd("syntax match mdAliasedLink '[^\\[\\]]\\+|' contained conceal")
		vim.cmd("syntax match mdTitleTail '\\zs#\\ze ' conceal cchar=§")
		vim.cmd("syntax match mdTitleStart '\\zs#\\ze#' conceal cchar=⋅")
		vim.cmd([[ hi mdLink guifg=CadetBlue2 gui=underline ]])
		vim.cmd([[ hi Conceal guifg=MediumPurple1 ]])
		vim.cmd([[ syntax match mdTime '\v<\d{2}:\d{2}>' containedin=mdComplete ]])
		vim.cmd([[ syntax match mdDate '\v<\d{4}-\d{2}-\d{2}>' containedin=mdComplete ]])
		vim.cmd([[ syntax match mdUrl '\v<https?://[^ ]*>' containedin=mdComplete ]])
		vim.cmd([[ syntax match mdComplete '\v- \[x\].*$' contains=Kayako,Change ]])
		vim.cmd([[ hi link mdComplete NonText ]])
		vim.cmd([[ hi link mdTime Number ]])
		vim.cmd([[ hi link mdDate Number ]])
		vim.cmd([[ hi link mdUrl Keyword ]])
		vim.cmd([[ hi link @lsp.type.enumMember.markdown Label ]])
		vim.api.nvim_buf_set_keymap(
			0,
			"n",
			"<leader>mn",
			":lua require'zk.commands'.get('ZkNew')({ title = vim.fn.input('Title: '), dir = 'Notes' })<cr>",
			{ desc = "New Note" }
		)
		vim.api.nvim_buf_set_keymap(
			0,
			"n",
			"<leader><space>",
			"<Cmd>ZkNotes { sort = { 'modified' } }<CR>",
			{ desc = "Search Notes" }
		)
		vim.api.nvim_buf_set_keymap(0, "n", "<leader>mt", "<Cmd>ZkTags<CR>", { desc = "Search Tags" })
		vim.api.nvim_buf_set_keymap(0, "n", "<leader>mb", "<Cmd>ZkBacklinks<CR>", { desc = "Search Backlinks" })
		vim.api.nvim_buf_set_keymap(
			0,
			"n",
			"<leader>mo",
			"<Cmd>ZkNotes { sort = { 'modified' }, orphan = true }<CR>",
			{ desc = "Search Orphans" }
		)
		vim.api.nvim_buf_set_keymap(
			0,
			"v",
			"<leader>mn",
			":'<,'>ZkNewFromTitleSelection<CR>",
			{ desc = "New Note From Selection" }
		)
		vim.api.nvim_buf_set_keymap(0, "n", "<cr>", "<Cmd>lua vim.lsp.buf.definition()<CR>", { desc = "Goto Note" })

		vim.o.list = false
	end,
})
