return {
  "folke/trouble.nvim",
  config = function()
    require("trouble").setup {
      modes = {
        diagnostics = {
          auto_open = true,
          auto_close = true,
          preview = {
            type = "float",
            relative = "editor",
            border = "single",
            title = "Preview",
            title_pos = "center",
            position = { 0, -2 },
            size = { width = 0.3, height = 0.3 },
            zindex = 200,
          },
        }
      },
      opts = {}, -- for default options, refer to the configuration section for custom setup.
      cmd = "Trouble",
      keys = {
        {
          "<leader>xs",
          "<cmd>Trouble symbols toggle focus=false win.size=40<cr>",
          desc = "Symbols (Trouble)",
        },
        {
          "<leader>xl",
          "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
          desc = "LSP Definitions / references / ... (Trouble)",
        },
      },
    }
  end,
}
