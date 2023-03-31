" run current file
nnoremap <leader>r :!%:p<cr>
" also  make gf  work with non-existsing files
nnoremap gf :e <cfile><CR>

" Make c-c behave exactly like esc
inoremap <c-c> <esc>

" H/L for really fast end and home
nnoremap H ^
nnoremap L $
vnoremap H ^
vnoremap L $

" Indentation
vnoremap < <gv
vnoremap > >gv

" Move lines
nnoremap <a-k> :move-2<cr>
nnoremap <a-j> :move+<cr>
vnoremap <a-k> :move-2<cr>gv
vnoremap <a-j> :move'>+<cr>gv

" Shortcut .vimrc
nnoremap <leader>ve :e ~/.config/nvim/init.vim<cr>
nnoremap <leader>vs :source ~/.config/nvim/init.vim<cr>
nnoremap <leader>vm :map<cr>

" Toggle common options
nnoremap <leader>th :set hlsearch!<cr>:set hlsearch?<cr>
nnoremap <leader>tp :set paste!<cr>:set paste?<cr>
nnoremap <leader>tw :set wrap!<cr>:set wrap?<cr>
nnoremap <leader>ts :set spell!<cr>:set spell?<cr>

" Buffer navigation
nnoremap <c-l> :bn<cr>
nnoremap <c-h> :bp<cr>

" Change next
nnoremap cn *``cgn
nnoremap cN *``cgN
let g:mc = "y/\\V\<C-r>=escape(@\", '/')\<CR>\<CR>"
vnoremap <expr> cn g:mc . "``cgn"

" zz everything
" nnoremap n nzz
" nnoremap N Nzz
" nnoremap <C-d> <C-d>zz
" nnoremap <C-u> <C-u>zz
" nnoremap * *zz
" nnoremap # #zz

nnoremap <leader>gd :call GitDiff()<cr>
function GitDiff()
  let cur_type = &ft
  diffthis
  vnew
  setlocal buftype=nofile
  setlocal bufhidden=hide
  exec "0read !git -P show HEAD:".expand("#:~:.")
  diffthis
  exec "set filetype=".cur_type
  wincmd h
endfunction

nnoremap <leader>hd :call HgDiff()<cr>
function HgDiff()
  let cur_type = &ft
  diffthis
  vnew
  setlocal buftype=nofile
  setlocal bufhidden=hide
  exec "0read !hg --pager=no cat ".expand("#:~:.")
  diffthis
  exec "set filetype=".cur_type
  wincmd h
endfunction

" Abbreviations
iabbrev name/ Abe van der Wielen
iabbrev email/ abevanderwielen@gmail.com
iabbrev <expr> date/ strftime("%F")
iabbrev <expr> file/ expand('%')
iabbrev github/ https://github.com/the-abe
iabbrev bash/ #!/bin/bash
iabbrev ruby/ #!/usr/bin/env ruby
iabbrev path/ PATH=/usr/local/bin:/usr/bin:/bin

" Expand or jump
imap <expr> <C-j>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-j>'
smap <expr> <C-j>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-j>'

" Jump forward or backward
imap <expr> <C-k> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<C-k>'
smap <expr> <C-L> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<C-k>'

nnoremap <leader>w :w!<cr>
nnoremap <leader>d :bd<cr>
nnoremap <leader>q :qa<cr>

nnoremap <tab> <c-w><c-w>
nnoremap <cr> gD
