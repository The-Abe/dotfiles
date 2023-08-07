local telescope = require("telescope")

local actions = require("telescope.actions")

vim.keymap.set('n', '<c-p>', '<CMD>Telescope find_files<cr>')
vim.keymap.set('n', '<leader>m', '<CMD>Telescope marks<cr>')
vim.keymap.set('n', '<leader>r', '<CMD>Telescope registers<cr>')
vim.keymap.set('n', '<c-f>', '<CMD>Telescope current_buffer_fuzzy_find<cr>')
vim.keymap.set('n', '<leader>c', '<CMD>Telescope commands<cr>')
vim.keymap.set('n', '<leader>h', '<CMD>Telescope help_tags<cr>')
vim.keymap.set('n', '<leader>d', '<CMD>Telescope diagnostics<cr>')
vim.keymap.set('n', 'gr', '<CMD>Telescope lsp_references<cr>')
vim.keymap.set('n', 'z=', '<CMD>Telescope spell_suggest<cr>')

telescope.setup({
  defaults = {
    file_ignore_patterns = {
      ".git/",
      "target/",
      "docs/",
      "vendor/*",
      "%.lock",
      "__pycache__/*",
      "%.sqlite3",
      "%.ipynb",
      "node_modules/*",
      "%.jpg",
      "%.jpeg",
      "%.png",
      "%.svg",
      "%.otf",
      "%.ttf",
      "%.webp",
      ".dart_tool/",
      ".github/",
      ".gradle/",
      ".idea/",
      ".settings/",
      ".vscode/",
      "__pycache__/",
      "build/",
      "env/",
      "gradle/",
      "node_modules/",
      "%.pdb",
      "%.dll",
      "%.class",
      "%.exe",
      "%.cache",
      "%.ico",
      "%.pdf",
      "%.dylib",
      "%.jar",
      "%.docx",
      "%.met",
      "smalljre_*/*",
      ".vale/",
      "%.burp",
      "%.mp4",
      "%.mkv",
      "%.rar",
      "%.zip",
      "%.7z",
      "%.tar",
      "%.bz2",
      "%.epub",
      "%.flac",
      "%.tar.gz",
    },
    winblend = 0,
    prompt_prefix = "  ",
    selection_caret = "> ",
    path_display = { "truncate" },
    sorting_strategy = "ascending",
    layout_config = {
      horizontal = {
        prompt_position = "top",
        preview_width = 0.55,
        results_width = 0.8,
      },
      vertical = {
        mirror = false,
      },
      width = 0.87,
      height = 0.80,
      preview_cutoff = 120,
    },
    preview = {
      hide_on_startup = true -- hide previewer when picker starts
    },
  },
})
