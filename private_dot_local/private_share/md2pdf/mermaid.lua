-- md2pdf mermaid filter
-- Renders ```mermaid code blocks to PNG via mermaid-cli (mmdc) and replaces
-- them with images that pandoc/xelatex can embed.
--
-- Env knobs:
--   MD2PDF_MERMAID_CACHE   cache dir (default: $TMPDIR/md2pdf-mermaid)
--   MD2PDF_MERMAID_SCALE   mmdc scale factor (default: 3 -> crisp print)
--   MD2PDF_LINEWIDTH_IN    printable width in inches (default: 6.69 = A4 - 2x2cm)
--   MD2PDF_MAXHEIGHT_IN    max image height in inches (default: 9.6 = A4 - 2x2cm, less slack)
--   MD2PDF_MMDC            path to mmdc (default: whatever is on PATH)
--   MD2PDF_CHROME          chrome binary for puppeteer (default: auto-detect)

local cache = os.getenv("MD2PDF_MERMAID_CACHE")
  or ((os.getenv("TMPDIR") or "/tmp") .. "/md2pdf-mermaid")
local scale = tonumber(os.getenv("MD2PDF_MERMAID_SCALE") or "3") or 3
local linewidth = tonumber(os.getenv("MD2PDF_LINEWIDTH_IN") or "6.69") or 6.69
local maxheight = tonumber(os.getenv("MD2PDF_MAXHEIGHT_IN") or "9.6") or 9.6
local mmdc = os.getenv("MD2PDF_MMDC") or "mmdc"
local CSS_DPI = 96

local function shq(s) return "'" .. s:gsub("'", "'\\''") .. "'" end

local function exists(path)
  local f = io.open(path, "rb")
  if f then f:close() return true end
  return false
end

local function read_file(path)
  local f = io.open(path, "rb")
  if not f then return nil end
  local s = f:read("a")
  f:close()
  return s
end

local function write_file(path, data)
  local f = io.open(path, "wb")
  if not f then return false end
  f:write(data)
  f:close()
  return true
end

-- minimal PNG header reader (IHDR width/height are big-endian at bytes 16..24)
local function png_size(path)
  local head = read_file(path)
  if not head or #head < 24 then return nil end
  local w, h = 0, 0
  for i = 17, 20 do w = w * 256 + head:byte(i) end
  for i = 21, 24 do h = h * 256 + head:byte(i) end
  return w, h
end

local function find_chrome()
  local explicit = os.getenv("MD2PDF_CHROME")
  if explicit and exists(explicit) then return explicit end
  for _, p in ipairs({
    "/usr/bin/google-chrome",
    "/usr/bin/google-chrome-stable",
    "/usr/bin/chromium",
    "/usr/bin/chromium-browser",
    "/snap/bin/chromium",
    "/usr/bin/microsoft-edge",
  }) do
    if exists(p) then return p end
  end
  return nil
end

-- puppeteer config: system chrome + no sandbox (needed in many containers)
local function puppeteer_config()
  local path = cache .. "/puppeteer.json"
  local chrome = find_chrome()
  local cfg = {
    args = { "--no-sandbox", "--disable-setuid-sandbox", "--disable-dev-shm-usage" },
  }
  if chrome then cfg.executablePath = chrome end
  -- stable JSON output (no table ordering surprises: fixed key order below)
  local parts = {}
  if cfg.executablePath then
    parts[#parts + 1] = '  "executablePath": "' .. cfg.executablePath .. '",'
  end
  parts[#parts + 1] = '  "args": ["--no-sandbox", "--disable-setuid-sandbox", "--disable-dev-shm-usage"]'
  local json = "{\n" .. table.concat(parts, "\n") .. "\n}\n"
  local old = read_file(path)
  if old ~= json then write_file(path, json) end
  return path
end

local function render(source)
  local hash = pandoc.sha1(source)
  local png = cache .. "/" .. hash .. ".png"

  if not exists(png) then
    local mmd = cache .. "/" .. hash .. ".mmd"
    if not write_file(mmd, source) then return nil, "cannot write " .. mmd end
    local cfg = puppeteer_config()
    local cmd = table.concat({
      shq(mmdc), "-i", shq(mmd), "-o", shq(png),
      "-p", shq(cfg), "-s", tostring(scale), "-b", "white", "--quiet",
    }, " ") .. " 2>&1"

    local handle = io.popen(cmd)
    local output = handle and handle:read("a") or ""
    local ok, _, code = handle and handle:close()
    if not exists(png) then
      return nil, "mmdc failed: " .. (output ~= "" and output or tostring(code))
    end
  end

  local w, h = png_size(png)
  if not w then return nil, "unreadable png " .. png end

  -- natural size in inches at mermaid's 96 CSS dpi, scaled down to fit both the
  -- printable width and a single page height (tall flowcharts overflow otherwise)
  local natural_w = w / scale / CSS_DPI
  local natural_h = h / scale / CSS_DPI
  local fit = math.min(1, (linewidth * 0.99) / natural_w, maxheight / natural_h)
  local width = natural_w * fit

  return pandoc.Image(
    {},
    png,
    "",
    pandoc.Attr("", {}, { { "width", string.format("%.2fin", width) } })
  )
end

local warned = false

function CodeBlock(block)
  if not block.classes:includes("mermaid") then return nil end

  os.execute("mkdir -p " .. shq(cache))

  local img, err = render(block.text)
  if not img then
    if not warned then
      io.stderr:write("md2pdf: mermaid rendering failed, leaving block as code.\n")
      io.stderr:write("md2pdf: " .. tostring(err) .. "\n")
      warned = true
    end
    return nil
  end

  return pandoc.Para({ img })
end
