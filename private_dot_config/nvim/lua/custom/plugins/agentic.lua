-- Add agentic.nvim from your pack path (~/.local/share/nvim/site/pack/deps/opt/agentic.nvim)
vim.pack.add {
  "https://github.com/carlos-algms/agentic.nvim"
}

require("agentic").setup({
  provider = "opencode-acp",
  position = "right",
  width = 0.4,
})

-- Keymaps
local map = vim.keymap.set

map("n", "<leader>aa", function() require('agentic').toggle() end, { desc = "Toggle ACP Agent Chat" })
map(
  {"n", "v"},
  "<leader>af",
  function()
    require("agentic").add_selection_or_file_to_context()
  end,
  {desc = "Add file or selection to context"}
)
