-- Enable faster startup by caching compiled Lua modules
vim.loader.enable()

-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

require 'config.options'
require 'config.keymaps'
require 'config.pack'
require 'config.ui'
require 'config.telescope'
require 'config.lsp'
require 'config.formatting'
require 'config.autocomplete'
require 'config.treesitter'

require 'kickstart.plugins.indent_line'
require 'kickstart.plugins.lint'
require 'kickstart.plugins.autopairs'
require 'kickstart.plugins.gitsigns' -- adds gitsigns recommended keymaps
require 'custom.plugins'

-- vim: ts=2 sts=2 sw=2 et
