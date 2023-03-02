local status_ok, toggleterm = pcall(require, "toggleterm")
if not status_ok then return end

toggleterm.setup({
  size = 10,
  open_mapping = [[<C-CR>]],
  hide_numbers = true,
  shade_filetypes = {},
  shade_terminals = true,
  shading_factor = 0,
  start_in_insert = true,
  insert_mappings = true,
  persist_size = false,
  direction = "float",
  close_on_exit = true,
  shell = vim.o.shell,
  highlights = {
    FloatBorder = { link = "ToggleTermBorder" },
    Normal = { link = "ToggleTerm" },
    NormalFloat = { link = "ToggleTerm" },
  },
  winbar = {
    enabled = true,
    name_formatter = function(term)
      return term.name
    end,
  },
})
