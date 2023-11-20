local opt = { silent = true, noremap = true }
local map = vim.keymap.set
-- I use Ctrl-click for ULRs, so disable in vim
map("n", "<C-LeftMouse>", "<Nop>", opt)

-- Also make gf work with non-existsing files
map("n", "gf", ":e <cfile><cr>", opt)

-- Make C-c work like esc for abbreviations and stuff
map("i", "<c-c>", "<esc>", opt)

-- H/L for really fast end and home
map({ "n", "x", "o" }, "H", "^", opt)
map({ "n", "x", "o" }, "L", "$", opt)

-- Left and right to skip auto inserted brackets and quotes.
map("i", "<a-l>", "<Right>", opt)
map("i", "<a-h>", "<Left>", opt)

-- Sane readline defaults
map("i", "<c-f>", "<c-o>l", opt)
map("i", "<c-b>", "<c-o>h", opt)
map("i", "<a-f>", "<c-o>w", opt)
map("i", "<a-b>", "<c-o>b", opt)
map("i", "<c-k>", "<c-o>D", opt)
map("i", "<c-y>", "<c-o>p", opt)
map("i", "<c-d>", "<c-o>x", opt)
map("i", "<c-a>", "<c-o>^", opt)
map("i", "<c-e>", "<c-o>$", opt)
map("c", "<c-f>", "<right>", opt)
map("c", "<c-b>", "<left>", opt)
map("c", "<a-f>", "<S-right>", opt)
map("c", "<a-b>", "<S-left>", opt)
map("c", "<c-d>", "<del>", opt)
map("c", "<c-a>", "<home>", opt)

-- Indentation
map("x", "<", "<gv", opt)
map("x", ">", ">gv", opt)
map("x", "<a-h>", "<gv", opt)
map("x", "<a-l>", ">gv", opt)
map("n", "<a-l>", ">>", opt)
map("n", "<a-h>", "<<", opt)

-- Move lines
map("n", "<a-k>", ":move-2<cr>", opt)
map("n", "<a-j>", ":move+<cr>", opt)
map("x", "<a-k>", ":move-2<cr>gv", opt)
map("x", "<a-j>", ":move'>+<cr>gv", opt)

-- Buffer navigation
map("n", "<c-l>", ":bn<cr>", opt)
map("n", "<c-h>", ":bp<cr>", opt)

-- Remap for dealing with word wrap
map("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
map("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Diagnostic keymaps
map("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic message" })
map("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic message" })

-- Leader Maps
-- Shortcuts to files
map("n", "<leader>ee", ":enew<cr>", { desc = "New" })
map("n", "<leader>ev", ":e ~/.config/nvim/<cr>", { desc = "Vimrc" })
map("n", "<leader>es", ":e ~/.config/nvim/snippets<cr>", { desc = "Snippets" })
map("n", "<leader>et", ":e ~/.tmux.conf<cr>", { desc = "Tmux.conf" })
map("n", "<leader>eb", ":e ~/.bashrc<cr>", { desc = "Bashrc" })
map("n", "<leader>ep", ":cd ~/projects/", { desc = "Projects" })
map("n", "<leader>en", "<cmd>e $HOME/Obsidian/index.md<cr>", { desc = "Notes" })

map("n", "<leader>bb", ":bn<cr>", { desc = "Next" })
map("n", "<leader>bd", ":bdelete<cr>", { desc = "Delete" })
map("n", "<leader>bn", ":bn<cr>", { desc = "Next" })
map("n", "<leader>bp", ":bp<cr>", { desc = "Previous" })
map("n", "<leader>ba", ":ba<cr>", { desc = "Split All" })
map("n", "<leader>bl", ":blast<cr>", { desc = "Last" })
map("n", "<leader>bf", ":bfirst<cr>", { desc = "First" })

map("n", "<leader>da", ":windo diffthis<cr>", { desc = "All Windows" })
map("n", "<leader>dd", ":diffthis<cr>", { desc = "This Window" })
map("n", "<leader>do", ":diffoff<cr>", { desc = "Off" })

map("n", "<leader>x", "<cmd>!chmod +x %<cr>:e<cr>", { silent = true, desc = "Chmod +x" })

-- Toggle common options
map(
	"n",
	"<leader>tc",
	':silent exec &colorcolumn!=""? "set colorcolumn=" : "set colorcolumn=+1"<cr>',
	{ desc = "Colorcolumn" }
, opt)
map("n", "<leader>tg", ":Copilot disable<cr>:Copilot status<cr>", { desc = "Github copilot" })
map("n", "<leader>th", ":set hlsearch!<cr>:set hlsearch?<cr>", { desc = "Hlsearch" })
map("n", "<leader>tl", ":set cursorline!<cr>:set cursorline?<cr>", { desc = "Cursorline" })
map(
	"n",
	"<leader>tm",
	':silent exec &mouse!=""? "set mouse=" : "set mouse=a"<cr>:set mouse?<cr>',
	{ desc = "Mouse" }
)
map("n", "<leader>tn", ":set number!<cr>:set relativenumber!<cr>:set number?<cr>", { desc = "Number"})
map("n", "<leader>tp", ":set paste!<cr>:set paste?<cr>", { desc = "Paste" })
map("n", "<leader>ts", ":set spell!<cr>:set spell?<cr>", { desc = "Spell" })
map("n", "<leader>tt", ":NvimTreeToggle<cr>", { desc = "Tree" })
map("n", "<leader>tu", ":UndotreeToggle<cr>", { desc = "Undo Tree" })
map("n", "<leader>tw", ":set wrap!<cr>:set wrap?<cr>", { desc = "Wrap" })

map("n", "<leader>cc", [[:%s/\<<C-r><C-w>\>//gI<Left><Left><Left>]], { desc = "word" })
map("n", "<leader>cW", [[:%s/\<<C-r><C-W>\>//gI<Left><Left><Left>]], { desc = "WORD" })
map("n", "<leader>cl", [[:%s/\<<C-r><C-l>\>//gI<Left><Left><Left>]], { desc = "Line" })

map(
	"n",
	"<leader>mu",
	"<cmd>silent !$HOME/Obsidian/.bin/update<cr>",
	{ desc = "Update notes", silent = true }
)
map("n", "<leader>ms", "vip:'<,'>sort<cr>", { desc = "Sort list" })
map("n", "<leader>mf", "vip:'<,'>Tabularize /|<cr>", { desc = "Format Table" })
map(
	"n",
	"<leader>mw",
	'<cmd>silent !$HOME/Obsidian/.bin/convert_to_wiki "%:p"<cr>',
	{ desc = "Convert to Wiki", silent = true }
)
map(
	"n",
	"<leader>md",
	':silent ![ -d ".trash/%:.:h" ] || mkdir ".trash/%:.:h"; mv "%:." "$HOME/Obsidian/.trash/%:."<cr>:bd!<cr>',
	{ desc = "Delete To Trash", silent = true }
)
map("n", "<leader>mm", ":cd $HOME/Obsidian/<cr>:e index.md<cr>", { desc = "Index" })
