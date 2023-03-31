let g:netrw_keepdir = 0
let g:netrw_list_hide = '\(^\|\s\s\)\zs\.\S\+'
let g:netrw_localcopydircmd = 'cp -r'
let g:netrw_liststyle = 3
let g:netrw_localmkdiropt = "-p"
let g:netrw_sizestyle = "H"
let g:netrw_winsize = 15
let g:netrw_banner=0
hi! link netrwMarkFile Visual
nnoremap <silent> <leader>p :Lex<CR>

function! NetrwMapping()
  nmap <buffer> H -
  nmap <buffer> l <CR>
  nmap <buffer> L gn
  nmap <buffer> . gh
endfunction

augroup netrw_mapping
  autocmd!
  autocmd filetype netrw call NetrwMapping()
augroup END
