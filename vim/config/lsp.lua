require("nvim-lsp-installer").setup {}
vim.o.completeopt = "menuone,noinsert,noselect"
local nvim_lsp = require('lspconfig')

require'nvim-treesitter.configs'.setup {
	auto_install = true,
	highlight = {
		enable = true
	},
}

local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

vim.o.updatetime = 250

local opts = { noremap=true, silent=true }
vim.keymap.set('n', '[d', "<cmd>lua vim.diagnostic.goto_prev()<CR>zz", opts)
vim.keymap.set('n', ']d', "<cmd>lua vim.diagnostic.goto_next()<CR>zz", opts)
vim.keymap.set('n', '<c-q>', vim.diagnostic.setloclist, opts)

local on_attach = function(client, bufnr)
	local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
	local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

	vim.api.nvim_create_autocmd("CursorHold", {
			buffer = bufnr,
			callback = function()
				local opts = {
					focusable = false,
					close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
					border = 'none',
					source = 'always',
					prefix = ' ',
					scope = 'cursor',
				}
				vim.diagnostic.open_float(nil, opts)
			end
		})

	buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')
	buf_set_option('formatexpr', 'v:lua.vim.lsp.formatexpr()')

	vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
	vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
	vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
	vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
	vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
	vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, bufopts)
	vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
	vim.keymap.set('n', '<leader>wl', function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, bufopts)
vim.keymap.set('n', 'gt', vim.lsp.buf.type_definition, bufopts)
vim.keymap.set('n', '<leader>lr', vim.lsp.buf.rename, bufopts)
vim.keymap.set('n', 'ga', vim.lsp.buf.code_action, bufopts)
vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)

-- Set some keybinds conditional on server capabilities
if client.server_capabilities.documentFormattingProvider then
	buf_set_keymap("n", "<leader>f", "<cmd>lua vim.lsp.buf.format({async = true})<CR>", opts)
elseif client.server_capabilities.documentRangeFormattingProvider then
	buf_set_keymap("n", "<leader>f", "<cmd>lua vim.lsp.buf.format({async = true})<CR>", opts)
end
end

local capabilities = require('cmp_nvim_lsp').default_capabilities()
local servers = {'pyright', 'gopls', 'rust_analyzer', 'solargraph', 'bashls', 'yamlls', 'sumneko_lua'}
for _, lsp in ipairs(servers) do
	nvim_lsp[lsp].setup {
		on_attach = on_attach,
		capabilities = capabilities,
	}
end

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
	vim.lsp.diagnostic.on_publish_diagnostics,
	{
		virtual_text = false,
		signs = true,
		update_in_insert = false,
		underline = true,
	}
	)
