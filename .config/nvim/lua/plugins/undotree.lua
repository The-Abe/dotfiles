return {
	{
		"mbbill/undotree",
		config = function()
			vim.g.undotree_WindowLayout = 4
			vim.g.undotree_SplitWidth = 40
			vim.g.undotree_SplitMinwidth = 40
			vim.g.undotree_DiffpanelHeight = 10
			--vim.g.undotree_HelpLine = 0
			--vim.g.undotree_SetFocusWhenToggle = 1
			--vim.g.undotree_ShortIndicators = 1
			--vim.g.undotree_SignColumnWidth = 2
		end
	}, -- Undo tree display
}
