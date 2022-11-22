call plug#begin('~/.vim/plugged')
Plug 'ludovicchabant/vim-lawrencium'	" Mercurial commands
Plug 'sheerun/vim-polyglot'		" Updates syntax files for most languages
Plug 'osyo-manga/vim-over'	" Preview :s commands
Plug 'junegunn/vim-peekaboo'	" Preview registers before pasting
Plug 'vim-airline/vim-airline'	" Pretty vim but also more informative status bar
Plug 'tomasr/molokai'
Plug 'vim-airline/vim-airline-themes'
Plug 'nvim-tree/nvim-web-devicons'

"Telescope
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'

" LSP and autocomplete
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'williamboman/nvim-lsp-installer'
Plug 'simrat39/rust-tools.nvim'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/vim-vsnip'

" Tpope fanboy section
Plug 'tpope/vim-eunuch' 	" File commands
Plug 'tpope/vim-fugitive'	" Git commands
Plug 'tpope/vim-commentary'	" Add and remove comments
Plug 'tpope/vim-endwise'	" Insert endings of statements
Plug 'tpope/vim-repeat'		" Make '.' work with plugin maps
call plug#end()
