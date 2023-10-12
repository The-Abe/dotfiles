---@diagnostic disable: missing-fields
-- Set Leader Keys
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Install package manager
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

-- Plugin List
require('lazy').setup({
  'ludovicchabant/vim-lawrencium',  -- HG commands
  'junegunn/vim-peekaboo',          -- Preview registers before pasting
  'nvim-tree/nvim-web-devicons',    -- Nvim tree
  'alvan/vim-closetag',             -- Auto close tags
  'RRethy/nvim-treesitter-endwise', -- Auto close "end" blocks
  'godlygeek/tabular',              -- Align text by delimiter
  'tpope/vim-fugitive',             -- Git commands
  'tpope/vim-sleuth',               -- Set tabstop and such based on file
  'mhinz/vim-signify',              -- VCS gutter
  'norcalli/nvim-colorizer.lua',    -- Hex colors
  'mbbill/undotree',                -- Undo tree display
  {
    'altermo/ultimate-autopair.nvim',
    event = { 'InsertEnter' },
    branch = 'v0.6',
    opts = {
      close = {
        map = '<A-\'>',
        cmap = '<A-\'>',
      },
      tabout = {
        enable = true,
        hopout = true,
      },
    },
  },
  {
    'numToStr/Comment.nvim', -- Comment mappings
    keys = {
      { "gc", mode = { "n", "v" }, desc = "[C]omment toggle" },
      { "gb", mode = { "n", "v" }, desc = "[B]lock comment toggle" },
    },
    opts = function()
      local commentstring_avail, commentstring = pcall(require, "ts_context_commentstring.integrations.comment_nvim")
      return commentstring_avail and commentstring and { pre_hook = commentstring.create_pre_hook() } or {}
    end,
  },
  {
    'folke/which-key.nvim', -- Show keybinds
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 0
    end,
    opts = {}
  },
  {
    "folke/flash.nvim", -- Replace some movement commands with better ones.
    event = "VeryLazy",
    opts = {},
    keys = {
      {
        "s",
        mode = { "n", "o", "x" },
        function() require("flash").jump() end,
        desc = "Flash",
        id =
        "Flash"
      },
    },
  },
  {
    'kylechui/nvim-surround', -- Vim surround alternative
    opts = {
      -- Some Ruby ERB binds
      surrounds = {
        ['-'] = {
          add = { '<%- ', ' -%>' },
          find = "<%%%-.-%-%%>",
          delete = "^(<%%%- )().-( %-%%>)()",
        },
        ['='] = {
          add = { '<%= ', ' -%>' },
          find = "<%%=.-%-%%>",
          delete = "^(<%%= )().-( %-%%>)()",
        },
        ['#'] = {
          add = { '<#- ', ' -%>' },
          find = "<%%#%-.-%-%%>",
          delete = "^(<%%#%- )().-( %-%%>)()",
        },
      }
    }
  },
  {
    'neovim/nvim-lspconfig', -- LSP Configuration & Plugins
    dependencies = {
      { 'williamboman/mason.nvim', config = true },
      'williamboman/mason-lspconfig.nvim',
      { 'j-hui/fidget.nvim',       tag = 'legacy', opts = {} },
      { "folke/neodev.nvim",       opts = {} }
    },
  },
  {
    'hrsh7th/nvim-cmp', -- Autocompletion
    dependencies = {
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',
      'hrsh7th/cmp-nvim-lsp',
      'rafamadriz/friendly-snippets',
    },
  },
  {
    'dracula/vim', -- Theme
    priority = 1000,
    config = function()
      vim.cmd.colorscheme 'dracula'
    end,
  },
  {
    'nvim-lualine/lualine.nvim', -- Status line
    opts = {
      options = {
        icons_enabled = true,
        theme = 'auto',
        component_separators = '|',
      },
      sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch', 'diff', { 'diagnostics', symbols = { error = 'E', warn = 'W', info = 'I', hint = 'H' } } },
        lualine_c = { 'filename' },
        lualine_x = { 'filetype', 'encoding', 'fileformat' },
      },
      inactive_sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch', 'diff', { 'diagnostics', symbols = { error = 'E', warn = 'W', info = 'I', hint = 'H' } } },
        lualine_c = { 'filename' },
        lualine_x = { 'filetype', 'encoding', 'fileformat' },
      },
      winbar = {
        lualine_a = { 'buffers' },
      },
      inactive_winbar = {
        lualine_a = { 'buffers' },
      },
      extensions = { 'quickfix', 'fugitive', 'fzf', 'lazy', 'man' }
    },
  },
  {
    'nvim-telescope/telescope.nvim', -- Fuzzy Finder (files, lsp, etc)
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
    },
  },
  {
    'nvim-treesitter/nvim-treesitter', -- Highlight, edit, and navigate code
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
      'JoosepAlviste/nvim-ts-context-commentstring' -- Change comment string on TS context for embeded languages
    },
    build = ':TSUpdate',
  },
}, {})

-- Options
vim.o.hlsearch = false
vim.wo.number = true
vim.wo.relativenumber = true
vim.o.mouse = 'a'
vim.o.clipboard = ''
vim.o.breakindent = true
vim.o.undofile = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.wo.signcolumn = 'yes'
vim.o.updatetime = 250
vim.o.timeoutlen = 300
vim.o.completeopt = 'menuone,noselect'
vim.o.termguicolors = true
vim.o.spelllang = 'nl,en'
vim.o.list = true
vim.o.listchars = 'tab:  ,trail:~,extends:>,precedes:<,multispace:.,leadmultispace: ,nbsp:.'
vim.o.path = '.,,'
vim.o.conceallevel = 2
vim.o.foldlevelstart = 99
vim.o.foldmethod = 'expr'
vim.o.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
--vim.o.foldtext = 'v:lua.vim.treesitter.foldtext()' --Enable when foldtext is in main

-- Basic Keymaps
-- Also  make gf  work with non-existsing files
vim.keymap.set('n', 'gf', ':e <cfile><cr>')

-- Make C-c work like esc for abbreviations and stuff
vim.keymap.set('i', '<c-c>', '<esc>')

-- H/L for really fast end and home
vim.keymap.set({ 'n', 'x', 'o' }, 'H', '^')
vim.keymap.set({ 'n', 'x', 'o' }, 'L', '$')

-- Left and right to skip auto inserted brackets and quotes.
vim.keymap.set('i', '<a-l>', '<Right>')
vim.keymap.set('i', '<a-h>', '<Left>')

-- Sane readline defaults
vim.keymap.set('i', '<c-f>', '<c-o>l')
vim.keymap.set('i', '<c-b>', '<c-o>h')
vim.keymap.set('i', '<a-f>', '<c-o>w')
vim.keymap.set('i', '<a-b>', '<c-o>b')
vim.keymap.set('i', '<c-k>', '<c-o>D')
vim.keymap.set('i', '<c-y>', '<c-o>p')
vim.keymap.set('i', '<c-d>', '<c-o>x')

-- Indentation
vim.keymap.set('x', '<', '<gv')
vim.keymap.set('x', '>', '>gv')

-- Move lines
vim.keymap.set('n', '<a-k>', ':move-2<cr>')
vim.keymap.set('n', '<a-j>', ':move+<cr>')
vim.keymap.set('x', '<a-k>', ':move-2<cr>gv')
vim.keymap.set('x', '<a-j>', ':move\'>+<cr>gv')

-- Buffer navigation
vim.keymap.set('n', '<c-l>', ':bn<cr>')
vim.keymap.set('n', '<c-h>', ':bp<cr>')

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })

-- Leader Maps
-- Shortcuts to files
vim.keymap.set('n', '<leader>ev', ':e ~/.config/nvim/init.lua<cr>', { desc = "[E]dit [V]imrc" })
vim.keymap.set('n', '<leader>es', ':e ~/.config/nvim/snippets<cr>', { desc = "[E]dit [S]nippets" })
vim.keymap.set('n', '<leader>et', ':e ~/.tmux.conf<cr>', { desc = "[E]dit [T]mux.conf" })
vim.keymap.set('n', '<leader>eb', ':e ~/.bashrc<cr>', { desc = "[E]dit [B]ashrc" })
vim.keymap.set('n', '<leader>ep', ':cd ~/projects/', { desc = "[E]dit [P]rojects" })

-- Toggle common options
vim.keymap.set('n', '<leader>th', ':set hlsearch!<cr>:set hlsearch?<cr>', { desc = "[T]oggle [H]lsearch" })
vim.keymap.set('n', '<leader>tp', ':set paste!<cr>:set paste?<cr>', { desc = "[T]oggle [P]aste" })
vim.keymap.set('n', '<leader>tw', ':set wrap!<cr>:set wrap?<cr>', { desc = "[T]oggle [W]rap" })
vim.keymap.set('n', '<leader>ts', ':set spell!<cr>:set spell?<cr>', { desc = "[T]oggle [S]pell" })
vim.keymap.set('n', '<leader>tm', '<ESC>:silent exec &mouse!=""? "set mouse=" : "set mouse=a"<cr>:set mouse?<cr>',
  { desc = "[T]oggle [M]ouse" })
vim.keymap.set('n', '<leader>tn', ':set number!<cr>:set relativenumber!<cr>:set number?<cr>',
  { desc = "[T]oggle [N]umber" })

vim.keymap.set('n', '<leader>bc', ':bclose<cr>', { desc = "[B]uffer [C]lose" })
vim.keymap.set('n', '<leader>bn', ':bn<cr>', { desc = "[B]uffer [N]ext" })
vim.keymap.set('n', '<leader>bp', ':bp<cr>', { desc = "[B]uffer [P]revious" })
vim.keymap.set('n', '<leader>ba', ':ba<cr>', { desc = "[B]uffer Split [A]ll" })
vim.keymap.set('n', '<leader>bl', ':blast<cr>', { desc = "[B]uffer [L]ast" })
vim.keymap.set('n', '<leader>bf', ':bfirst<cr>', { desc = "[B]uffer [F]irst" })

vim.keymap.set('n', '<leader>da', ':windo diffthis<cr>', { desc = "[D]iff [A]ll Windows" })
vim.keymap.set('n', '<leader>dt', ':diffthis<cr>', { desc = "[D]iff [T]his Window" })
vim.keymap.set('n', '<leader>do', ':diffoff<cr>', { desc = "[D]iff [O]ff" })

vim.keymap.set('n', '<leader>tu', ':UndotreeToggle<cr>', { desc = "[T]oggle [U]ndo Tree" })

vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true, desc = "Chmod +x" })

-- Highlight on yank
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- Telescope config and binds
require('telescope').setup {
  defaults = {
    mappings = {
      i = {
        ['<C-u>'] = false,
        ['<C-d>'] = false,
      },
    },
  },
  pickers ={
    oldfiles = { theme = "ivy" },
    find_files = { theme = "ivy" },
    git_files = { theme = "ivy" },
    help_tags = { theme = "ivy" },
    grep_string = { theme = "ivy" },
    live_grep = { theme = "ivy" },
    diagnostics = { theme = "dropdown" },
    resume = { theme = "ivy" },
    marks = { theme = "dropdown" },
    buffers = { theme = "ivy" },
    builtin = { theme = "dropdown" },
    commands = { theme = "dropdown" },
    lsp_references = { theme = "cursor" },
    lsp_implementations = { theme = "cursor" },
    lsp_document_symbols = { theme = "ivy" },
    lsp_dynamic_workspace_symbols = { theme = "ivy" },
  },
}

-- Enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')

vim.keymap.set('n', '<leader>/', function()
  require('telescope.builtin').current_buffer_fuzzy_find({
    previewer = false,
  })
end, { desc = 'Find in buffer' })

local tb = require('telescope.builtin')
vim.keymap.set('n', '<leader>?', tb.oldfiles, { desc = 'Find Recent' })
vim.keymap.set('n', '<leader><space>', tb.find_files, { desc = 'Find Files' })
vim.keymap.set('c', '<c-t>', tb.find_files, { desc = 'Find Files' })
vim.keymap.set('n', '<leader>gf', tb.git_files, { desc = 'Search [G]it [F]iles' })
vim.keymap.set('n', '<leader>sf', tb.find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>sh', tb.help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sw', tb.grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', tb.live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sd', tb.diagnostics, { desc = '[S]earch [D]iagnostics' })
vim.keymap.set('n', '<leader>sr', tb.resume, { desc = '[S]earch [R]esume' })
vim.keymap.set('n', '<leader>sm', tb.marks, { desc = '[S]earch [M]arks' })
vim.keymap.set('n', '<leader>sb', tb.buffers, { desc = '[S]earch [B]uffers' })
vim.keymap.set('n', '<leader>st', tb.builtin, { desc = '[S]earch [T]elescope Builtins' })
vim.keymap.set('n', '<leader>:', tb.commands, { desc = 'Find Commands' })
vim.keymap.set('n', '<M-x>', tb.commands, { desc = 'Commands' })

vim.keymap.set('n', '<leader>cw', [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = '[C]hange [w]ord' })
vim.keymap.set('n', '<leader>cW', [[:%s/\<<C-r><C-W>\>/<C-r><C-W>/gI<Left><Left><Left>]], { desc = '[C]hange [W]ORD' })
vim.keymap.set('n', '<leader>cl', [[:%s/\<<C-r><C-l>\>/<C-r><C-l>/gI<Left><Left><Left>]], { desc = '[C]hange [L]ine' })

local wk = require("which-key")
wk.register({
  ["<leader>s"] = { name = "Search" },
  ["<leader>b"] = { name = "Buffer" },
  ["<leader>t"] = { name = "Toggle" },
  ["<leader>d"] = { name = "Diff" },
  ["<leader>e"] = { name = "Edit" },
  ["<leader>g"] = { name = "Git" },
  ["<leader>r"] = { name = "Run" },
  ["<leader>l"] = { name = "LSP" },
  ["<leader>w"] = { name = "Workspace" },
  ["<leader>c"] = { name = "Change" },
})

-- Treesitter
require('nvim-treesitter.configs').setup {
  ignore_install = {},
  sync_install = true,
  modules = {},
  ensure_installed = { 'lua' },
  auto_install = true,

  highlight = {
    enable = true,
    additional_vim_regex_highlighting = { "markdown" },
  },
  context_commentstring = { enable = true, enable_autocmd = false },
  indent = { enable = true },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = '<c-space>',
      node_incremental = '<c-space>',
      scope_incremental = '<c-s>',
      node_decremental = '<M-space>',
    },
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true,
      keymaps = {
        ["ab"] = { query = "@block.outer", desc = "around block" },
        ["ib"] = { query = "@block.inner", desc = "inside block" },
        ["ac"] = { query = "@class.outer", desc = "around class" },
        ["ic"] = { query = "@class.inner", desc = "inside class" },
        ["a?"] = { query = "@conditional.outer", desc = "around conditional" },
        ["i?"] = { query = "@conditional.inner", desc = "inside conditional" },
        ["af"] = { query = "@function.outer", desc = "around function " },
        ["if"] = { query = "@function.inner", desc = "inside function " },
        ["al"] = { query = "@loop.outer", desc = "around loop" },
        ["il"] = { query = "@loop.inner", desc = "inside loop" },
        ["aa"] = { query = "@parameter.outer", desc = "around argument" },
        ["ia"] = { query = "@parameter.inner", desc = "inside argument" },
      },
    },
    move = {
      enable = true,
      set_jumps = true,
      goto_next_start = {
        ["]b"] = { query = "@block.outer", desc = "Next block start" },
        ["]m"] = { query = "@function.outer", desc = "Next function start" },
      },
      goto_next_end = {
        ["]B"] = { query = "@block.outer", desc = "Next block end" },
        ["]M"] = { query = "@function.outer", desc = "Next function end" },
      },
      goto_previous_start = {
        ["[b"] = { query = "@block.outer", desc = "Previous block start" },
        ["[m"] = { query = "@function.outer", desc = "Previous function start" },
      },
      goto_previous_end = {
        ["[B"] = { query = "@block.outer", desc = "Previous block end" },
        ["[M"] = { query = "@function.outer", desc = "Previous function end" },
      },
    },
  },
}

-- LSP
local on_attach = function(_, bufnr)
  local nmap = function(keys, func, desc)
    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  nmap('<leader>lr', vim.lsp.buf.rename, '[L]SP [R]ename')
  nmap('<leader>la', vim.lsp.buf.code_action, '[L]SP [A]ction')

  nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
  nmap('gr', tb.lsp_references, '[G]oto [R]eferences')
  nmap('gI', tb.lsp_implementations, '[G]oto [I]mplementation')
  nmap('<leader>lt', vim.lsp.buf.type_definition, '[L]SP [T]ype')
  nmap('<leader>ls', tb.lsp_document_symbols, '[L]SP [S]ymbols')
  nmap('<leader>lw', tb.lsp_dynamic_workspace_symbols, '[L]SP [W]orkspace Symbols')
  nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
  nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')
  nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
  nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
  nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
  nmap('<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, '[W]orkspace [L]ist Folders')
  nmap('<leader>lf', vim.lsp.buf.format, '[L]SP [F]ormat')

  vim.api.nvim_create_autocmd("CursorHold", {
    buffer = bufnr,
    callback = function()
      local opts = {
        focusable = false,
        close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
        border = 'none',
        source = 'always',
        prefix = ' ',
        scope = 'cursor',
      }
      vim.diagnostic.open_float(nil, opts)
    end,
  })
end

local servers = {
  lua_ls = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
    },
  },
}

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics,
  {
    virtual_text = false,
    signs = true,
    update_in_insert = false,
    virtual_lines = false,
    underline = true,
    severity_sort = true,
  }
)

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Ensure the servers above are installed
local mason_lspconfig = require 'mason-lspconfig'
mason_lspconfig.setup {
  ensure_installed = vim.tbl_keys(servers),
}
mason_lspconfig.setup_handlers {
  function(server_name)
    require('lspconfig')[server_name].setup {
      capabilities = capabilities,
      on_attach = on_attach,
      settings = servers[server_name],
      filetypes = (servers[server_name] or {}).filetypes,
    }
  end
}

local cmp = require 'cmp'
local luasnip = require 'luasnip'
require('luasnip.loaders.from_vscode').lazy_load()
luasnip.config.setup {}
cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert {
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete {},
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_locally_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.locally_jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  },
}

-- Basic Plugin Setups
require('colorizer').setup()
require('nvim-treesitter.configs').setup {
  endwise = {
    enable = true,
  },
}
vim.g.closetag_filenames = '*.html,*.xhtml,*.phtml,*.erb'

-- Add other text objects for almost every character
local chars = { '_', '.', ':', ',', ';', '|', '/', '\\', '*', '+', '%', '`', '?' }
for _, char in ipairs(chars) do
  for _, mode in ipairs({ 'x', 'o' }) do
    vim.api.nvim_set_keymap(mode, "i" .. char, string.format(':<C-u>silent! normal! f%sF%slvt%s<CR>', char, char, char),
      { noremap = true, silent = true })
    vim.api.nvim_set_keymap(mode, "a" .. char, string.format(':<C-u>silent! normal! f%sF%svf%s<CR>', char, char, char),
      { noremap = true, silent = true })
  end
end

-- Autocommands
-- Close temp windows on "q"
vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "qf", "help", "man", "lspinfo" },
  callback = function()
    vim.api.nvim_buf_set_keymap(
      0,
      "n",
      "q",
      "<cmd>q!<CR>",
      { noremap = true, silent = true }
    )
    vim.cmd([[
      set nobuflisted
      ]])
  end,
})

-- Open certain windows to the right
vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "help", "man" },
  callback = function() vim.cmd([[wincmd L]]) end,
})

-- Auto write markdown files on exiting insert mode
vim.api.nvim_create_autocmd({ "InsertLeave" }, {
  pattern = { "*.md" },
  callback = function() vim.cmd([[write]]) end,
})

-- Trailing whitespace and create directory structure on save file
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  pattern = { "*" },
  callback = function()
    vim.cmd([[:%s/\s\+$//e]])
    if vim.fn.isdirectory(vim.fn.expand('%:h')) == 0
    then
      vim.fn.mkdir(vim.fn.expand('%:h'))
    end
  end,
})

-- Text wrapping on markdown
vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "gitcommit", "markdown" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.textwidth = 80
    vim.api.nvim_buf_set_keymap(
      0,
      "n",
      "<C-Space>",
      ":s/- \\[ \\]/- [x]/e<cr>:s/^\\(- \\[.\\] \\)\\@!/- [ ] /e<cr>",
      { noremap = true, silent = true, desc = "Toggle Todo Item" }
    )
    vim.api.nvim_buf_set_keymap(0, "n", "<leader>mu", ":!$HOME/Obsidian/update",
      { noremap = true, silent = true, desc = '[M]arkdown [U]pdate notes' })
    vim.api.nvim_buf_set_keymap(0, "n", "<leader>mt", ":r!cat $HOME/Obsidian/Templates/<tab>",
      { noremap = true, desc = '[M]arkdown Insert [T]emplate' })
  end,
})

-- Open quickfix window on populate
vim.api.nvim_create_autocmd({ "QuickFixCmdPost" }, {
  callback = function()
    vim.cmd([[copen]])
  end
})

-- Reopen last position on file open
vim.api.nvim_create_autocmd({ "BufReadPost" }, {
  callback = function()
    vim.cmd([[normal! g`"]])
  end
})

-- Abbreviations
vim.cmd('abb name/ Abe van der Wielen')
vim.cmd('abb email/ abevanderwielen@gmail.com')
vim.cmd('abb date/ <c-r>=strftime("%F")<cr>')
vim.cmd('abb file/ <c-r>=expand(\'%\')<cr>')
vim.cmd('abb github/ https://github.com/the-abe')
vim.cmd('abb path/ PATH=/usr/local/bin:/usr/bin:/bin')
vim.cmd('abb todo/ - [ ] ')

-- Typos
vim.cmd('abb ngixn nginx')
vim.cmd('abb teh the')
vim.cmd('abb adn and')
vim.cmd('abb tihs this')

vim.o.makeprg = '"%:p"'                                                      -- Default to just calling the full path.
vim.cmd [[au FileType rust set makeprg=cargo\ run]]
vim.keymap.set('n', '<leader>rf', ':w<cr>:make ', { desc = "[R]un [F]ile" }) -- No <cr> to allow params
