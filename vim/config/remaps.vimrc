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
onoremap H ^
onoremap L $

" Left and right to skip auto inserted brackets and quotes.
inoremap <A-l> <Right>
inoremap <A-h> <Left>

" Sane readline defaults
inoremap <c-f> <c-o>l
inoremap <c-b> <c-o>h
inoremap <a-f> <c-o>w
inoremap <a-b> <c-o>b
inoremap <c-k> <c-o>D
inoremap <c-y> <c-o>p

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
nnoremap <leader>vr :source ~/.config/nvim/init.vim<cr>
nnoremap <leader>vm :map<cr>
nnoremap <leader>vs :e ~/.config/nvim/snippets<cr>

" Toggle common options
nnoremap <leader>th :set hlsearch!<cr>:set hlsearch?<cr>
nnoremap <leader>tp :set paste!<cr>:set paste?<cr>
nnoremap <leader>tw :set wrap!<cr>:set wrap?<cr>
nnoremap <leader>ts :set spell!<cr>:set spell?<cr>
nnoremap <leader>tm <ESC>:silent exec &mouse!=""? "set mouse=" : "set mouse=a"<cr>:set mouse?<cr>

" Buffer navigation
nnoremap <c-l> :bn<cr>
nnoremap <c-h> :bp<cr>

" zz everything
nnoremap n nzz
nnoremap N Nzz
nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz
nnoremap * *zz
nnoremap # #zz

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

" Typos
iabbrev ngixn nginx
iabbrev teh the
iabbrev adn and
iabbrev tihs this

nnoremap <leader>w :w!<cr>
nnoremap <leader>q :qa<cr>

" put cursor at end position after yank
vnoremap y ygv<esc>
nnoremap p p=`]

vnoremap J :m '>+1<CR>gv==kgvo<esc>=kgvo
vnoremap K :m '<-2<CR>gv==jgvo<esc>=jgvo
nnoremap <tab> %
nnoremap <c-n> <c-i>

nnoremap <space> :call search('[^a-zA-Z0-9 \t_]')<cr>
nnoremap <c-space> :call search('[^a-zA-Z0-9 \t_]', 'b')<cr>

nnoremap <leader><space> :s/\v([^^])\s+/\1 /g<cr>
nnoremap <leader>' :s/"/'/g<cr>
