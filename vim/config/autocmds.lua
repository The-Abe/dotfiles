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
    vim.api.nvim_buf_set_keymap(
      0,
      "n",
      "gf",
      "<Plug>Markdown_EditUrlUnderCursor<CR>",
      { noremap = true, silent = true }
    )
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

vim.api.nvim_create_autocmd({ "InsertLeave" }, {
  pattern = { "*todo.md" },
  callback = function() vim.cmd([[write]]) end,
})

vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  pattern = { "*" },
  callback = function() vim.cmd([[:%s/\s\+$//e]]) end,
})
