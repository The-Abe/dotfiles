-- Note taking
return {
  {
    'MeanderingProgrammer/markdown.nvim',
    name = 'render-markdown',
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('render-markdown').setup({})
    end,
  },
  {
    'nvim-telekasten/telekasten.nvim',
    dependencies =  { 'nvim-telescope/telescope-media-files.nvim' },
    config= function()
      require('telekasten').setup({
        -- Main paths
        home = '/home/abe/Obsidian',
        dailies = '/home/abe/Obsidian/Todo/Daily',
        weeklies = '/home/abe/Obsidian/Todo/Weekly',
        templates = '/home/abe/Obsidian/Templates',

        template_new_note = '/home/abe/Obsidian/Templates/default.md',
        template_new_daily = '/home/abe/Obsidian/Templates/daily.md',
        template_new_weekly = '/home/abe/Obsidian/Templates/weekly.md',
        journal_auto_open = false,

        journal_auto_open = true,
        image_subdir = "Files",
        extension    = ".md",
        new_note_filename = "title",
        filename_space_subst = "_",
        uuid_type = "%Y%m%d%H%M",
        uuid_sep = "-",

        follow_creates_nonexisting = true,    -- create non-existing on follow
        dailies_create_nonexisting = true,    -- create non-existing dailies
        weeklies_create_nonexisting = true,   -- create non-existing weeklies

        -- Image link style",
        -- wiki:     ![[image name]]
        -- markdown: ![](image_subdir/xxxxx.png)
        image_link_style = "wiki",

        sort = "filename",

        install_syntax = true,

        -- Tag notation: '#tag', '@tag', ':tag:', 'yaml-bare'
        tag_notation = "#tag",

        subdirs_in_links = true,

        -- Command palette theme: dropdown (window) or ivy (bottom panel)
        command_palette_theme = "dropdown",

        -- Tag list theme:
        -- get_cursor (small tag list at cursor)
        -- dropdown (window)
        -- ivy (bottom panel)
        show_tags_theme = "dropdown",

        media_previewer = "catimg-previewer",

        media_extensions = {
          ".png",
          ".jpg",
          ".bmp",
          ".gif",
          ".webm",
          ".webp",
        },

        -- Calendar integration
        plug_into_calendar = true,
        calendar_opts = {
          weeknm = 4,
          calendar_monday = 1,
          calendar_mark = 'left-fit',
        },
        clipboard_program = "xclip",
        auto_set_filetype = false
      })
      local opt = { silent = true, noremap = true }
      local map = vim.keymap.set
      map("n",
        "<C-LeftMouse>",
        "<Nop>",
        opt)
      opt["desc"] = "Find Notes"
      map("n",
        "<leader>mm",
        ":lua require('telekasten').find_notes()<CR>",
        opt)
      opt["desc"] = "Find Daily Notes"
      map("n",
        "<leader>md",
        ":lua require('telekasten').find_daily_notes()<CR>",
        opt)
      opt["desc"] = "Grep Notes"
      map("n",
        "<leader>mg",
        ":lua require('telekasten').search_notes()<CR>",
        opt)
      opt["desc"] = "Follow Link"
      map("n",
        "<cr>",
        ":lua require('telekasten').follow_link()<CR>",
        opt)
      opt["desc"] = "Today"
      map("n",
        "<leader>mt",
        ":lua require('telekasten').goto_today()<CR>",
        opt)
      opt["desc"] = "This Week"
      map("n",
        "<leader>mW",
        ":lua require('telekasten').goto_thisweek()<CR>",
        opt)
      opt["desc"] = "Find Weekly Notes"
      map("n",
        "<leader>mw",
        ":lua require('telekasten').find_weekly_notes()<CR>",
        opt)
      opt["desc"] = "New Note"
      map("n",
        "<leader>mn",
        ":lua require('telekasten').new_note()<CR>",
        opt)
      opt["desc"] = "New Templated Note"
      map("n",
        "<leader>mN",
        ":lua require('telekasten').new_templated_note()<CR>",
        opt)
      opt["desc"] = "Show Backlinks"
      map("n",
        "<leader>mb",
        ":lua require('telekasten').show_backlinks()<CR>",
        opt)
      opt["desc"] = "Find Friends"
      map("n",
        "<leader>mF",
        ":lua require('telekasten').find_friends()<CR>",
        opt)
      opt["desc"] = "Insert Image Link"
      map("n",
        "<leader>mi",
        ":lua require('telekasten').insert_img_link({ i=true })<CR>",
        opt)
      opt["desc"] = "Preview Image"
      map("n",
        "<leader>mp",
        ":lua require('telekasten').preview_img()<CR>",
        opt)
      opt["desc"] = "Browse Media"
      map("n",
        "<leader>mM",
        ":lua require('telekasten').browse_media()<CR>",
        opt)
      opt["desc"] = "Show Tags"
      map("n",
        "<leader>m#",
        ":lua require('telekasten').show_tags()<CR>",
        opt)

      map("i", "[[", "<ESC>:lua require('telekasten').insert_link()<CR>", opt)

    end
  },
}
