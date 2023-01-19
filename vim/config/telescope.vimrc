lua << EOF
require('telescope').setup{ defaults = { file_ignore_patterns = {"node_modules", "target"} } }
EOF

" I will never get used to not using C-p
nnoremap <c-p> <cmd>Telescope find_files<cr>
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>
