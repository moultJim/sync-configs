-- ========================================================================== --
-- 1. THEME & TRANSPARENCY (Safe for all themes)
-- ========================================================================== --
pcall(function()
  require("catppuccin").load()
end)
-- vim.cmd.colorscheme("catppuccin-nvim") -- also good: sorbet, habamax, unokai

-- Fix: Autocommand ensures transparency survives theme switches
vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = function()
    local groups = {
      "Normal", "NormalNC", "EndOfBuffer", "NormalFloat", "FloatBorder",
      "SignColumn", "StatusLine", "StatusLineNC", "TabLine", "TabLineSel",
      "ColorColumn"
    }
    for _, group in ipairs(groups) do
      vim.api.nvim_set_hl(0, group, { bg = "none" })
    end
    vim.api.nvim_set_hl(0, "TabLineFill", { bg = "none", fg = "#767676" })
  end,
})

-- ========================================================================== --
-- 2. CORE ENGINES (Built-in Syntax & Fenced Languages)
-- ========================================================================== --
vim.cmd("syntax on") -- Crucial for your non-Tree-sitter setup

vim.cmd("filetype plugin indent on") -- smart indent, auto wrap, format options

vim.g.markdown_fenced_languages = {
  "bash",
  "sh=bash",
  "python",
  "py=python",
  "lua",
  "go",
  "html",
  "css",
  "json",
  "javascript",
  "js=javascript"
}

-- ========================================================================== --
-- 3. GENERAL ENVIRONMENT OPTIONS
-- ========================================================================== --
vim.opt.number = true          -- line number
vim.opt.relativenumber = true  -- relative line numbers
vim.opt.cursorline = true      -- highlight current line
vim.opt.wrap = false           -- do not wrap lines by default
vim.opt.scrolloff = 10         -- keep 10 lines above/below cursor
vim.opt.sidescrolloff = 8      -- keep 8 positions to left/right of cursor
vim.opt.spell = false          -- disable spell check by default
vim.opt.breakindent = true     -- on wrapped lines, preserve indent
vim.opt.linebreak = true       -- on wrapped lines, select natural for display
vim.opt.shm = "at"             -- abbreviate file messages; truncate as needed
vim.opt.shortmess:append("c")  -- suppress built-in completion menu messages

-- ========================================================================== --
-- 4. INDENTATION
-- ========================================================================== --
vim.opt.tabstop = 2            -- tab width
vim.opt.shiftwidth = 2         -- indent width
vim.opt.softtabstop = 2        -- soft tab stop
vim.opt.expandtab = true       -- use spaces instead of tabs
vim.opt.smartindent = true     -- smart auto-indent
vim.opt.autoindent = true      -- copy indent from current line

-- ========================================================================== --
-- 5. SEARCH SETTINGS
-- ========================================================================== --
vim.opt.ignorecase = true      -- case insensitive search
vim.opt.smartcase = true       -- case sensitive if uppercase present
vim.opt.hlsearch = false       -- don't highlight search matches
vim.opt.incsearch = true       -- show matches as you type

-- ========================================================================== --
-- 6. VISUAL & COMPLETION SETTINGS
-- ========================================================================== --
vim.opt.termguicolors = true   -- enable 24-bit colors
vim.opt.signcolumn = "yes"     -- always show a sign column
vim.opt.colorcolumn = "60,80"  -- show columns at 60 and 80 positions
vim.opt.showmatch = true       -- highlights matching brackets
vim.opt.matchtime = 2          -- show match for 2 seconds
vim.opt.cmdheight = 1          -- single line command line
vim.opt.showmode = false       -- handled by statusline

-- Code Completion Adjustments (Removed invalid autocomplete lines)
vim.opt.complete = '.,w,b,o'
vim.opt.completeopt = "menu,menuone,noselect,fuzzy" 
vim.opt.autocomplete = true
vim.opt.autocompletedelay = 200
vim.opt.pumheight = 10         -- popupmenu height
vim.opt.pumblend = 10         -- popupmenu transparency
vim.opt.winblend = 0          -- floating window transparency

-- Markdown/Text behaviors
vim.opt.conceallevel = 0
vim.g.markdown_syntax_conceal = 0  -- Block native md from forcing conceal
vim.opt.concealcursor = ""     -- never hide markup under cursor
vim.opt.synmaxcol = 300        -- syntax highlighting column limit
vim.opt.fillchars = { eob = " " } -- hide "~" on empty lines
vim.opt.virtualedit = "block"  -- Allow free cursor movement in visual block

-- ========================================================================== --
-- 7. FILE HANDLING & UNDO MANAGEMENT
-- ========================================================================== --
local undodir = vim.fn.expand("~/.vim/undodir")
if vim.fn.isdirectory(undodir) == 0 then
  vim.fn.mkdir(undodir, "p")
end

vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false
vim.opt.undofile = true
vim.opt.undodir = undodir

vim.opt.updatetime = 300       -- faster completion responses
vim.opt.timeoutlen = 300       -- timeout duration
vim.opt.ttimeoutlen = 0        -- key code timeout
vim.opt.autoread = true        -- auto-reload changes made outside neovim
vim.opt.autowrite = false      -- do not autosave
vim.opt.confirm = true         -- Confirm before exiting unsaved buffers
vim.opt.hidden = true          -- allow hidden buffers
vim.opt.errorbells = false     -- no error sounds
vim.opt.backspace = "indent,eol,start"
vim.opt.autochdir = false

vim.opt.iskeyword:append("-")  -- include - in word definitions
vim.opt.path:append("**")      -- include subdirs in searches
vim.opt.selection = "inclusive"
vim.opt.mouse = ""           -- disable 

-- ========================================================================== --
-- 8. CLIPBOARD OPTIMIZATION (OSC 52 for ChromeOS Terminal)
-- ========================================================================== --
vim.g.clipboard = {
  name = 'OSC 52',
  copy = {
    ['+'] = require('vim.ui.clipboard.osc52').copy('+'),
    ['*'] = require('vim.ui.clipboard.osc52').copy('*'),
  },
  -- Force an immediate no-op on paste queries to prevent terminal timeout hangs
  paste = {
    ['+'] = function() return vim.fn.split(vim.fn.getreg(''), '\n') end,
    ['*'] = function() return vim.fn.split(vim.fn.getreg(''), '\n') end,
  },
}

vim.opt.clipboard = 'unnamedplus'

vim.opt.modifiable = true
vim.opt.encoding = "utf-8"
vim.opt.guicursor = "n-v-c:block,i-ci-ve:block,r-cr:hor20,o:hor50,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor,sm:block-blinkwait175-blinkoff150-blinkon175"

-- ========================================================================== --
-- 9. FOLDING & SPLITS (Fixed Tree-sitter dependency)
-- ========================================================================== --
vim.opt.foldmethod = "syntax"  -- Use light, built-in regex syntax folding
vim.opt.foldlevel = 99         -- start with all folds open
vim.opt.splitbelow = true      -- horizontal splits go below
vim.opt.splitright = true      -- vertical splits go right

-- Command-line tab completion
vim.opt.wildmenu = true
vim.opt.wildmode = "longest:full,full"
vim.opt.diffopt:append("linematch:60")
vim.opt.redrawtime = 10000
vim.opt.maxmempattern = 20000
vim.g.markdown_recommended_style = 0

-- ========================================================================== --
-- 10. NATIVE LSP COMPLETION (Neovim 0.11+)
-- ========================================================================== --
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("lsp_completion", { clear = true }),
  callback = function(args)
    local client_id = args.data.client_id
    if not client_id then return end
    local client = vim.lsp.get_client_by_id(client_id)
    if client and client:supports_method("textDocument/completion") then
      vim.lsp.completion.enable(true, client_id, args.buf, { autotrigger = true })
    end
  end,
})

