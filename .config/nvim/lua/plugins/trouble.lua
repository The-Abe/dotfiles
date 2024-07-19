return {
  "folke/trouble.nvim",
  opts = {
    modes = {
      diagnostics = {
        auto_open = true,
        auto_close = false
      },
      symbols = {
        auto_open = true,
        auto_close = false,
        width = 40,
        params = {
          include_declaration = false,
        },
      },
    },
    cmd = "Trouble",
  },
}
