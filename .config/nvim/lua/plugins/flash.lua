-- Replace some movement commands with better ones.
return {
	{
		"folke/flash.nvim",
		event = "VeryLazy",
		opts = {
			labels = "asdfghjklqwertyuiopzxcvbnm",
			search = {
				multi_window = true,
				forward = true,
				wrap = true,
				incremental = false,
			},
			jump = {
				jumplist = true,
				nohlsearch = false,
				autojump = true,
			},
			label = {
				uppercase = true,
				-- add a label for the first match in the current window.
				-- you can always jump to the first match with `<CR>`
				current = true,
				after = true,
				style = "overlay", ---@type "eol" | "overlay" | "right_align" | "inline"
				distance = true,
				min_pattern_length = 0,
				rainbow = {
					enabled = false,
				},
			},
			highlight = {
				backdrop = false,
				matches = true,
			},
			pattern = "",
			continue = false,
			modes = {
				search = {
					enabled = true,
					highlight = { backdrop = false },
					jump = { history = true, register = true, nohlsearch = true },
				},
				char = {
					enabled = true,
					autohide = false,
					jump_labels = true,
					multi_line = true,
					label = { exclude = "hjkliardc" },
					keys = { "f", "F", "t", "T", ";", "," },
					search = { wrap = false },
					highlight = { backdrop = false, },
					jump = { register = false },
				},
				treesitter = {
					labels = "asdfghjklqwertyuiopzxcvbnm",
					jump = { pos = "range" },
					search = { incremental = false },
					label = { before = true, after = false, style = "overlay" },
					highlight = {
						backdrop = false,
						matches = false,
					},
				},
				treesitter_search = {
					jump = { pos = "range" },
					search = { multi_window = true, wrap = true, incremental = false },
					remote_op = { restore = true },
					label = { before = true, after = true, style = "inline" },
				},
				-- options used for remote flash
				remote = {
					remote_op = { restore = true, motion = true },
				},
			},
		},
		keys = {
			{ "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
			{ "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
		},
	}
}
