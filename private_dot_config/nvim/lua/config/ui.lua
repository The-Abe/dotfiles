local gh = require('config.utils').gh

-- [[ Installing and Configuring Plugins ]]
--
-- To install a plugin simply call `vim.pack.add` with its git url.
-- This will download the default branch of the plugin, which will usually be `main` or `master`
-- You can also have more advanced specs, which we will talk about later.
--
-- For most plugins its not enough to install them, you also need to call their `.setup()` to start them.
--
-- For example, lets say we want to install `guess-indent.nvim` - a plugin for
-- automatically detecting and setting the indentation.
--
-- We first install it from https://github.com/NMAC427/guess-indent.nvim
-- and then call its `setup()` function to start it with default settings.
vim.pack.add { gh 'NMAC427/guess-indent.nvim' }
require('guess-indent').setup {}

-- Here is a more advanced configuration example that passes options to `gitsigns.nvim`
--
-- See `:help gitsigns` to understand what each configuration key does.
-- Adds git related signs to the gutter, as well as utilities for managing changes
vim.pack.add { gh 'lewis6991/gitsigns.nvim' }
require('gitsigns').setup {
  signs = {
    add = { text = '+' }, ---@diagnostic disable-line: missing-fields
    change = { text = '~' }, ---@diagnostic disable-line: missing-fields
    delete = { text = '_' }, ---@diagnostic disable-line: missing-fields
    topdelete = { text = '‾' }, ---@diagnostic disable-line: missing-fields
    changedelete = { text = '~' }, ---@diagnostic disable-line: missing-fields
  },
}

-- Useful plugin to show you pending keybinds.
vim.pack.add { gh 'folke/which-key.nvim' }
require('which-key').setup {
  -- Delay between pressing a key and opening which-key (milliseconds)
  delay = 0,
  icons = { mappings = vim.g.have_nerd_font },
  -- Document existing key chains
  spec = {
    { '<leader>s', group = '[S]earch', mode = { 'n', 'v' } },
    { '<leader>t', group = '[T]oggle' },
    { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } }, -- Enable gitsigns recommended keymaps first
    { '<leader>c', group = '[C]ode', mode = { 'n' } },
    { '<leader>i', group = '[I]nsert', mode = { 'n' } },
    { '<leader>f', group = '[F]iles', mode = { 'n' } },
  },
}

-- [[ Colorscheme ]]
vim.pack.add { gh 'ellisonleao/gruvbox.nvim' }
require('gruvbox').setup {
  contrast = 'hard',
}

vim.cmd.colorscheme 'gruvbox'

-- Highlight todo, notes, etc in comments
vim.pack.add { gh 'folke/todo-comments.nvim' }
require('todo-comments').setup { signs = false }

-- [[ mini.nvim ]]
--  A collection of various small independent plugins/modules
vim.pack.add { gh 'nvim-mini/mini.nvim' }

-- If a nerd font is available, load the icons module for pretty icons in various plugins.
if vim.g.have_nerd_font then
  require('mini.icons').setup()
  -- Used for backwards compatibility with plugins that require `nvim-web-devicons` (e.g. telescope.nvim)
  MiniIcons.mock_nvim_web_devicons()
end

-- Better Around/Inside textobjects
--
-- Examples:
--  - va)  - [V]isually select [A]round [)]paren
--  - yiiq - [Y]ank [I]nside [I]+1 [Q]uote
--  - ci'  - [C]hange [I]nside [']quote
require('mini.ai').setup {
  -- NOTE: Avoid conflicts with the built-in incremental selection mappings on Neovim>=0.12 (see `:help treesitter-incremental-selection`)
  mappings = {
    around_next = 'aa',
    inside_next = 'ii',
  },
  n_lines = 500,
}

-- Add/delete/replace surroundings (brackets, quotes, etc.)
--
-- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
-- - sd'   - [S]urround [D]elete [']quotes
-- - sr)'  - [S]urround [R]eplace [)] [']
require('mini.surround').setup()

-- Simple and easy statusline.
--  You could remove this setup call if you don't like it,
--  and try some other statusline plugin
local statusline = require 'mini.statusline'
-- Set `use_icons` to true if you have a Nerd Font
statusline.setup { use_icons = vim.g.have_nerd_font }

-- You can configure sections in the statusline by overriding their
-- default behavior. For example, here we set the section for
-- cursor location to LINE:COLUMN
---@diagnostic disable-next-line: duplicate-set-field
statusline.section_location = function() return '%2l:%-2v' end

-- ... and there is more!
--  Check out: https://github.com/nvim-mini/mini.nvim

-- [[ render-markdown.nvim ]]
--  Improve viewing Markdown in Neovim
vim.pack.add { gh 'MeanderingProgrammer/render-markdown.nvim' }
require('render-markdown').setup {
  completions = { lsp = { enabled = true } },
  heading = {
    icons = { '1. ', '2. ', '3. ', '4. ' , '5. ', '6. ', '7. ', '8. ', '9. ' },
    position = 'eol',
  },
  checkbox = {
    checked = {
      icon = ' ',
    },
    custom = {
      migrated = { raw = '[>]', rendered = ' ', highlight = 'RenderMarkdownTodo', scope_highlight = nil },
    },
  }
}

-- [[ datepicker.nvim ]]
--  Floating calendar to pick a date and insert it into the buffer
vim.pack.add {
  gh 'folke/snacks.nvim',
  gh 'Dzejkop/datepicker.nvim',
}

vim.keymap.set('n', '<leader>id', function()
  require('datepicker').open {
    week_start = 'monday',
    on_select = function(d)
      local row, col = unpack(vim.api.nvim_win_get_cursor(0))
      local line = vim.api.nvim_get_current_line()
      local insert = d.iso
      vim.api.nvim_set_current_line(line:sub(1, col + 1) .. insert .. line:sub(col + 2))
      vim.api.nvim_win_set_cursor(0, { row, col + 1 + #insert })
    end,
  }
end, { desc = 'Insert [D]ate' })
