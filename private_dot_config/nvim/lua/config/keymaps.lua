-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
-- Also clears multicursors
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', function()
  if vim.fn.mode() == 'n' then
    vim.cmd 'noh'
    local mc_ns = vim.api.nvim_create_namespace('nvim.multicursor')
    vim.api.nvim_buf_clear_namespace(0, mc_ns, 0, -1)
  end
  return '<Esc>'
end, { expr = true, silent = true })

-- Diagnostic Config & Keymaps
--  See `:help vim.diagnostic.Opts`
vim.diagnostic.config {
  update_in_insert = false,
  severity_sort = true,
  float = { border = 'rounded', source = 'if_many' },
  underline = { severity = { min = vim.diagnostic.severity.WARN } },

  -- Can switch between these as you prefer
  virtual_text = true, -- Text shows up at the end of the line
  virtual_lines = false, -- Text shows up underneath the line, with virtual lines

  -- Auto open the float, so you can easily read the errors when jumping with `[d` and `]d`
  jump = {
    on_jump = function(_, bufnr)
      vim.diagnostic.open_float {
        bufnr = bufnr,
        scope = 'cursor',
        focus = false,
      }
    end,
  },
}

vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Quickfix' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Folds
vim.keymap.set('n', '<Tab>', 'za', { desc = 'Toggle fold' })

-- [[ Toggle Keymaps (<leader>t prefix) ]]
--  See also: <leader>th (inlay hints, lsp.lua), <leader>tb (git blame, gitsigns.lua),
--            <leader>tw (git word diff, gitsigns.lua)

local function toggle_opt(name, scope)
  scope = scope or 'o'
  vim[scope][name] = not vim[scope][name]
  local state = vim[scope][name] and 'on' or 'off'
  vim.notify(('Option %s: %s'):format(name, state), vim.log.levels.INFO, { title = 'Toggle' })
end

vim.keymap.set('n', '<leader>tn', function() toggle_opt 'relativenumber' end, { desc = 'Toggle relative numbers' })
vim.keymap.set('n', '<leader>tl', function() toggle_opt('wrap', 'wo') end, { desc = 'Toggle line wrap' })
vim.keymap.set('n', '<leader>ts', function() toggle_opt('spell', 'wo') end, { desc = 'Toggle spell check' })
vim.keymap.set('n', '<leader>tc', function() toggle_opt('cursorline', 'wo') end, { desc = 'Toggle cursor line' })
vim.keymap.set('n', '<leader>tt', function() toggle_opt 'list' end, { desc = 'Toggle whitespace chars' })
vim.keymap.set('n', '<leader>ti', function() require('ibl').toggle() end, { desc = 'Toggle indent guides' })
vim.keymap.set('n', '<leader>tv', function()
  local vl = vim.diagnostic.config().virtual_lines
  vim.diagnostic.config { virtual_lines = not vl }
  vim.notify(('Diagnostic virtual lines: %s'):format(not vl and 'on' or 'off'), vim.log.levels.INFO, { title = 'Toggle' })
end, { desc = 'Toggle diagnostic virtual lines' })

-- TIP: Disable arrow keys in normal mode
-- vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
-- vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
-- vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
-- vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- NOTE: Some terminals have colliding keymaps or are not able to send distinct keycodes
-- vim.keymap.set("n", "<C-S-h>", "<C-w>H", { desc = "Move window to the left" })
-- vim.keymap.set("n", "<C-S-l>", "<C-w>L", { desc = "Move window to the right" })
-- vim.keymap.set("n", "<C-S-j>", "<C-w>J", { desc = "Move window to the lower" })
-- vim.keymap.set("n", "<C-S-k>", "<C-w>K", { desc = "Move window to the upper" })

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.hl.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function() vim.hl.on_yank() end,
})
