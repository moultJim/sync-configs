vim.pack.add({
  { src = "https://github.com/catppuccin/nvim",             name = "catppuccin" },
  { src = "https://github.com/neovim/nvim-lspconfig" },
  { src = "https://github.com/rafamadriz/friendly-snippets" },
  { src = "https://github.com/nvim-mini/mini.nvim" }
})

-- 1. Tell the server configuration how to behave globally
table.insert(vim.lsp.config, {
  name = 'lua_ls',
  settings = {
    Lua = {
      diagnostics = {
        globals = { 'vim' },
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true),
      },
    },
  }
})
-- :lua vim.diagnostic.open_float() on warning lines gives explain

-- 2. Simply enable the server natively
vim.lsp.enable('lua_ls')

require('catppuccin').setup({ flavour = 'mocha' })
local mini_icons = require('mini.icons')
mini_icons.setup({})
-- This tells Neovim to use mini.icons whenever a plugin asks for devicons
mini_icons.mock_nvim_web_devicons()
require('mini.basics').setup()
require('mini.hues').setup({
  background = '#19213a',
  foreground = '#c4c6cd',
  saturation = 'medium',
  accent = 'blue'
})
require('mini.align').setup()
require('mini.git').setup()
require('mini.diff').setup()
require('mini.starter').setup()
require('mini.files').setup()
require('mini.pick').setup()
require('mini.cmdline').setup()
require('mini.extra').setup()
require('mini.tabline').setup()
require('mini.surround').setup()
require('mini.comment').setup()
require('mini.misc').setup()
MiniMisc.setup_restore_cursor()
MiniMisc.setup_auto_root()
MiniMisc.setup_termbg_sync()
require('mini.animate').setup()
require('mini.trailspace').setup()
-- -----------------------------------------------------------
-- Block for mini.snippets configuration in pack.lua
-- -------------------------------------------------------
local gen_loader = require('mini.snippets').gen_loader

-- Resolve custom friendly-snippets path adaptively
local friendly_snippets_path =
    vim.fn.expand('~/.local/share/nvim-jm/site/pack/core/opt/friendly-snippets/snippets')

require('mini.snippets').setup({
  snippets = {
    -- 1. Load custom global snippets (with safely expanded path)
    gen_loader.from_file(vim.fn.expand('~/.config/nvim-jm/snippets/global.json')),

    -- 2. Load the standard runtimepath snippets
    gen_loader.from_lang(),

    -- 3. Load localized friendly-snippets matching the active buffer language
    gen_loader.from_lang({ path = friendly_snippets_path }),
  },
})

-- CRITICAL: Expose loaded snippets to mini.completion / native menus via LSP
require('mini.snippets').start_lsp_server()

-- Active completion layout
require('mini.completion').setup()

-- -----------------------------------------------------------
-- Block for mini.clue configuration
-- ------------------------------------------------------------
local miniclue = require('mini.clue')
miniclue.setup({
  triggers = {
    -- Leader triggers
    { mode = { 'n', 'x' }, keys = '<Leader>' },
    -- `[` and `]` keys
    { mode = 'n',          keys = '[' },
    { mode = 'n',          keys = ']' },
    -- Built-in completion
    { mode = 'i',          keys = '<C-x>' },
    -- `g` key
    { mode = { 'n', 'x' }, keys = 'g' },
    -- Marks
    { mode = { 'n', 'x' }, keys = "'" },
    { mode = { 'n', 'x' }, keys = '`' },
    -- Registers
    { mode = { 'n', 'x' }, keys = '"' },
    { mode = { 'i', 'c' }, keys = '<C-r>' },
    -- Window commands
    { mode = 'n',          keys = '<C-w>' },
    -- `z` key
    { mode = { 'n', 'x' }, keys = 'z' },
  },

  clues = {
    -- Enhance this by adding descriptions for <Leader> mapping groups
    miniclue.gen_clues.square_brackets(),
    miniclue.gen_clues.builtin_completion(),
    miniclue.gen_clues.g(),
    miniclue.gen_clues.marks(),
    miniclue.gen_clues.registers(),
    miniclue.gen_clues.windows(),
    miniclue.gen_clues.z(),
  },
})

-- **********************************************************************
-- Block for statusline
-- **********************************************************************
require('mini.statusline').setup({
  content = {
    active = function()
      -- 1. Single letter mode formatting
      local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 120 })
      local mode_map      = {
        ['Normal']   = 'N',
        ['Insert']   = 'I',
        ['Visual']   = 'V',
        ['V-Line']   = 'VL',
        ['V-Block']  = 'VB',
        ['Replace']  = 'R',
        ['Command']  = 'C',
        ['Terminal'] = 'T',
      }
      -- Apply mapping if it exists, otherwise fallback to first letter
      mode                = mode_map[mode] or mode:sub(1, 1)

      -- 2. Fetch other standard sections
      local git           = MiniStatusline.section_git({ trunc_width = 40 })
      local diff          = MiniStatusline.section_diff({ trunc_width = 75 })
      local diagnostics   = MiniStatusline.section_diagnostics({ trunc_width = 75 })
      local location      = MiniStatusline.section_location({ trunc_width = 90 })

      -- FIXED: Changed 'section_searchfunc' to 'section_search'
      local search        = MiniStatusline.section_searchcount({ trunc_width = 75 })

      -- 3. Truncate filename (using 'short' to only show filename)
      local filename      = MiniStatusline.section_filename({ trunc_width = 140 })

      -- 4. Strip fileencoding out of section_fileinfo
      local fileinfo      = MiniStatusline.section_fileinfo({ trunc_width = 120 })
      -- Clean it up using string manipulation to remove encoding (e.g., "[utf-8]")
      fileinfo            = fileinfo:gsub("%s*%[.-%]%s*", "")

      -- 5. Combine and return the minimal statusline string
      return MiniStatusline.combine_groups({
        { hl = mode_hl,                 strings = { mode } },
        { hl = 'MiniStatuslineDevinfo', strings = { git, diff, diagnostics } },
        '%<', -- Mark where to truncate the line if window is too narrow
        { hl = 'MiniStatuslineFilename', strings = { filename } },
        '%=', -- Right-align alignment separator
        { hl = 'MiniStatuslineFileinfo', strings = { fileinfo } },
        { hl = mode_hl,                  strings = { search, location } },
      })
    end
  }
})


-- ****************************************************************************
-- Custom Markdown Folding Engine (Replaces the broken built-in one)
_G.markdown_fold_expr = function(lnum)
  local line = vim.fn.getline(lnum)
  -- If the line starts with 1 to 6 '#' characters followed by a space, it's a header
  if line:match("^#+%s") then
    -- Return '>' followed by the number of '#' characters to set the fold level
    local _, heading_depth = line:find("^#+")
    return ">" .. heading_depth
  end
  -- For all other lines (text, tables, lists), just keep the current fold level
  return "="
end

-- Force our custom engine to load on Markdown files
vim.api.nvim_create_autocmd({ "BufWinEnter", "BufEnter" }, {
  pattern = "*.md",
  callback = function()
    vim.schedule(function()
      if vim.bo.filetype == "markdown" then
        vim.opt_local.foldmethod = 'expr'
        vim.opt_local.foldexpr = 'v:lua.markdown_fold_expr(v:lnum)'
        vim.opt_local.foldlevel = 99
      end
    end)
  end,
})

-- ****************************************************************************
-- *  sniprun setup    ************
-- ****************************************************************************
-- Initialize sniprun
require'sniprun'.setup({
  -- Custom options can go here, but defaults work seamlessly out of the box
  selected_interpreters = {},     -- Use all available interpreters
  repl_enable = {},               -- Enabled REPL-like behaviors for supported languages
  
  -- The display mode for the code output (e.g., Virtual Text, Floating Window)
  display = {
    "Classic",                    -- Echoes in the command line
    "VirtualTextOk",              -- Shows inline results for successful runs
  },
})

-- Handy Keymaps for your sandbox
-- Map to run the current line or visual selection
vim.keymap.set('n', '<leader>ff', '<cmd>SnipRun<cr>',
  { silent = true, desc = "Run current line" })
vim.keymap.set('v', '<leader>ff', ':<C-U>SnipRun<cr>',
  { silent = true, desc = "Run visual selection" })
vim.keymap.set('n', '<leader>fc', '<cmd>SnipReset<cr>',
  { silent = true, desc = "Reset sniprun REPL/cache" })

