-- LSP Configuration & Plugins
return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			{ "williamboman/mason.nvim", config = true },
			"williamboman/mason-lspconfig.nvim",
			{ "j-hui/fidget.nvim", tag = "legacy", opts = {} },
			{ "folke/neodev.nvim", opts = {} }, -- For neovim development
		},
		config = function()
			local on_attach = function(_, bufnr)
				local nmap = function(keys, func, desc)
					vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
				end

				nmap("<leader>lr", vim.lsp.buf.rename, "Rename")
				nmap("<leader>la", vim.lsp.buf.code_action, "Action")
				nmap("<leader>lt", vim.lsp.buf.type_definition, "Type")

				nmap("gd", vim.lsp.buf.definition, "Definition")
				nmap("K", vim.lsp.buf.hover, "Hover Documentation")
				nmap("gK", vim.lsp.buf.signature_help, "Signature Documentation")
				nmap("gD", vim.lsp.buf.declaration, "Declaration")
				nmap("<leader>lF", vim.lsp.buf.format, "Format LSP")

				vim.api.nvim_create_autocmd({"CursorHold", "CursorHoldI"}, {
					buffer = bufnr,
					callback = function()
						local opts = {
							focusable = false,
							close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
							border = "none",
							source = "always",
							prefix = " ",
							scope = "cursor",
						}
						vim.diagnostic.open_float(nil, opts)
					end,
				})
			end

			local servers = {
				lua_ls = {
					Lua = {
						workspace = { checkThirdParty = false },
						telemetry = { enable = false },
					},
				},
			}

			vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
				virtual_text = false,
				signs = true,
				update_in_insert = false,
				virtual_lines = false,
				underline = true,
				severity_sort = true,
			})

			-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

			-- Ensure the servers above are installed
			local mason_lspconfig = require("mason-lspconfig")
			mason_lspconfig.setup({
				ensure_installed = vim.tbl_keys(servers),
			})
			mason_lspconfig.setup_handlers({
				function(server_name)
					require("lspconfig")[server_name].setup({
						capabilities = capabilities,
						on_attach = on_attach,
						settings = servers[server_name],
						filetypes = (servers[server_name] or {}).filetypes,
					})
				end,
			})
		end
	},
}
