local chars = { '_', '.', ':', ',', ';', '|', '/', '\\', '*', '+', '%', '`', '?' }
for idx,char in ipairs(chars) do
    for idx,mode in ipairs({ 'x', 'o' }) do
        vim.api.nvim_set_keymap(mode, "i" .. char, string.format(':<C-u>silent! normal! f%sF%slvt%s<CR>', char, char, char), { noremap = true, silent = true })
        vim.api.nvim_set_keymap(mode, "a" .. char, string.format(':<C-u>silent! normal! f%sF%svf%s<CR>', char, char, char), { noremap = true, silent = true })
    end
end
