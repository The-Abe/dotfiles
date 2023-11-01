---@diagnostic disable: missing-fields
-- Set Leader Keys
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

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
  'nvim-tree/nvim-tree.lua',        -- File tree
  "folke/tokyonight.nvim",
  'ludovicchabant/vim-lawrencium',  -- HG commands
  'nvim-tree/nvim-web-devicons',    -- Nvim tree
  'alvan/vim-closetag',             -- Auto close tags
  'RRethy/nvim-treesitter-endwise', -- Auto close "end" blocks
  'godlygeek/tabular',              -- Align text by delimiter
  'tpope/vim-sleuth',
  'tpope/vim-fugitive',             -- Git commands
  'mhinz/vim-signify',              -- VCS gutter
  'norcalli/nvim-colorizer.lua',    -- Hex colors
  'mbbill/undotree',                -- Undo tree display
  'nvim-telescope/telescope-symbols.nvim',
  "zbirenbaum/copilot.lua",
  'freitass/todo.txt-vim',
  {
    'nvim-orgmode/orgmode',
    dependencies = {
      { 'nvim-treesitter/nvim-treesitter', lazy = true },
    },
    event = 'VeryLazy',
    config = function()
      -- Load treesitter grammar for org
      require('orgmode').setup_ts_grammar()

      -- Setup treesitter
      require('nvim-treesitter.configs').setup({
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = { 'org' },
        },
        ensure_installed = { 'org' },
      })

      -- Setup orgmode
      require('orgmode').setup({
        org_agenda_files = '~/*',
        org_default_notes_file = '~/refile.org',
      })
    end,
  },
  {
    "zbirenbaum/copilot.lua",
    config = function ()
      require("copilot").setup({
        suggestion = {
          enabled = true,
          auto_trigger = true,
          debounce = 75,
          keymap = {
            accept = "<M-c>",
            accept_word = false,
            accept_line = false,
            next = "<M-]>",
            prev = "<M-[>",
            dismiss = "<C-]>",
          },
        },
      })
    end
  },
  {
    "zbirenbaum/copilot-cmp",
    config = function ()
      require("copilot_cmp").setup()
    end
  },
  {
    'renerocksai/telekasten.nvim',
    dependencies = {'nvim-telescope/telescope.nvim'}
  },
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
      { "gc", mode = { "n", "v" }, desc = "Comment toggle" },
      { "gb", mode = { "n", "v" }, desc = "Block comment toggle" },
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
        id = "Flash"
      },
    },
  },
  {
    'kylechui/nvim-surround', -- Vim surround alternative
    opts = {
      surrounds = {
        ['-'] = { -- ERB embeded Ruby
          add = { '<%- ', ' -%>' },
          find = "<%%%-.-%-%%>",
          delete = "^(<%%%- )().-( %-%%>)()",
        },
        ['='] = { -- ERB output
          add = { '<%= ', ' -%>' },
          find = "<%%=.-%-%%>",
          delete = "^(<%%= )().-( %-%%>)()",
        },
        ['#'] = { -- ERB comment
          add = { '<#- ', ' -%>' },
          find = "<%%#%-.-%-%%>",
          delete = "^(<%%#%- )().-( %-%%>)()",
        },
        ['w'] = { -- Wiki style links for Markdown
          add = { '[[', ']]' },
          find = "(%[%[).-(%]%])",
          delete = "(%[%[)().-(%]%])()",
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
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
    },
  },
  {
    'nvim-lualine/lualine.nvim', -- Status line
    opts = {
      options = {
        icons_enabled = true,
        theme = 'tokyonight',
        component_separators = '|',
        section_separators = '',
        disabled_filetypes = {
          'NvimTree',
        },
      },
      sections = {
        lualine_a = { 'mode' },
        lualine_b = {},
        lualine_c = { 'branch', 'diff', { 'diagnostics', symbols = { error = 'E', warn = 'W', info = 'I', hint = 'H' } } },
        lualine_x = { 'filetype' },
        lualine_y = {},
        lualine_z = {},
      },
      inactive_sections = {
        lualine_a = { 'mode' },
        lualine_b = {},
        lualine_c = { 'branch', 'diff', { 'diagnostics', symbols = { error = 'E', warn = 'W', info = 'I', hint = 'H' } } },
        lualine_x = { 'filetype' },
        lualine_y = {},
        lualine_z = {},
      },
      winbar = {
        lualine_c = { 'buffers' },
      },
      inactive_winbar = {
        lualine_c = { 'buffers' },
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
  {
    "nvim-treesitter/nvim-treesitter-context",
    enabled = true,
    opts = { mode = "cursor", max_lines = 3 },
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    opts = {
      indent = {
        char = "│",
        tab_char = "│",
      },
      scope = { enabled = false },
      exclude = {
        filetypes = {
          "help",
          "alpha",
          "dashboard",
          "neo-tree",
          "Trouble",
          "trouble",
          "lazy",
          "mason",
          "notify",
          "toggleterm",
          "lazyterm",
        },
      },
    },
    main = "ibl",
  },
  {
    'stevearc/conform.nvim',
    opts = {},
  }
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
vim.o.concealcursor = ''
vim.o.foldlevelstart = 99
vim.o.foldmethod = 'expr'
vim.o.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
vim.o.cursorline = true
vim.o.cursorlineopt = 'number'
vim.o.wildmode = 'longest:full,full'
--vim.o.foldtext = 'v:lua.vim.treesitter.foldtext()' --Enable when foldtext is in main
vim.o.wrap = false

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
vim.keymap.set('n', '<a-l>', '>>')
vim.keymap.set('n', '<a-h>', '<<')

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
vim.keymap.set('n', '<leader>ev', ':e ~/.config/nvim/init.lua<cr>', { desc = "Vimrc" })
vim.keymap.set('n', '<leader>es', ':e ~/.config/nvim/snippets<cr>', { desc = "Snippets" })
vim.keymap.set('n', '<leader>et', ':e ~/.tmux.conf<cr>', { desc = "Tmux.conf" })
vim.keymap.set('n', '<leader>eb', ':e ~/.bashrc<cr>', { desc = "Bashrc" })
vim.keymap.set('n', '<leader>ep', ':cd ~/projects/', { desc = "Projects" })
vim.keymap.set('n', '<leader>en', ':enew<cr>', { desc = "New" })

-- Toggle common options
vim.keymap.set('n', '<leader>th', ':set hlsearch!<cr>:set hlsearch?<cr>', { desc = "Hlsearch" })
vim.keymap.set('n', '<leader>tp', ':set paste!<cr>:set paste?<cr>', { desc = "Paste" })
vim.keymap.set('n', '<leader>tw', ':set wrap!<cr>:set wrap?<cr>', { desc = "Wrap" })
vim.keymap.set('n', '<leader>ts', ':set spell!<cr>:set spell?<cr>', { desc = "Spell" })
vim.keymap.set('n', '<leader>tl', ':set cursorline!<cr>:set cursorline?<cr>', { desc = "Cursorline" })
vim.keymap.set('n', '<leader>tm', ':silent exec &mouse!=""? "set mouse=" : "set mouse=a"<cr>:set mouse?<cr>',
  { desc = "Mouse" })
vim.keymap.set('n', '<leader>tn', ':set number!<cr>:set relativenumber!<cr>:set number?<cr>',
  { desc = "Number" })
vim.keymap.set('n', '<leader>tc', ':silent exec &colorcolumn!=""? "set colorcolumn=" : "set colorcolumn=+1"<cr>',
  { desc = 'Colorcolumn' })
vim.keymap.set('n', '<leader>tt', ':NvimTreeToggle<cr>',
  { desc = 'Tree' })

vim.keymap.set('n', '<leader>bd', ':bdelete<cr>', { desc = "Delete" })
vim.keymap.set('n', '<leader>bn', ':bn<cr>', { desc = "Next" })
vim.keymap.set('n', '<leader>bp', ':bp<cr>', { desc = "Previous" })
vim.keymap.set('n', '<leader>ba', ':ba<cr>', { desc = "Split All" })
vim.keymap.set('n', '<leader>bl', ':blast<cr>', { desc = "Last" })
vim.keymap.set('n', '<leader>bf', ':bfirst<cr>', { desc = "First" })

vim.keymap.set('n', '<leader>da', ':windo diffthis<cr>', { desc = "All Windows" })
vim.keymap.set('n', '<leader>dt', ':diffthis<cr>', { desc = "This Window" })
vim.keymap.set('n', '<leader>do', ':diffoff<cr>', { desc = "Off" })

vim.keymap.set('n', '<leader>tu', ':UndotreeToggle<cr>', { desc = "Undo Tree" })

vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<cr>:e<cr>", { silent = true, desc = "Chmod +x" })

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
    border = {},
    borderchars = { " ", " ", " ", " ", " ", " ", " ", " " },
    layout_strategy = "horizontal",
    layout_config = {
         horizontal = {
            prompt_position = "bottom",
            preview_width = 0.5,
            results_width = 0.5,
         },
         width = 0.60,
         height = 0.60,
         preview_cutoff = 120,
      },
  },
  pickers ={
    diagnostics = { theme = "dropdown" },
    marks = { theme = "dropdown" },
    builtin = { theme = "dropdown" },
    commands = { theme = "dropdown" },
    lsp_references = { theme = "cursor" },
    lsp_implementations = { theme = "cursor" },
  },
}

-- Enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')
require("nvim-tree").setup()

vim.keymap.set('n', '<leader>/', function()
  require('telescope.builtin').current_buffer_fuzzy_find({
    previewer = false,
  })
end, { desc = 'Find in buffer' })

local tb = require('telescope.builtin')
vim.keymap.set('n', '<leader>?', tb.oldfiles, { desc = 'Find Recent' })
vim.keymap.set('n', '<leader><space>', tb.find_files, { desc = 'Find Files' })
vim.keymap.set('c', '<c-t>', tb.find_files, { desc = 'Find Files' })
vim.keymap.set('n', '<leader>gf', tb.git_files, { desc = 'Git Files' })
vim.keymap.set('n', '<leader>sf', tb.find_files, { desc = 'Files' })
vim.keymap.set('n', '<leader>sh', tb.help_tags, { desc = 'Help' })
vim.keymap.set('n', '<leader>sw', tb.grep_string, { desc = 'Current Word' })
vim.keymap.set('n', '<leader>sg', tb.live_grep, { desc = 'Grep' })
vim.keymap.set('n', '<leader>sd', tb.diagnostics, { desc = 'Diagnostics' })
vim.keymap.set('n', '<leader>sr', tb.resume, { desc = 'Resume' })
vim.keymap.set('n', '<leader>sm', tb.marks, { desc = 'Marks' })
vim.keymap.set('n', '<leader>sb', tb.buffers, { desc = 'Buffers' })
vim.keymap.set('n', '<leader>s<space>', tb.builtin, { desc = 'Telescope Builtins' })
vim.keymap.set('n', '<leader>ss', tb.treesitter, { desc = 'Symbols' })
vim.keymap.set('n', '<leader>:', tb.commands, { desc = 'Commands' })
vim.keymap.set('n', '<M-x>', tb.commands, { desc = 'Commands' })
vim.keymap.set('n', '<leader>se', tb.symbols, { desc = 'Emojis' })

vim.keymap.set('n', '<leader>cw', [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = 'word' })
vim.keymap.set('n', '<leader>cW', [[:%s/\<<C-r><C-W>\>/<C-r><C-W>/gI<Left><Left><Left>]], { desc = 'WORD' })
vim.keymap.set('n', '<leader>cl', [[:%s/\<<C-r><C-l>\>/<C-r><C-l>/gI<Left><Left><Left>]], { desc = 'Line' })

vim.keymap.set('n', '<leader>mu', '<cmd>silent !$HOME/Obsidian/.bin/update<cr>', { desc = 'Update notes', silent = true })
vim.keymap.set('n', '<leader>mt', '<cmd>Telekasten new_templated_note<cr>', { desc = 'Templated Note' })
vim.keymap.set('n', '<leader>mn', '<cmd>Telekasten new_note<cr>', { desc = 'Note' })
vim.keymap.set('n', '<leader>ml', '<cmd>Telekasten insert_link<cr>', { desc = 'Insert Link' })
vim.keymap.set('n', '<leader>mf', '<cmd>Telekasten find_notes<cr>', { desc = 'Search In Notes' })
vim.keymap.set('n', '<leader>ms', '<cmd>Telekasten search_notes<cr>', { desc = 'Find Notes' })
vim.keymap.set('n', '<leader>mb', '<cmd>Telekasten show_backlinks<cr>', { desc = 'Backlinks' })
vim.keymap.set('n', '<leader>mw', '<cmd>silent !$HOME/Obsidian/.bin/convert_to_wiki "%:p"<cr>', { desc = 'Convert to Wiki', silent = true })
vim.keymap.set('n', '<leader>md', ':silent ![ -d ".trash/%:.:h" ] || mkdir ".trash/%:.:h"; mv "%:." "$HOME/Obsidian/.trash/%:."<cr>:bd<cr>', { desc = 'Delete To Trash', silent = true })

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
  ["<leader>m"] = { name = "Markdown" },
})

require('copilot').setup({
  suggestion = {
    enabled = true,
    auto_trigger = true,
    debounce = 75,
    keymap = {
      accept = "<M-c>",
      accept_word = false,
      accept_line = false,
      next = "<M-]>",
      prev = "<M-[>",
      dismiss = "<C-]>",
    },
  },
})

-- Formating
require("conform").setup({
  formatters_by_ft = {
    ruby = { 'rubyfmt' },
    lua = { 'stylua' },
    erb = { 'erb-lint' },
    markdown = { 'prettier' },
    html = { 'prettier' },
    css = { 'prettier' },
    go = { 'gofmt' },
    rust = { 'rustfmt' },
    sh = { 'shfmt' },
    sql = { 'sqlfmt' },
    yaml = { 'yamlfix' },
  },
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

  nmap('<leader>lr', vim.lsp.buf.rename, 'Rename')
  nmap('<leader>la', vim.lsp.buf.code_action, 'Action')

  nmap('gd', vim.lsp.buf.definition, 'Definition')
  nmap('gr', tb.lsp_references, 'References')
  nmap('gI', tb.lsp_implementations, 'Implementation')
  nmap('<leader>lt', vim.lsp.buf.type_definition, 'Type')
  nmap('<leader>ls', tb.lsp_document_symbols, 'Symbols')
  nmap('<leader>lw', tb.lsp_dynamic_workspace_symbols, 'Workspace Symbols')
  nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
  nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')
  nmap('gD', vim.lsp.buf.declaration, 'Declaration')
  nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, 'Add Folder')
  nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, 'Remove Folder')
  nmap('<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, 'List Folders')
  nmap('<leader>lf', vim.lsp.buf.format, 'Format')
  nmap("<leader>lF", function() require("conform").format() end, "Format conform")

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
require("luasnip.loaders.from_snipmate").lazy_load()
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
    ['<cr>'] = cmp.mapping.confirm {
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
    { name = 'path' },
    { name = 'buffer' },
  },
}

-- Basic Plugin Setups
require('telekasten').setup({
  home = vim.fn.expand("~/Obsidian"), -- Put the name of your notes directory here
  subdirs_in_links = false,
  plug_into_calendar = false,
  auto_set_filetype = false,
})
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
    vim.api.nvim_set_keymap(mode, "i" .. char, string.format(':<C-u>silent! normal! f%sF%slvt%s<cr>', char, char, char),
      { noremap = true, silent = true })
    vim.api.nvim_set_keymap(mode, "a" .. char, string.format(':<C-u>silent! normal! f%sF%svf%s<cr>', char, char, char),
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
      "<cmd>q!<cr>",
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
  callback = function()
    vim.cmd [[ %s/–/-/ge ]]
    vim.cmd [[ %s/’/'/ge ]]
    vim.cmd [[ %s/“/"/ge ]]
    vim.cmd [[ %s/”/"/ge ]]
    vim.cmd([[write]])
  end,
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
function Toggle_todo()
  if string.match(vim.api.nvim_get_current_line(), "- %[ %]") ~= nil then
    vim.cmd("s/- \\[ \\]/- [x] " .. vim.fn.strftime('%Y-%m-%d %H:%M') .. "/g")
  elseif string.match(vim.api.nvim_get_current_line(), "- %[x%]") ~= nil then
    vim.cmd [[ s/- \[x\] \d\+-\d\+-\d\+ \d\+:\d\+/- [ ]/ ]]
  elseif string.match(vim.api.nvim_get_current_line(), "^%s*- ") ~= nil then
    vim.cmd [[ s/- /- [ ] / ]]
  else
    vim.cmd("normal $^i- [ ] ")
  end
  vim.cmd [[ write ]]
end
function MdHeaderDown()
  if string.match(vim.api.nvim_get_current_line(), "^#") ~= nil then
    vim.cmd [[ s/^#// ]]
  else
    vim.cmd("normal <<")
  end
end
function MdHeaderUp()
  if string.match(vim.api.nvim_get_current_line(), "^#") ~= nil then
    vim.cmd [[ s/^#/##/ ]]
  else
    vim.cmd("normal >>")
  end
end
function NewListLine()
  if string.match(vim.api.nvim_get_current_line(), "^%s*- %[.%]") ~= nil then
    vim.api.nvim_feedkeys("o- [ ] ", 'n', false)
  elseif string.match(vim.api.nvim_get_current_line(), "^%s*-") ~= nil then
    vim.api.nvim_feedkeys("o- ", 'n', false)
  else
    vim.api.nvim_feedkeys("o", 'n', false)
  end
end
vim.api.nvim_create_autocmd({ "FileType", "BufRead", "BufNewFile" }, {
  pattern = { "markdown" },
  callback = function()
    vim.opt_local.textwidth = 80
    --vim.cmd [[syntax match todoCheckbox "\[\ \]" conceal cchar=]]
    --vim.cmd [[syntax match todoCheckbox "\[x\]" conceal cchar=]]
    vim.api.nvim_buf_set_keymap(
      0,
      "n",
      "<C-Space>",
      "<cmd>lua Toggle_todo()<cr>",
      { noremap = true, silent = true, desc = "Toggle Todo Item" }
    )
    vim.api.nvim_buf_set_keymap(
      0,
      "n",
      "o",
      "<cmd>lua NewListLine()<cr>",
      { noremap = true, silent = true, desc = "Create a new line in markdown and consider lists." }
    )
    vim.api.nvim_buf_set_keymap(0, "n", "<a-l>", "<cmd>lua MdHeaderUp()<cr>", {})
    vim.api.nvim_buf_set_keymap(0, "n", "<a-h>", "<cmd>lua MdHeaderDown()<cr>", {})
    vim.api.nvim_buf_set_keymap(0, "n", "<cr>", "<cmd>Telekasten follow_link<cr>", {})
    vim.cmd [[syntax region mdLink matchgroup=mdBrackets start=/\[\[/ end=/\]\]/ concealends display oneline contains=mdAliasedLink]]
    vim.cmd("syntax match mdAliasedLink '[^\\[\\]]\\+|' contained conceal")
    vim.cmd("syntax match mdTitleTail '\\zs#\\ze ' conceal cchar=§")
    vim.cmd("syntax match mdTitleStart '\\zs#\\ze#' conceal cchar=⋅")
    vim.cmd [[ hi mdLink guifg=CadetBlue2 gui=underline ]]
    vim.cmd [[ hi Conceal guifg=MediumPurple1 ]]
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
vim.cmd('abb todo/ - [ ]')

-- Typos
vim.cmd('abb ngixn nginx')
vim.cmd('abb teh the')
vim.cmd('abb adn and')
vim.cmd('abb tihs this')

-- Default to just calling the full path.
vim.o.makeprg = '"%:p"'
vim.cmd [[au FileType rust set makeprg=cargo\ run]]
vim.keymap.set('n', '<leader>rf', ':w<cr>:make ', { desc = "Run File" }) -- No <cr> to allow params
vim.cmd [[ colorscheme tokyonight ]]
