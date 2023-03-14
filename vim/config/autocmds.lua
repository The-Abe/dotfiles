local remember_folds_id =
vim.api.nvim_create_augroup("remember_folds", { clear = false })
vim.api.nvim_create_autocmd({ "BufWinLeave" }, {
  pattern = "?*",
  group = remember_folds_id,
  callback = function() vim.cmd([[silent! mkview 1]]) end,
})
vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
  pattern = "?*",
  group = remember_folds_id,
  callback = function() vim.cmd([[silent! loadview 1]]) end,
})

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

-- Set wrap and spell in markdown and gitcommit
vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "gitcommit", "markdown" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})

-- fix comment
vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
  pattern = { "*" },
  callback = function() vim.cmd([[set formatoptions-=ro]]) end,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "help" },
  callback = function() vim.cmd([[wincmd L]]) end,
})

vim.api.nvim_create_autocmd({ "TermOpen" }, {
  pattern = { "*" },
  callback = function()
    vim.opt_local["number"] = false
    vim.opt_local["signcolumn"] = "no"
    vim.opt_local["foldcolumn"] = "0"
  end,
})

vim.api.nvim_create_autocmd( { "VimEnter" }, {
  callback = function()
    if not (vim.fn.expand('%') == 'todo.md')
    then
      vim.cmd([[
        silent! Lexplore
        wincmd l
      ]])
    end
  end,
})
