local gh = require('config.utils').gh

vim.pack.add { gh 'epwalsh/obsidian.nvim' }

require('obsidian').setup({
  workspaces = {
    {
      name = 'obsidian',
      path = '~/Obsidian',
    },
  },

  daily_notes = {
    folder = 'Daily/' .. os.date('%Y/%m'),
    date_format = '%Y-%m-%d',
    template = 'Templates/daily',
  },

  templates = {
    folder = 'Templates',
    date_format = '%Y-%m-%d',
    time_format = '%H:%M',
  },

  completion = {
    nvim_cmp = false,
    min_chars = 2,
  },

  ui = {
    enable = false,
  },
})

local function opts(desc)
  return { noremap = true, silent = true, desc = desc }
end

local function cmd(c)
  return function() vim.cmd(c) end
end

vim.keymap.set('n', '<leader>nb', cmd('ObsidianBacklinks'), opts('[B]acklinks'))
vim.keymap.set('n', '<leader>nT', cmd('ObsidianTags'), opts('[T]ags'))

vim.api.nvim_create_autocmd('BufReadPost', {
  pattern = '*.md',
  callback = function()
    vim.keymap.set('n', 'gf', function()
      local ok = pcall(vim.cmd, 'ObsidianFollowLink')
      if not ok then
        return 'gf'
      end
    end, { buffer = true, desc = 'Follow Obsidian link' })
  end,
})

local ok, wk = pcall(require, 'which-key')
if ok then
  wk.add({
    { '<leader>o', group = '[O]bsidian' },
  })
end
