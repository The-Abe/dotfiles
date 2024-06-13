return {
	"folke/trouble.nvim",
	config = function()
		require("trouble").setup {
			modes = {
			  diagnostics = {
					auto_open = true,
					auto_close = true,
				}
			}
		}
	end,
}
