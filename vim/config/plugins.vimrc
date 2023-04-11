call plug#begin('~/.vim/plugged')
Plug 'ludovicchabant/vim-lawrencium' " Mercurial commands
Plug 'sheerun/vim-polyglot' " Updates syntax files for most languages
Plug 'osyo-manga/vim-over' " Preview :s commands
Plug 'junegunn/vim-peekaboo' " Preview registers before pasting
Plug 'tomasr/molokai'
Plug 'nvim-lualine/lualine.nvim'
Plug 'arkav/lualine-lsp-progress'
Plug 'nvim-tree/nvim-web-devicons'
Plug 'akinsho/toggleterm.nvim'

" Telescope
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'

" LSP and autocomplete
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'williamboman/mason.nvim'
Plug 'williamboman/mason-lspconfig.nvim'
Plug 'simrat39/rust-tools.nvim'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/vim-vsnip'
Plug 'rafamadriz/friendly-snippets'
Plug 'hrsh7th/cmp-nvim-lsp-signature-help'
Plug 'mattn/emmet-vim'

" Tpope fanboy section
Plug 'tpope/vim-commentary' " Add and remove comments
Plug 'tpope/vim-repeat' " Make '.' work with plugin maps
Plug 'tpope/vim-surround'
call plug#end()
