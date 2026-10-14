-- Add agentic.nvim from your pack path (~/.local/share/nvim/site/pack/deps/opt/agentic.nvim)
vim.pack.add {
  "https://github.com/carlos-algms/agentic.nvim"
}

require("agentic").setup({
  provider = "opencode-acp",
  position = "right",
  width = 0.4,
  keymaps = {
    widget = {
      switch_provider = "<leader>as",
      switch_model = "<leader>am",
      change_thought_level = "<leader>at",
      open_options = "<leader>ao",
      select_session = "<leader>al",
      next_session = "<leader>a]",
      prev_session = "<leader>a[",
      destroy_session = "<leader>aD",
    },
    prompt = {
      paste_image = {
        { "<leader>ap", mode = { "n" } },
        { "<C-v>", mode = { "i" } },
      },
    },
  },
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

local ok, wk = pcall(require, "which-key")
if ok then
  wk.add({
    { "<leader>a", group = "AI", icon = "󰚩" },
  })
end
