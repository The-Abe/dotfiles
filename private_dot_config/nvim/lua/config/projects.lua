local M = {}

function M.project_find()
  local pickers = require("telescope.pickers")
  local finders = require("telescope.finders")
  local sorters = require("telescope.sorters")
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")

  local handle = io.popen("find ~ -maxdepth 4 -name .git -type d 2>/dev/null")
  if not handle then
    return
  end
  local result = handle:read("*a")
  handle:close()

  local projects = {}
  for line in result:gmatch("[^\r\n]+") do
    local project_dir = line:gsub("/.git$", "")
    if project_dir ~= "" then
      table.insert(projects, project_dir)
    end
  end

  table.sort(projects)

  pickers
    .new({}, {
      prompt_title = "Projects",
      finder = finders.new_table({
        results = projects,
        entry_maker = function(entry)
          local dir = vim.fn.fnamemodify(entry, ":t")
          local parent = vim.fn.fnamemodify(entry, ":h:t")
          return {
            value = entry,
            display = parent .. "/" .. dir,
            ordinal = entry,
          }
        end,
      }),
      sorter = sorters.get_fuzzy_file(),
      attach_mappings = function(prompt_bufnr, map)
        actions.select_default:replace(function()
          actions.close(prompt_bufnr)
          local selection = action_state.get_selected_entry()
          if selection then
            vim.cmd("cd " .. selection.value)
            vim.cmd("Oil " .. selection.value)
          end
        end)
        return true
      end,
    })
    :find()
end

return M
