return {
	{
		-- Which key mapping preview
		"folke/which-key.nvim",
		event = "VeryLazy",
		init = function()
			require("which-key").register({
				["<leader>s"] = { name = "Search" },
				["<leader>b"] = { name = "Buffer" },
				["<leader>t"] = { name = "Toggle" },
				["<leader>d"] = { name = "Diff" },
				["<leader>e"] = { name = "Edit" },
				["<leader>r"] = { name = "Run" },
				["<leader>g"] = { name = "Git" },
				["<leader>h"] = { name = "HG" },
				["<leader>l"] = { name = "LSP" },
				["<leader>c"] = { name = "Change" },
				["<leader>m"] = { name = "Markdown" },
			})
		end,
		opts = {},
	}
}
