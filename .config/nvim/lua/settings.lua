-- Options
local s = vim.o
s.termguicolors = true
s.breakindent = true
s.clipboard = ""
s.completeopt = "menuone,noselect"
s.concealcursor = ""
s.conceallevel = 2
s.cursorline = true
s.cursorlineopt = "number"
s.foldexpr = "v:lua.vim.treesitter.foldexpr()"
s.foldlevelstart = 99
s.foldmethod = "expr"
s.hlsearch = false
s.ignorecase = true
s.list = true
s.listchars = "tab:  ,trail:~,extends:>,precedes:<,leadmultispace: ,nbsp:."
s.mouse = "a"
s.number = true
s.path = ".,,"
s.relativenumber = true
s.signcolumn = "yes"
s.smartcase = true
s.spelllang = "nl,en"
s.tabstop = 2
s.termguicolors = true
s.textwidth = 120
s.timeout = true
s.timeoutlen = 0
s.timeoutlen = 300
s.undofile = true
s.swapfile = false
s.updatetime = 250
s.wildmode = "longest:full,full"
s.wrap = false
s.background = "dark"
vim.g.closetag_filenames = "*.html,*.xhtml,*.phtml,*.erb"
-- Cursor shape based on mode
vim.cmd([[let &t_SI = "\e[6 q"]])
vim.cmd([[let &t_SR = "\e[4 q"]])
vim.cmd([[let &t_EI = "\e[2 q"]])
