return {
	{
		-- Which key mapping preview
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {
			preset = "modern",
			delay = 0,
		},
		keys = {
			{ "<leader>b", desc = "Buffer", icon = ""},
			{ "<leader>c", desc = "Change", icon = "" },
			{ "<leader>d", desc = "Diff", icon = "" },
			{ "<leader>e", desc = "Edit", icon = "" },
			{ "<leader>h", desc = "Harpoon", icon = "󱡅" },
			{ "<leader>l", desc = "LSP", icon = "󰛱" },
			{ "<leader>m", desc = "Markdown", icon = "" },
			{ "<leader>r", desc = "Run", icon = "" },
			{ "<leader>s", desc = "Search", icon = "" },
			{ "<leader>t", desc = "Toggle", icon = "" },
		}
	}
}
