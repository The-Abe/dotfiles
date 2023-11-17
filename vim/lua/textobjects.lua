-- Add other text objects for almost every character
local chars = { "_", ".", ":", ",", ";", "|", "/", "\\", "*", "+", "%", "`", "?" }
for _, char in ipairs(chars) do
	for _, mode in ipairs({ "x", "o" }) do
		vim.api.nvim_set_keymap(
			mode,
			"i" .. char,
			string.format(":<C-u>silent! normal! f%sF%slvt%s<cr>", char, char, char),
			{ noremap = true, silent = true, desc = "Select inside " .. char }
		)
		vim.api.nvim_set_keymap(
			mode,
			"a" .. char,
			string.format(":<C-u>silent! normal! f%sF%svf%s<cr>", char, char, char),
			{ noremap = true, silent = true, desc = "Select around " .. char }
		)
	end
end
