return {
	{
		-- Which key mapping preview
		"folke/which-key.nvim",
		event = "VeryLazy",
		init = function()
			require("which-key").register({
				["<leader>b"] = { name = "Buffer" },
				["<leader>c"] = { name = "Change" },
				["<leader>d"] = { name = "Diff" },
				["<leader>e"] = { name = "Edit" },
				["<leader>h"] = { name = "Harpoon" },
				["<leader>l"] = { name = "LSP" },
				["<leader>m"] = { name = "Markdown" },
				["<leader>r"] = { name = "Run" },
				["<leader>s"] = { name = "Search" },
				["<leader>t"] = { name = "Toggle" },
			})
		end,
		opts = {},
	}
}
