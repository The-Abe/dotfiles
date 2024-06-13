return {
	"mfussenegger/nvim-lint",
	event = {
		"BufReadPre",
		"BufNewFile"
	},
	config = function()
		local lint = require("lint")
		lint.linters_by_ft = {
			markdown = { 'vale', },
			yaml = { 'ansible_lint', 'yamllint' },
			ruby = { 'standardrb' },
		}
		local lint_auggroup = vim.api.nvim_create_augroup('lint', { clear = true })
		vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
			group = lint_auggroup,
			callback = function()
				lint.try_lint()
			end,
		})
	end,
}
