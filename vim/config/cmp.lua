local cmp = require'cmp'
local luasnip = require'luasnip'
require("luasnip.loaders.from_vscode").lazy_load()
require("luasnip.loaders.from_snipmate").lazy_load({paths = "~/.config/nvim/snippets/"})
luasnip.filetype_extend("ruby", {"rails"})
local has_words_before = function()
  unpack = unpack or table.unpack
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end
local feedkey = function(key, mode)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end

local kind_icons = {
  Class = "ﴯ",
  Color = "",
  Constant = "",
  Constructor = "",
  Enum = "",
  EnumMember = "",
  Event = "",
  Field = "",
  File = "",
  Folder = "",
  Function = "",
  Interface = "",
  Keyword = "",
  Method = "",
  Module = "",
  Operator = "",
  Property = "ﰠ",
  Reference = "",
  Snippet = "",
  Struct = "",
  Text = "",
  TypeParameter = "",
  Unit = "",
  Value = "",
  Variable = "",
}

cmp.setup({
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-j>'] = cmp.mapping.scroll_docs(4),
    ['<C-k>'] = cmp.mapping.scroll_docs(-4),
    ['<C-Space>'] = cmp.mapping(
      function()
        if cmp.visible() then
          cmp.close()
        else
          cmp.complete()
        end
      end
    ),
    ["<Tab>"] = cmp.mapping(function(fallback)
      if luasnip.jumpable(1) then
        luasnip.jump(1)
      elseif cmp.visible() then
        cmp.select_next_item()
      elseif has_words_before() then
        cmp.complete()
      else
        fallback()
        end
      end, { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(function()
      if luasnip.jumpable(-1) then
        luasnip.jump(-1)
      elseif cmp.visible() then
        cmp.select_prev_item()
      end
    end, { "i", "s" }),
    ['<C-n>'] = cmp.mapping(function()
      if luasnip.choice_active() then
        feedkey("<Plug>luasnip-next-choice", "")
      else
        cmp.mapping.select_next_item()
      end
    end, { "i", "s" }),
    ['<C-p>'] = cmp.mapping(function()
      if luasnip.choice_active() then
        feedkey("<Plug>luasnip-prev-choice", "")
      else
        cmp.mapping.select_prev_item()
      end
    end, { "i", "s" }),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'nvim_lsp_signature_help' },
    { name = 'luasnip' },
  }, {
    { name = 'buffer' },
  }),
  snippet = {
    expand = function(args)
      require'luasnip'.lsp_expand(args.body)
    end,
  },
  formatting = {
    format = function(entry, vim_item)
      -- vim_item.kind = string.format("%s %s", kind_icons[vim_item.kind], vim_item.kind) --Concatonate the icons with name of the item-kind
      vim_item.kind = string.format("%s", kind_icons[vim_item.kind]) --Just the icon.
      vim_item.menu = ({
            nvim_lsp = "LSP",
            spell = "Spell",
            buffer = "Buff",
            nvim_lua = "Lua",
            path = "Path",
            nvim_lsp_signature_help = "Sig",
            cmdline = "Vim",
            snippet = "Snippet",
        })[entry.source.name]
      return vim_item
    end,
  },
  matching = {
    disallow_fuzzy_matching = false,
  }
})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'buffer' }
  })
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' },
    },{
    { name = 'cmdline' }
  })
})
