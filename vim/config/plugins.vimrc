call plug#begin('~/.vim/plugged')
Plug 'ludovicchabant/vim-lawrencium' " Mercurial commands
Plug 'junegunn/vim-peekaboo' " Preview registers before pasting
Plug 'dracula/vim'
Plug 'nvim-lualine/lualine.nvim'
Plug 'arkav/lualine-lsp-progress'
Plug 'nvim-tree/nvim-web-devicons'
Plug 'akinsho/toggleterm.nvim'
Plug 'preservim/vim-markdown'
Plug 'cweagans/vim-taskpaper'

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
Plug 'L3MON4D3/LuaSnip'
Plug 'saadparwaiz1/cmp_luasnip'
Plug 'rafamadriz/friendly-snippets'
Plug 'hrsh7th/cmp-nvim-lsp-signature-help'
Plug 'nvim-treesitter/nvim-treesitter-context'

" Tpope fanboy section
Plug 'tpope/vim-commentary' " Add and remove comments
Plug 'tpope/vim-repeat' " Make '.' work with plugin maps
Plug 'kylechui/nvim-surround' "Vim surround alternative
call plug#end()
