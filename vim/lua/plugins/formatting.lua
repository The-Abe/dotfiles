return {
	"alvan/vim-closetag", -- Auto close tags
	"RRethy/nvim-treesitter-endwise", -- Auto close "end" blocks
	"godlygeek/tabular", -- Align text by delimiter
	"tpope/vim-sleuth", -- Detect indentation
	{
		-- Autopairs with tabout
		"altermo/ultimate-autopair.nvim",
		event = { "InsertEnter" },
		branch = "v0.6",
		opts = {
			close = {
				map = "<A-'>",
				cmap = "<A-'>",
			},
			tabout = {
				enable = true,
				hopout = true,
			},
		},
	},
	{
		-- Vim surround alternative
		"kylechui/nvim-surround",
		opts = {
			surrounds = {
				["-"] = { -- ERB embeded Ruby
					add = { "<%- ", " -%>" },
					find = "<%%%-.-%-%%>",
					delete = "^(<%%%- )().-( %-%%>)()",
				},
				["="] = { -- ERB output
					add = { "<%= ", " -%>" },
					find = "<%%=.-%-%%>",
					delete = "^(<%%= )().-( %-%%>)()",
				},
				["#"] = { -- ERB comment
					add = { "<#- ", " -%>" },
					find = "<%%#%-.-%-%%>",
					delete = "^(<%%#%- )().-( %-%%>)()",
				},
				["w"] = { -- Wiki style links for Markdown
					add = { "[[", "]]" },
					find = "(%[%[).-(%]%])",
					delete = "(%[%[)().-(%]%])()",
				},
			},
		},
	},
}
