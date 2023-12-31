return {
	{
		-- Fuzzy Finder (files, lsp, etc)
		"nvim-telescope/telescope.nvim",
		branch = "0.1.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make",
				cond = function()
					return vim.fn.executable("make") == 1
				end,
			},
		},
		config = function()
			-- Telescope config and binds
			require("telescope").setup({
				defaults = {
					mappings = {
						i = {
							["<C-u>"] = false,
							["<C-d>"] = false,
						},
					},
					border = {},
					borderchars = { " ", " ", " ", " ", " ", " ", " ", " " },
					layout_strategy = "horizontal",
					layout_config = {
						horizontal = {
							prompt_position = "bottom",
							preview_width = 0.5,
							results_width = 0.5,
						},
						width = 0.60,
						height = 0.60,
						preview_cutoff = 120,
					},
				},
				pickers = {
					lsp_references = { theme = "cursor" },
					lsp_implementations = { theme = "cursor" },
				},
			})
			-- Enable telescope fzf native, if installed
			pcall(require("telescope").load_extension, "fzf")
			pcall(require("telescope").load_extension, "zk")
			local map = vim.keymap.set

			map("n", "<leader>/", function()
				require("telescope.builtin").current_buffer_fuzzy_find({
					previewer = false,
				})
				end, { desc = "Find in buffer" })

			local tb = require("telescope.builtin")
			map("n", "<leader>?", tb.oldfiles, { desc = "Find Recent" })
			map("n", "<leader><space>", tb.find_files, { desc = "Find Files" })
			map("n", "<leader>sf", tb.find_files, { desc = "Files" })
			map("n", "<leader>sh", tb.help_tags, { desc = "Help" })
			map("n", "<leader>sw", tb.grep_string, { desc = "Current word" })
			map(
				"n",
				"<leader>sW",
				":lua require'telescope.builtin'.grep_string{search = \"<C-r><C-A>\"}<cr>",
				{ desc = "Current Word" }
			)
			map("n", "<leader>sg", tb.live_grep, { desc = "Grep" })
			map("n", "<leader>sd", tb.diagnostics, { desc = "Diagnostics" })
			map("n", "<leader>sr", tb.resume, { desc = "Resume" })
			map("n", "<leader>sm", tb.marks, { desc = "Marks" })
			map("n", "<leader>sb", tb.buffers, { desc = "Buffers" })
			map("n", "<leader>s<space>", tb.builtin, { desc = "Telescope Builtins" })
			map("n", "<leader>ss", tb.treesitter, { desc = "Symbols" })
			map("n", "<leader>:", tb.commands, { desc = "Commands" })
			map("n", "<M-x>", tb.commands, { desc = "Commands" })
			map("n", "<tab>", tb.buffers, { desc = "Buffers" })
			map("n", "<S-tab>", "<cmd>lua require'telescope.builtin'.oldfiles{only_cwd = true}<cr>", { desc = "Find Recent" })
			map(
				"n",
				"<leader>se",
				"<cmd>lua require'telescope.builtin'.symbols{ sources = {'emoji'} }<cr>",
				{ desc = "Emojis" }
			)
			map("n", "<leader>to", tb.vim_options, { desc = "Vim Options" })
			map("n", "<leader>ll", tb.lsp_document_symbols, { desc = "Symbols" })
			map("n", "<leader>lw", tb.lsp_dynamic_workspace_symbols, { desc = "Workspace Symbols" })
			map("n", "gr", tb.lsp_references, { desc = "References" })
			map("n", "gI", tb.lsp_implementations, { desc = "Implementation" })
		end
	},
	"nvim-telescope/telescope-symbols.nvim", -- Telescope emoticons
}

