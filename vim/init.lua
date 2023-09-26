vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Install package manager
-- https://github.com/folke/lazy.nvim
-- `:help lazy.nvim.txt` for more info
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
require('lazy').setup({
  'ludovicchabant/vim-lawrencium', -- Mercurial commands
  'junegunn/vim-peekaboo', -- Preview registers before pasting
  'nvim-tree/nvim-web-devicons',
  'm4xshen/autoclose.nvim',
  'alvan/vim-closetag',
  'godlygeek/tabular',
  'zane-/cder.nvim',
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {},
    keys = {
      { "s", mode = { "n", "o", "x" }, function() require("flash").jump() end, desc = "Flash", id = "Flash" },
      { "S", mode = { "n", "o", "x" }, function() require("flash").treesitter() end, desc = "Flash Treesitter", id = "Flash Treesitter" },
    },
  },
  {
    "epwalsh/obsidian.nvim",
    lazy = false,
    event = { "BufReadPre /home/abe/Obsidian/**.md" },
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    opts = {
      dir = "~/Obsidian",  -- no need to call 'vim.fn.expand' here
      mappings = {},
      templates = {
        subdir = "Templates",
        date_format = "%Y-%m-%d",
        time_format = "%H:%M",
      },
      daily_notes = {
        folder = "Daily",
        date_format = "%Y-%m-%d",
        template = "Daily.md"
      },
      note_frontmatter_func = function(note)
        local out = { Tags = note.tags, Date = note.date }
        if note.metadata ~= nil and require("obsidian").util.table_length(note.metadata) > 0 then
          for k, v in pairs(note.metadata) do
            out[k] = v
          end
        end
        return out
      end,
    },
  },
  {
    'kylechui/nvim-surround',  -- Vim surround alternative
    opts = {
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

  -- Git related plugins
  'tpope/vim-fugitive',
  'tpope/vim-rhubarb',

  -- Detect tabstop and shiftwidth automatically
  'tpope/vim-sleuth',

  {
    -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      { 'williamboman/mason.nvim', config = true },
      'williamboman/mason-lspconfig.nvim',
      -- Useful status updates for LSP
      { 'j-hui/fidget.nvim', tag = 'legacy', opts = {} },
      -- Additional lua configuration, for nvim.
      'folke/neodev.nvim',
    },
  },

  {
    -- Autocompletion
    'hrsh7th/nvim-cmp',
    dependencies = {
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',
      'hrsh7th/cmp-nvim-lsp',
      'rafamadriz/friendly-snippets',
    },
  },

  -- Useful plugin to show you pending keybinds.
  { 'folke/which-key.nvim', opts = {} },

  {
    -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    opts = {
      -- See `:help gitsigns.txt`
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
      on_attach = function(bufnr)
        -- don't override the built-in and fugitive keymaps
        local gs = package.loaded.gitsigns
        vim.keymap.set({'n', 'v'}, ']c', function()
          if vim.wo.diff then return ']c' end
          vim.schedule(function() gs.next_hunk() end)
          return '<Ignore>'
        end, {expr=true, buffer = bufnr, desc = "Jump to next hunk"})
        vim.keymap.set({'n', 'v'}, '[c', function()
          if vim.wo.diff then return '[c' end
          vim.schedule(function() gs.prev_hunk() end)
          return '<Ignore>'
        end, {expr=true, buffer = bufnr, desc = "Jump to previous hunk"})
      end,
    },
  },

  {
    -- Theme inspired by Atom
    'dracula/vim',
    priority = 1000,
    config = function()
      vim.cmd.colorscheme 'dracula'
    end,
  },

  {
    'nvim-lualine/lualine.nvim',
    -- See `:help lualine.txt`
    opts = {
      options = {
        icons_enabled = true,
        theme = 'dracula',
        component_separators = '|',
      },
      tabline = {
        lualine_a = {'buffers'}
      },
    },
  },

  {
    -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    opts = {
      char = '┊',
      show_trailing_blankline_indent = false,
    },
  },

  -- "gc" to comment visual regions/lines
  { 'numToStr/Comment.nvim', opts = {} },

  -- Fuzzy Finder (files, lsp, etc)
  {
    'nvim-telescope/telescope.nvim',
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
    -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    build = ':TSUpdate',
  },
}, {})

vim.o.hlsearch = false
vim.wo.number = true
vim.wo.relativenumber = true
vim.o.mouse = 'a'
vim.o.clipboard = 'unnamedplus'
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
vim.o.listchars = 'tab:->,trail:~,extends:>,precedes:<,multispace:.,leadmultispace: ,nbsp:.'
vim.o.path = '.,,'
vim.o.conceallevel = 2
vim.o.foldlevelstart = 99

-- [[ Basic Keymaps ]]
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

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

-- Indentation
vim.keymap.set('x', '<', '<gv')
vim.keymap.set('x', '>', '>gv')

-- Move lines
vim.keymap.set('n', '<a-k>', ':move-2<cr>')
vim.keymap.set('n', '<a-j>', ':move+<cr>')
vim.keymap.set('x', '<a-k>', ':move-2<cr>gv')
vim.keymap.set('x', '<a-j>', ':move\'>+<cr>gv')

-- Shortcut .vimrc
vim.keymap.set('n', '<leader>ev', ':e ~/.config/nvim/init.lua<cr>', { desc = "[E]dit [V]imrc" })
vim.keymap.set('n', '<leader>es', ':e ~/.config/nvim/snippets<cr>', { desc = "[E]dit [S]nippets" })
vim.keymap.set('n', '<leader>et', ':e ~/.tmux.conf<cr>', { desc = "[E]dit [T]mux.conf" })
vim.keymap.set('n', '<leader>eb', ':e ~/.bashrc<cr>', { desc = "[E]dit [B]ashrc" })
vim.keymap.set('n', '<leader>ep', ':cd ~/projects/<cr>:Telescope cder<cr>', { desc = "[E]dit [P]rojects" })

-- Toggle common options
vim.keymap.set('n', '<leader>th', ':set hlsearch!<cr>:set hlsearch?<cr>', { desc = "[T]oggle [H]lsearch" })
vim.keymap.set('n', '<leader>tp', ':set paste!<cr>:set paste?<cr>', { desc = "[T]oggle [P]aste" })
vim.keymap.set('n', '<leader>tw', ':set wrap!<cr>:set wrap?<cr>', { desc = "[T]oggle [W]rap" })
vim.keymap.set('n', '<leader>ts', ':set spell!<cr>:set spell?<cr>', { desc = "[T]oggle [S]pell" })
vim.keymap.set('n', '<leader>tm', '<ESC>:silent exec &mouse!=""? "set mouse=" : "set mouse=a"<cr>:set mouse?<cr>', { desc = "[T]oggle [M]ouse" })
vim.keymap.set('n', '<leader>tn', ':set number!<cr>:set relativenumber!<cr>:set number?<cr>', { desc = "[T]oggle [N]umber" })

-- Buffer navigation
vim.keymap.set('n', '<c-l>', ':bn<cr>')
vim.keymap.set('n', '<c-h>', ':bp<cr>')

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- [[ Highlight on yank ]]
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

require('telescope').setup {
  defaults = {
    mappings = {
      i = {
        ['<C-u>'] = false,
        ['<C-d>'] = false,
      },
    },
  },
  extensions = {
    cder = {
      dir_command = { 'fd', '--type=d', '--max-depth=3', '.', os.getenv('CWD') },
    }
  }
}

-- Enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')

-- Enable cder in telescope
require('telescope').load_extension('cder')

-- See `:help telescope.builtin`
vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
vim.keymap.set('n', '<leader><space>', require('telescope.builtin').find_files, { desc = '[ ] Find files' })
vim.keymap.set('n', '<leader>/', function()
  require('telescope.builtin').current_buffer_fuzzy_find({
    previewer = false,
  })
end, { desc = '[/] Fuzzily search in current buffer' })

vim.keymap.set('n', '<leader>gf', require('telescope.builtin').git_files, { desc = 'Search [G]it [F]iles' })
vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })
vim.keymap.set('n', '<leader>sr', require('telescope.builtin').resume, { desc = '[S]earch [R]esume' })
vim.keymap.set('n', '<leader>sm', require('telescope.builtin').marks, { desc = '[S]earch [M]arks' })
vim.keymap.set('n', '<leader>sb', require('telescope.builtin').buffers, { desc = '[S]earch [B]uffers' })
vim.keymap.set('n', '<leader>:', require('telescope.builtin').commands, { desc = '[:]Commands' })
vim.keymap.set('n', '<M-x>', require('telescope.builtin').commands, { desc = 'Commands' })

vim.keymap.set('n', '<leader>ob', ':ObsidianBacklinks<cr>', { desc = '[O]bsidian [B]acklinks' })
vim.keymap.set('n', '<leader>os', ':ObsidianSearch<cr>', { desc = '[O]bsidian [S]earch' })
vim.keymap.set('n', '<leader>oo', ':ObsidianQuickSwitch<cr>', { desc = '[O]bsidian [O]pen' })
vim.keymap.set('n', '<leader>ot', ':ObsidianToday<cr>', { desc = '[O]bsidian [T]oday' })
vim.keymap.set('n', '<leader>oy', ':ObsidianYesterday<cr>', { desc = '[O]bsidian [Y]esterday' })

-- See `:help nvim-treesitter`
require('nvim-treesitter.configs').setup {
  ignore_install = {},
  sync_install = true,
  modules = {},
  ensure_installed = { 'lua' },
  auto_install = true,

  highlight = {
    enable = true,
    additional_vim_regex_highlighting  = { "markdown" },
  },
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
      lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ['aa'] = '@parameter.outer',
        ['ia'] = '@parameter.inner',
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['ac'] = '@class.outer',
        ['ic'] = '@class.inner',
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        [']m'] = '@function.outer',
        [']]'] = '@class.outer',
      },
      goto_next_end = {
        [']M'] = '@function.outer',
        [']['] = '@class.outer',
      },
      goto_previous_start = {
        ['[m'] = '@function.outer',
        ['[['] = '@class.outer',
      },
      goto_previous_end = {
        ['[M'] = '@function.outer',
        ['[]'] = '@class.outer',
      },
    },
    swap = {
      enable = true,
      swap_next = {
        ['<leader>a'] = '@parameter.inner',
      },
      swap_previous = {
        ['<leader>A'] = '@parameter.inner',
      },
    },
  },
}

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

-- LSP
local on_attach = function(_, bufnr)
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end

    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
  nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

  nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
  nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
  nmap('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
  nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
  nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
  nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

  -- See `:help K` for why this keymap
  nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
  nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

  -- Lesser used LSP functionality
  nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
  nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
  nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
  nmap('<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, '[W]orkspace [L]ist Folders')

  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    vim.lsp.buf.format()
  end, { desc = 'Format current buffer with LSP' })

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

-- Setup neovim lua configuration
require('neodev').setup()

require('autoclose').setup()

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

-- See `:help cmp`
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

-- Define more text objects for da|, ci| etc.
local chars = { '_', '.', ':', ',', ';', '|', '/', '\\', '*', '+', '%', '`', '?' }
for _,char in ipairs(chars) do
  for _,mode in ipairs({ 'x', 'o' }) do
    vim.api.nvim_set_keymap(mode, "i" .. char, string.format(':<C-u>silent! normal! f%sF%slvt%s<CR>', char, char, char), { noremap = true, silent = true })
    vim.api.nvim_set_keymap(mode, "a" .. char, string.format(':<C-u>silent! normal! f%sF%svf%s<CR>', char, char, char), { noremap = true, silent = true })
  end
end

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

vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "help" },
  callback = function() vim.cmd([[wincmd L]]) end,
})

vim.api.nvim_create_autocmd({ "InsertLeave" }, {
  pattern = { "*.md" },
  callback = function() vim.cmd([[write]]) end,
})

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

vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "gitcommit", "markdown" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.textwidth = 80
    vim.keymap.set('n', '<cr>', "<cmd>ObsidianFollowLink<CR>", {silent = true, buffer = true})
  end,
})

vim.api.nvim_create_autocmd({ "QuickFixCmdPost" }, {
  callback = function()
    vim.cmd([[copen]])
  end
})

vim.api.nvim_create_autocmd({ "BufReadPost" }, {
  callback = function()
    vim.cmd([[normal! g`"]])
  end
})

-- Abbreviations
vim.cmd('abb teh the')
-- vim.keymap.set('ia', 'name/', 'Abe van der Wielen')
-- vim.keymap.set('ia', 'email/', 'abevanderwielen@gmail.com')
-- vim.keymap.set('ia', 'date/', '<c-r>=strftime("%F")<cr>')
-- vim.keymap.set('ia', 'file/', '<c-r>=expand(\'%\')<cr>')
-- vim.keymap.set('ia', 'github/', 'https://github.com/the-abe')
-- vim.keymap.set('ia', 'path/', 'PATH=/usr/local/bin:/usr/bin:/bin')
vim.cmd('abb name/ Abe van der Wielen')
vim.cmd('abb email/ abevanderwielen@gmail.com')
vim.cmd('abb date/ <c-r>=strftime("%F")<cr>')
vim.cmd('abb file/ <c-r>=expand(\'%\')<cr>')
vim.cmd('abb github/ https://github.com/the-abe')
vim.cmd('abb path/ PATH=/usr/local/bin:/usr/bin:/bin')

-- Typos
-- vim.keymap.set('ia', 'ngixn', 'nginx')
-- vim.keymap.set('ia', 'teh', 'the')
-- vim.keymap.set('ia', 'adn', 'and')
-- vim.keymap.set('ia', 'tihs', 'this')
vim.cmd('abb ngixn nginx')
vim.cmd('abb teh the')
vim.cmd('abb adn and')
vim.cmd('abb tihs this')

vim.g.closetag_filenames = '*.html,*.xhtml,*.phtml,*.erb'
