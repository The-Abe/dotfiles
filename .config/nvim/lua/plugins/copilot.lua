return {
	{
		-- Copilot
		"zbirenbaum/copilot.lua",
		config = function()
			require("copilot").setup({
				filetypes = {
					markdown = true,
					yaml = false,
				},
				suggestion = {
					enabled = false,
				},
				panel = {
					enabled = false,
				},
			})
		end,
	},
	{
		-- Copilot completion
		"zbirenbaum/copilot-cmp",
		config = function()
			require("copilot_cmp").setup()
		end,
	},
}
