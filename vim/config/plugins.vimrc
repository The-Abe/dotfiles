call plug#begin('~/.vim/plugged')
"Plug 'matchit.zip' "Make % work with more stuff like ruby keywords.
Plug 'ludovicchabant/vim-lawrencium'	" Mercurial commands
Plug 'sheerun/vim-polyglot'		" Updates syntax files for most languages

Plug 'osyo-manga/vim-over'	" Preview :s commands
Plug 'junegunn/vim-peekaboo'	" Preview registers before pasting
Plug 'neoclide/coc.nvim', {'branch': 'release'}	" Coc LSP stuff
Plug 'vim-airline/vim-airline'	" Pretty vim but also more informative status bar
Plug 'tomasr/molokai'
Plug 'vim-airline/vim-airline-themes'

" Tpope fanboy section
Plug 'tpope/vim-eunuch' 	" File commands
Plug 'tpope/vim-fugitive'	" Git commands
Plug 'tpope/vim-commentary'	" Add and remove comments
Plug 'tpope/vim-endwise'	" Insert endings of statements
Plug 'tpope/vim-repeat'		" Make '.' work with plugin maps
call plug#end()
