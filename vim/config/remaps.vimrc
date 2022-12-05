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

" Close temp screens with q
au FileType help nnoremap q :q!<cr>
au FileType qf nnoremap q :q!<cr>

" Buffer navigation
nnoremap <c-l> :bn<cr>
nnoremap <c-h> :bp<cr>

" Spelling
nnoremap <f9> :set spell!<cr>

" Change next
nnoremap cn *``cgn
nnoremap cN *``cgN
let g:mc = "y/\\V\<C-r>=escape(@\", '/')\<CR>\<CR>"
vnoremap <expr> cn g:mc . "``cgn"

" zz everything
nnoremap n nzz
nnoremap N Nzz
nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz
nnoremap * *zz
nnoremap # #zz

" Abbreviations
iabbrev name/ Abe van der Wielen
iabbrev email/ abevanderwielen@gmail.com
iabbrev date/ <c-r>=strftime("%F")<CR>
iabbrev file/ <c-r>%
iabbrev github/ https://github.com/the-abe
