return {
	"mfussenegger/nvim-lint",
	event = {
		"BufReadPre",
		"BufNewFile"
	},
	config = function()
		local lint = require("lint")
		lint.linters_by_ft = {
			markdown = { 'markdownlint' },
			yaml = { 'ansible_lint', 'yamllint' },
			ruby = { 'standardrb' },
			sh = { 'shellcheck' },
			json = { 'jsonlint' },
			go = { 'golangci-lint' },
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
