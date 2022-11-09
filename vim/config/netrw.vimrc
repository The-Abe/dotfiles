let g:netrw_keepdir = 0
let g:netrw_list_hide = '\(^\|\s\s\)\zs\.\S\+'
let g:netrw_localcopydircmd = 'cp -r'
let g:netrw_liststyle = 0
let g:netrw_localmkdiropt = "-p"
let g:netrw_sizestyle = "H"
hi! link netrwMarkFile Visual
nnoremap <silent> <leader>p :Lexplore %:p:h<CR>:set ft=netrw<CR>
nnoremap <silent> <leader>o :Lexplore<CR>:set ft=netrw<CR>

function! NetrwMapping()
  nmap <buffer> H u
  nmap <buffer> h -^
  nmap <buffer> l <CR>
  nmap <buffer> . gh
  nmap <buffer> P <C-w>z
  nmap <buffer> <space> mf
  set number
  set relativenumber
endfunction

augroup derp
  autocmd filetype netrw call NetrwMapping()
augroup END
