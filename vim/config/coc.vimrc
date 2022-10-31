let g:coc_global_extensions = ['coc-lists', 'coc-yaml', 'coc-html', 'coc-xml', 'coc-solargraph', 'coc-sh', 'coc-rls', 'coc-json', 'coc-go', 'coc-css', '@yaegassy/coc-nginx', 'coc-rust-analyzer', 'coc-snippets']

" Tab completion with <cr> to confirm
inoremap <silent><expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)

" Remap for do codeAction of current line
nmap <leader>a  <Plug>(coc-codeaction)

" Using CocList
nnoremap <silent> <space>la  :<C-u>CocList --normal diagnostics<cr>
nnoremap <silent> <space>lc  :<C-u>CocList commands<cr>
nnoremap <silent> <space>lo  :<C-u>CocList outline<cr>
nnoremap <silent> <c-p> :<C-u>CocList files<cr>
nnoremap <silent> <c-g> :<C-u>CocList grep<cr>
