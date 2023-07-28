set nocompatible
syntax on
filetype plugin indent on
set history=10000
set autoread
set scrolloff=10
set hid
set backspace=eol,start,indent
set smartcase
set nohlsearch
set incsearch
set magic
set encoding=utf8
set ffs=unix,dos,mac
set autoindent
set smartindent
set nowrap
set breakindent
set showbreak=->
set sidescroll=1
set sidescrolloff=80
set smarttab
set relativenumber
set number
set linebreak
set shiftround
set textwidth=80
set formatoptions=qrn1j
set background=dark
set modeline
set modelines=5
set omnifunc=syntaxcomplete#Complete
set mouse=
if exists('+termguicolors')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif
set nobackup
set nowb
set noswapfile
set expandtab
set shiftwidth=2
set tabstop=2
set path=.,,
set spelllang=nl,en
set wildmenu
set wildmode=longest:full
set hidden
set updatetime=300
set shortmess+=c
set list
set listchars=tab:->,trail:~,extends:>,precedes:<,multispace:.,leadmultispace:\ ,nbsp:.
set pumheight=10
set noshowmode
set splitbelow
set splitright
set nocursorline
set foldenable
set foldlevelstart=99
set foldcolumn=auto:4
set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()
set conceallevel=3

colorscheme dracula

" Use ag in stead of grep: apt install silversearcher-ag
if executable('ag')
  set grepprg=ag\ --vimgrep
endif
cnoreabbrev <expr> grep  (getcmdtype() ==# ':' && getcmdline() =~# '^grep') ? 'silent grep' : 'grep'
cnoreabbrev <expr> lgrep (getcmdtype() ==# ':' && getcmdline() =~# '^lgrep') ? 'silent lgrep' : 'lgrep'

" Open quickfix when quickfix is populated.
augroup quickfix
  autocmd QuickFixCmdPost [^l]* nested copen
  autocmd QuickFixCmdPost l* nested lopen
augroup END

" Return to last edit position when opening files
autocmd BufReadPost *
  \ if line("'\"") > 0 && line("'\"") <= line("$") |
  \   exe "normal! g`\"" |
  \ endif

augroup executable
  autocmd!
  autocmd BufWritePost *
  \ if getline(1) =~ '^#!\s*\S' |
  \   silent! exe "!chmod +x \"%:p\"" |
  \ endif
augroup END

let g:vim_markdown_strikethrough = 1
let g:vim_markdown_no_extensions_in_markdown = 1
let g:vim_markdown_autowrite = 1
