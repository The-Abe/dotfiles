return {
  "folke/trouble.nvim",
  opts = {
    modes = {
      diagnostics = {
        auto_open = true,
        auto_close = false,
      }
    },
  },
  cmd = "Trouble",
  keys = {
    {
      "<leader>ls",
      "<cmd>Trouble symbols toggle focus=false win.size=40<cr>",
      desc = "Symbols (Trouble)",
    },
  },
}
