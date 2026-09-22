local M = {}
local gh = require("config.utils").gh
local inbox_dir = vim.fn.expand("~/Obsidian/Inbox")
local daily_dir = vim.fn.expand("~/Obsidian/Daily")
local templates_dir = vim.fn.expand("~/Obsidian/Templates")

vim.pack.add { gh "wsdjeg/calendar.nvim" }

local function build_daily_header(date)
  date = date or os.date("*t")
  local time = os.time(date)
  return "# " .. os.date("%A", time) .. " " .. os.date("%Y-%m-%d", time) .. "\n"
end

local function get_daily_path(date)
  date = date or os.date("*t")
  local time = os.time(date)
  local date_str = os.date("%Y-%m-%d", time)
  local month_dir = os.date("%Y/%m", time)
  return daily_dir .. "/" .. month_dir .. "/" .. date_str .. ".md"
end

local function get_daily_date_from_path(path)
  local date_str = path:match("(%d%d%d%d%-%d%d%-%d%d)%.md$")
  if not date_str then
    return nil
  end
  local y, m, d = date_str:match("(%d%d%d%d)%-(%d%d)%-(%d%d)")
  return { year = tonumber(y), month = tonumber(m), day = tonumber(d) }
end

local function is_daily_note(path)
  local daily_prefix = vim.fn.fnamemodify(daily_dir, ":p")
  local p = vim.fn.fnamemodify(path, ":p")
  if not vim.startswith(p, daily_prefix) then
    return false
  end
  return get_daily_date_from_path(p) ~= nil
end

local function ensure_dir_exists(path)
  local dir = vim.fn.fnamemodify(path, ":h")
  if vim.fn.isdirectory(dir) == 0 then
    vim.fn.mkdir(dir, "p")
  end
end

local function read_file(path)
  local file = io.open(path, "r")
  if not file then
    return nil
  end
  local content = file:read("*a")
  file:close()
  return content
end

local function write_file(path, content)
  ensure_dir_exists(path)
  local file = io.open(path, "w")
  if not file then
    vim.notify("Failed to write file: " .. path, vim.log.levels.ERROR)
    return false
  end
  file:write(content)
  file:close()
  return true
end

local function append_to_file(path, content)
  ensure_dir_exists(path)
  local file = io.open(path, "a")
  if not file then
    vim.notify("Failed to append to file: " .. path, vim.log.levels.ERROR)
    return false
  end
  file:write(content)
  file:close()
  return true
end

local function insert_at_section_bottom(content, heading, line)
  local heading_pattern = heading .. "\n"
  local pos = content:find(heading_pattern, 1, true)

  if not pos then
    content = content .. "\n" .. heading .. "\n" .. line
    return content
  end

  local section_start = pos + #heading_pattern

  local level = #heading:match("^(#+)")
  local next_heading_pos = nil
  local search_pos = section_start
  while search_pos <= #content do
    local h_pos = content:find("\n(#+) ", search_pos)
    if not h_pos then
      break
    end
    local found_level = #content:match("^(#+)", h_pos + 1)
    if found_level <= level then
      next_heading_pos = h_pos + 1
      break
    end
    search_pos = h_pos + 1
  end

  local insert_pos
  if next_heading_pos then
    insert_pos = next_heading_pos
    while insert_pos > 1 and content:sub(insert_pos - 1, insert_pos - 1) == "\n" do
      insert_pos = insert_pos - 1
    end
  else
    insert_pos = #content + 1
    while content:sub(-1) == "\n" do
      content = content:sub(1, -2)
    end
  end

  content = content:sub(1, insert_pos - 1) .. "\n" .. line .. content:sub(insert_pos)
  return content
end

function M.new_note()
  vim.ui.input({ prompt = "Note name: " }, function(name)
    if not name or name == "" then
      return
    end

    local template_path = templates_dir .. "/default.md"
    local template_content = read_file(template_path)
    if not template_content then
      template_content = "# " .. name
    else
      template_content = template_content:gsub("<%% tp%.file%.cursor() %%>", name)
    end

    local note_path = inbox_dir .. "/" .. name .. ".md"
    if write_file(note_path, template_content) then
      vim.cmd("edit " .. vim.fn.fnameescape(note_path))
      vim.notify("Created note: " .. name)
    end
  end)
end

function M.add_todo(text, date)
  if not text or text == "" then
    vim.notify("Todo text cannot be empty", vim.log.levels.ERROR)
    return
  end

  date = date or os.date("*t")
  local daily_path = get_daily_path(date)
  local content = read_file(daily_path)
  local timestamp = os.date("%Y-%m-%d")
  local todo_line = "- [ ] " .. text .. " [CAPTURED: " .. timestamp .. "]"

  if not content then
    content = build_daily_header(date) .. "\n## Todo\n" .. todo_line
    write_file(daily_path, content)
  else
    content = insert_at_section_bottom(content, "## Todo", todo_line)
    write_file(daily_path, content)
  end

  vim.notify("Added todo: " .. text)
end

function M.new_todo(date)
  vim.ui.input({ prompt = "Todo item: " }, function(item)
    if not item or item == "" then
      return
    end
    M.add_todo(item, date)
    M.open_daily_at(date)
  end)
end

function M.add_idea(text, date)
  if not text or text == "" then
    vim.notify("Idea text cannot be empty", vim.log.levels.ERROR)
    return
  end

  date = date or os.date("*t")
  local daily_path = get_daily_path(date)
  local content = read_file(daily_path)
  local timestamp = os.date("%H:%M")
  local idea_line = "> [" .. timestamp .. "] " .. text

  if not content then
    content = build_daily_header(date) .. "\n## Ideas\n" .. idea_line
    write_file(daily_path, content)
  else
    content = insert_at_section_bottom(content, "## Ideas", idea_line)
    write_file(daily_path, content)
  end

  vim.notify("Added idea: " .. text)
end

function M.new_idea(date)
  vim.ui.input({ prompt = "Idea: " }, function(idea)
    if not idea or idea == "" then
      return
    end
    M.add_idea(idea, date)
    M.open_daily_at(date)
  end)
end

function M.add_log(text, date)
  if not text or text == "" then
    vim.notify("Log text cannot be empty", vim.log.levels.ERROR)
    return
  end

  date = date or os.date("*t")
  local daily_path = get_daily_path(date)
  local content = read_file(daily_path)
  local timestamp = os.date("%H:%M:%S")
  local log_line = "- " .. text .. " [CAPTURED: " .. timestamp .. "]"

  if not content then
    content = build_daily_header(date) .. "\n## Log\n" .. log_line
    write_file(daily_path, content)
  else
    content = insert_at_section_bottom(content, "## Log", log_line)
    write_file(daily_path, content)
  end

  vim.notify("Added log: " .. text)
end

function M.new_log(date)
  vim.ui.input({ prompt = "Log: " }, function(log)
    if not log or log == "" then
      return
    end
    M.add_log(log, date)
    M.open_daily_at(date)
  end)
end

function M.toggle_todo(status)
  local line = vim.api.nvim_get_current_line()
  local checkboxes = {
    done = "- [x] ",
    waiting = "- [~] ",
    ["in-progress"] = "- [-] ",
    todo = "- [ ] ",
  }

  local replacement = checkboxes[status]
  local new_line

  if line:match("%- %[.-%] ") then
    new_line = line:gsub("%- %[.-%] ", replacement, 1)
  else
    new_line = line:gsub("^(%s*)", "%1" .. replacement)
  end

  vim.api.nvim_set_current_line(new_line)
end

function M.schedule_todo()
  require("datepicker").open({
    week_start = "monday",
    on_select = function(d)
      local line = vim.api.nvim_get_current_line()
      local schedule_tag = "[SCHEDULE:" .. d.iso .. "]"
      local new_line = line:gsub("%s*%[SCHEDULE:%d%d%d%d%-%d%d%-%d%d%]%s*", " ")
      new_line = new_line:gsub("%s*$", " " .. schedule_tag)
      vim.api.nvim_set_current_line(new_line)
    end,
  })
end

function M.deadline_todo()
  require("datepicker").open({
    week_start = "monday",
    on_select = function(d)
      local line = vim.api.nvim_get_current_line()
      local deadline_tag = "[DEADLINE:" .. d.iso .. "]"
      local new_line = line:gsub("%s*%[DEADLINE:%d%d%d%d%-%d%d%-%d%d%]%s*", " ")
      new_line = new_line:gsub("%s*$", " " .. deadline_tag)
      vim.api.nvim_set_current_line(new_line)
    end,
  })
end

local function ensure_daily_note(date)
  date = date or os.date("*t")
  local daily_path = get_daily_path(date)
  if not read_file(daily_path) then
    write_file(daily_path, build_daily_header(date))
  end
  return daily_path
end

function M.open_daily_at(date)
  local daily_path = ensure_daily_note(date)
  vim.cmd("edit " .. vim.fn.fnameescape(daily_path))
end

function M.open_daily_split(date)
  local daily_path = ensure_daily_note(date)
  vim.cmd("vsplit " .. vim.fn.fnameescape(daily_path))
end

function M.open_daily()
  M.open_daily_at(os.date("*t"))
end

local function shift_daily(offset_days)
  local date = get_daily_date_from_path(vim.fn.expand("%:p")) or os.date("*t")
  local time = os.time({ year = date.year, month = date.month, day = date.day, isdst = false }) + offset_days * 86400
  M.open_daily_at(os.date("*t", time))
end

function M.next_daily()
  shift_daily(1)
end

function M.prev_daily()
  shift_daily(-1)
end

local calendar_origin_win = nil

local function calendar_focus()
  if calendar_origin_win and vim.api.nvim_win_is_valid(calendar_origin_win) then
    vim.api.nvim_set_current_win(calendar_origin_win)
  end
  pcall(require("calendar.view").close)
end

function M.open_calendar()
  calendar_origin_win = vim.api.nvim_get_current_win()
  require("calendar").open()
end

local function get_week_range()
  local today = os.date("*t")
  local day = today.wday
  local monday_offset = day == 1 and 6 or day - 2
  local monday = os.time({
    year = today.year,
    month = today.month,
    day = today.day - monday_offset,
    isdst = false,
  })
  local sunday = monday + 6 * 86400
  return monday, sunday
end

local function format_date(time)
  return os.date("%Y-%m-%d", time)
end

local function format_day_header(time)
  return os.date("%A %Y-%m-%d", time)
end

local function scan_daily_files()
  local files = {}
  local handle = vim.fn.glob(daily_dir .. "/**/*.md", false, true)
  for _, path in ipairs(handle) do
    table.insert(files, path)
  end
  return files
end

local function extract_tagged_tasks(files, week_start, week_end)
  local tasks = {}
  local week_start_str = format_date(week_start)
  local week_end_str = format_date(week_end)

  for _, filepath in ipairs(files) do
    local content = read_file(filepath)
    if content then
      for line in content:gmatch("[^\r\n]+") do
        local date_str = line:match("%[SCHEDULE:(%d%d%d%d%-%d%d%-%d%d)%]")
        local tag_kind = "schedule"
        if not date_str then
          date_str = line:match("%[DEADLINE:(%d%d%d%d%-%d%d%-%d%d)%]")
          tag_kind = "deadline"
        end
        if date_str then
          if date_str >= week_start_str and date_str <= week_end_str then
            table.insert(tasks, {
              date = date_str,
              kind = tag_kind,
              line = line:gsub("^%s*(.-)%s*$", "%1"),
              source = filepath,
            })
          end
        end
      end
    end
  end

  table.sort(tasks, function(a, b)
    if a.date == b.date then
      return a.kind < b.kind
    end
    return a.date < b.date
  end)

  return tasks
end

function M.show_week()
  local week_start, week_end = get_week_range()
  local prev_start = week_start - 7 * 86400
  local next_end = week_end + 7 * 86400

  local files = scan_daily_files()
  local tasks = extract_tagged_tasks(files, prev_start, next_end)

  local weeks = {
    { label = "Previous", start = prev_start, ["end"] = week_start - 86400 },
    { label = "Current", start = week_start, ["end"] = week_end },
    { label = "Next", start = week_end + 86400, ["end"] = next_end },
  }

  local lines = {}
  for _, week in ipairs(weeks) do
    table.insert(lines, "# " .. week.label .. " Week: " .. format_date(week.start) .. " to " .. format_date(week["end"]))
    table.insert(lines, "")

    local week_tasks = {}
    local week_start_str = format_date(week.start)
    local week_end_str = format_date(week["end"])
    for _, task in ipairs(tasks) do
      if task.date >= week_start_str and task.date <= week_end_str then
        table.insert(week_tasks, task)
      end
    end

    if #week_tasks == 0 then
      table.insert(lines, "No scheduled or deadline tasks.")
    else
      local current_date = nil
      for _, task in ipairs(week_tasks) do
        if task.date ~= current_date then
          current_date = task.date
          local y, m, d = task.date:match("(%d%d%d%d)%-(%d%d)%-(%d%d)")
          local time = os.time({ year = tonumber(y), month = tonumber(m), day = tonumber(d), isdst = false })
          table.insert(lines, "## " .. format_day_header(time))
          table.insert(lines, "")
        end
        local clean_line = task.line:gsub("%s*%[SCHEDULE:%d%d%d%d%-%d%d%-%d%d%]", ""):gsub("%s*%[DEADLINE:%d%d%d%d%-%d%d%-%d%d%]", ""):gsub("^%s*(.-)%s*$", "%1")
        table.insert(lines, clean_line)
      end
    end
    table.insert(lines, "")
  end

  local buf = vim.api.nvim_create_buf(true, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.api.nvim_buf_set_option(buf, "modifiable", false)
  vim.api.nvim_buf_set_option(buf, "filetype", "markdown")

  vim.cmd("vsplit")
  vim.api.nvim_win_set_buf(0, buf)
  vim.api.nvim_win_set_width(0, 60)
end

local function setup_keymaps()
  local opts = function(desc)
    return { noremap = true, silent = true, desc = desc }
  end

  vim.keymap.set("n", "<leader>nc", M.new_note, opts("New note in Inbox"))
  vim.keymap.set("n", "<leader>nC", M.open_calendar, opts("Open calendar"))
  vim.keymap.set("n", "<leader>ni", M.new_idea, opts("New idea in daily note"))
  vim.keymap.set("n", "<leader>nl", M.new_log, opts("New log in daily note"))
  vim.keymap.set("n", "<leader>nd", M.open_daily, opts("Open daily note"))
  vim.keymap.set("n", "<leader>nn", M.new_todo, opts("New todo in daily note"))
  vim.keymap.set("n", "<leader>ntd", function() M.toggle_todo("done") end, opts("Mark as done"))
  vim.keymap.set("n", "<leader>ntw", function() M.toggle_todo("waiting") end, opts("Mark as waiting"))
  vim.keymap.set("n", "<leader>nti", function() M.toggle_todo("in-progress") end, opts("Mark as in-progress"))
  vim.keymap.set("n", "<leader>ntt", function() M.toggle_todo("todo") end, opts("Mark as todo"))
  vim.keymap.set("n", "<leader>nDs", M.schedule_todo, opts("Schedule todo (pick date)"))
  vim.keymap.set("n", "<leader>nDd", M.deadline_todo, opts("Deadline todo (pick date)"))
  vim.keymap.set("n", "<leader>na", M.show_week, opts("Show week agenda"))
end

function M.setup()
  ensure_dir_exists(inbox_dir)
  ensure_dir_exists(daily_dir)
  ensure_dir_exists(templates_dir)
  setup_keymaps()

  require("calendar").setup({})
  require("calendar.extensions").register("daily", {
    get = function(year, month)
      local marks = {}
      local pattern = daily_dir .. "/" .. string.format("%04d/%02d", year, month) .. "/*.md"
      for _, path in ipairs(vim.fn.glob(pattern, false, true)) do
        local day = path:match("(%d%d)%.md$")
        if day then
          table.insert(marks, { year = year, month = month, day = tonumber(day) })
        end
      end
      return marks
    end,
    actions = {
      open = function(year, month, day)
        calendar_focus()
        M.open_daily_at({ year = year, month = month, day = day })
      end,
      split = function(year, month, day)
        calendar_focus()
        M.open_daily_split({ year = year, month = month, day = day })
      end,
      append_todo = function(year, month, day)
        calendar_focus()
        M.new_todo({ year = year, month = month, day = day })
      end,
      append_idea = function(year, month, day)
        calendar_focus()
        M.new_idea({ year = year, month = month, day = day })
      end,
      append_log = function(year, month, day)
        calendar_focus()
        M.new_log({ year = year, month = month, day = day })
      end,
    },
  })

  local daily_note_group = vim.api.nvim_create_augroup("NotesDailyNote", { clear = true })
  vim.api.nvim_create_autocmd({ "BufReadPost", "BufEnter" }, {
    group = daily_note_group,
    callback = function()
      if is_daily_note(vim.fn.expand("%:p")) then
        vim.keymap.set("n", "]n", M.next_daily, { buffer = true, silent = true, desc = "Next daily note" })
        vim.keymap.set("n", "[n", M.prev_daily, { buffer = true, silent = true, desc = "Previous daily note" })
      end
    end,
  })

  local ok, wk = pcall(require, "which-key")
  if ok then
    wk.add({
      { "<leader>n", group = "[N]otes" },
      { "<leader>nD", group = "[D]ates" },
      { "<leader>nt", group = "[T]odo" },
    })
  end
end

M.setup()

_G.notes = M

return M
