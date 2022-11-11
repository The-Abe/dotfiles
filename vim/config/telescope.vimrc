lua << EOF
require('telescope').setup{ defaults = { file_ignore_patterns = {"node_modules", "target"} } }
EOF

nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>
