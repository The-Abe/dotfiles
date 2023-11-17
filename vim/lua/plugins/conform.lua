-- Formatting
return {
	{
		"stevearc/conform.nvim",
		opts = {},
		config = function()
			require("conform").setup({
				formatters_by_ft = {
					ruby = { "rubyfmt" },
					lua = { "stylua" },
					erb = { "erb-lint" },
					markdown = { "prettier" },
					html = { "prettier" },
					css = { "prettier" },
					go = { "gofmt" },
					rust = { "rustfmt" },
					sh = { "shfmt" },
					sql = { "sqlfmt" },
					yaml = { "yamlfix" },
				},
			})
			vim.keymap.set("n", "<leader>lf", ":lua require('conform').format()<cr>", { desc = "Format Conform" })
		end
	},
}
