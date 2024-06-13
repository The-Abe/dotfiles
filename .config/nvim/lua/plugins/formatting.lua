return {
	"alvan/vim-closetag", -- Auto close tags
	"RRethy/nvim-treesitter-endwise", -- Auto close "end" blocks
	"godlygeek/tabular", -- Align text by delimiter
	"tpope/vim-sleuth", -- Detect indentation
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
