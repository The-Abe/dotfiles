return {
	{
		-- Highlight, edit, and navigate code
		"nvim-treesitter/nvim-treesitter",
		dependencies = {
			"nvim-treesitter/nvim-treesitter-textobjects",
			"JoosepAlviste/nvim-ts-context-commentstring", -- Change comment string on TS context for embeded languages
			'nvim-treesitter/playground',
		},
		build = ":TSUpdate",
		config = function()
			-- Treesitter
			require("nvim-treesitter.configs").setup({
				endwise = {
					enable = true,
				},
				ignore_install = {},
				sync_install = true,
				modules = {},
				ensure_installed = { "lua" },
				auto_install = true,

				highlight = {
					enable = true,
					additional_vim_regex_highlighting = { "markdown" },
				},
				indent = { enable = true },
				incremental_selection = {
					enable = true,
					keymaps = {
						init_selection = "<c-space>",
						node_incremental = "<c-space>",
						scope_incremental = "<c-s>",
						node_decremental = "<M-space>",
					},
				},
				textobjects = {
					select = {
						enable = true,
						lookahead = true,
						keymaps = {
							["ab"] = { query = "@block.outer", desc = "around block" },
							["ib"] = { query = "@block.inner", desc = "inside block" },
							["ac"] = { query = "@class.outer", desc = "around class" },
							["ic"] = { query = "@class.inner", desc = "inside class" },
							["a?"] = { query = "@conditional.outer", desc = "around conditional" },
							["i?"] = { query = "@conditional.inner", desc = "inside conditional" },
							["af"] = { query = "@function.outer", desc = "around function " },
							["if"] = { query = "@function.inner", desc = "inside function " },
							["al"] = { query = "@loop.outer", desc = "around loop" },
							["il"] = { query = "@loop.inner", desc = "inside loop" },
							["aa"] = { query = "@parameter.outer", desc = "around argument" },
							["ia"] = { query = "@parameter.inner", desc = "inside argument" },
						},
					},
					move = {
						enable = true,
						set_jumps = true,
						goto_next_start = {
							["]b"] = { query = "@block.outer", desc = "Next block start" },
							["]f"] = { query = "@function.outer", desc = "Next function start" },
						},
						goto_next_end = {
							["]B"] = { query = "@block.outer", desc = "Next block end" },
							["]F"] = { query = "@function.outer", desc = "Next function end" },
						},
						goto_previous_start = {
							["[b"] = { query = "@block.outer", desc = "Previous block start" },
							["[f"] = { query = "@function.outer", desc = "Previous function start" },
						},
						goto_previous_end = {
							["[B"] = { query = "@block.outer", desc = "Previous block end" },
							["[F"] = { query = "@function.outer", desc = "Previous function end" },
						},
					},
				},
			})
			require('ts_context_commentstring').setup {}
			vim.g.skip_ts_context_commentstring_module = true
		end
	},
	{
		-- Show context of current cursor position in first line
		"nvim-treesitter/nvim-treesitter-context",
		enabled = true,
		opts = {
			max_lines = 5,
			mode = 'topline',
		},
	}
}
