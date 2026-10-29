vim.g.markdown_folding = 1
-- Set folding to calculate based on an expression


-- Hard wrapping - at 80 characters, and treat list items nicely
vim.opt_local.formatoptions:append({ "t", "r" })
vim.opt_local.textwidth = 80

-- 1. Structural Logic: Group tables and text under headers

--
--   -- Count the '#' characters at the start of the line
--   local _, count = line:gsub("^#+", "")
--   if count > 0 then
--     return ">" .. count  -- Starts a fold at this header level (e.g., >2)
--   end
--
--   return "="  -- Stays at the current fold level
-- end
--
-- -- 2. Visual Logic: Keep the header visible when the fold closes
-- _G.MyMarkdownFoldText = function()
--   local line = vim.fn.getline(vim.v.foldstart)
--   local lines_count = vim.v.foldend - vim.v.foldstart + 1
--   return line .. "  ... (" .. lines_count .. " lines)"
-- end
--
-- vim.opt_local.foldtext = "v:lua.MyMarkdownFoldText()"


-- keymaps focused on markdown
-- Toggle conceallevel: 0 no conceal; 2 conceal bold/ital
vim.keymap.set('n', '<localleader>tc', function()
  if vim.opt_local.conceallevel:get() == 0 then
    vim.opt_local.conceallevel = 2
    print("Conceal level set to 2")
  else
    vim.opt_local.conceallevel = 0
    print("Conceal level set to 0")
  end
end, { buffer = true, desc = "Toggle [C]onceal level (0/2)" })
-- Re-align paragraph under cursor to match margin limits if a md file:
--    gq triggers internal formatter; ap = "around paragraph".
vim.keymap.set("n", "Q", "gqap",
  { buffer = true, desc = "Format current paragraph" })
-- Jump to next/previous markdown header
vim.keymap.set("n", "]]", [[:/^\s*#\+ /<CR>:nohlsearch<CR>]],
  { buffer = true, silent = true, desc = "Next header" })
vim.keymap.set("n", "[[", [[:?^\s*#\+ ?<CR>:nohlsearch<CR>]],
  { buffer = true, silent = true, desc = "Previous header" })
-- Turn current line into a bullet point list item
vim.keymap.set("n", "<localleader>bl", "I- <Esc>",
  { buffer = true, desc = "Make list item" })

-- ****************************************************************************
-- Open glow with buffer in native vertical split window on right
-- ****************************************************************************
vim.keymap.set('n', '<localleader>p', function()
  local current_file = vim.api.nvim_buf_get_name(0)
  -- Open a vertical split, move cursor right, and start a terminal with glow
  vim.cmd('vsplit | wincmd l | terminal glow "' .. current_file .. '"')
  -- Force terminal into "Insert mode" so you can scroll or quit with 'q'
  vim.cmd('startinsert')
end, { buffer = true, desc = "Preview Markdown with glow" })
-- ****************************************************************************
-- Alt keymap to pipe current buffer to glow floating terminal window
-- ****************************************************************************
vim.keymap.set(
  'n', '<localleader>mp', ':TermExec cmd="glow %"<CR>',
  { buffer = true, desc = "Preview with Glow" }
)

-- ****************************************************************************
-- Keymap to align a markdown table (using mini.align)
-- ****************************************************************************
-- Assumes table surrounded by empty lines; cursor inside table; Normal Mode
vim.keymap.set(
  'n',
  '<localleader>ta',
  function()
    -- Feed keys for: ga (align) + ip (inner paragraph) + s (split) + | (pipe)
    -- + (confirm)
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(
        'gaips|',
        true,
        false,
        true
      ),
      'm',
      true
    )
  end,
  { buffer = true, desc = 'Align Markdown table' }
)

-- ****************************************************************************
-- Alternative table alignment using column command
-- ****************************************************************************
vim.keymap.set(
  'v',
  '<localleader>mt',
  ":!column -t -s '|' -o '|'<CR>",
  { buffer = true, silent = true, desc = "Format table via system column" }
)

-- ****************************************************************************
-- Insert 3-column table skeleton in insert mode
-- ****************************************************************************
vim.keymap.set(
  'i',
  '<localleader>m3',
  [[| Head1 | Head2 | Head3 |<CR>|:--- |:--- |:--- |<CR>| | | |]],
  { buffer = true, desc = "Insert markdown table-3 skeleton" }
)

-- ****************************************************************************
-- Insert 2-column table skeleton in insert mode
-- ****************************************************************************
vim.keymap.set(
  'i',
  '<localleader>m2',
  [[| Head1 | Head2 | <CR>|:--- |:--- |<CR>| | |]],
  { buffer = true, desc = "Insert markdown table-2 skeleton" }
)

-- ********************************************************
-- Function & keymap: jump to next Markdown table cell
-- ********************************************************
local function jump_to_next_cell()
  -- Refined pattern: Finds a pipe, followed by optional spaces,
  -- and targets the cell gap
  local pattern = [[|\s*]]
  local found = vim.fn.search(pattern, 'W')
  if found > 0 then
    -- Move cursor past the matched pipe and its immediately following space
    local col = vim.fn.col('.')
    local match_len = vim.fn.matchstr(
      vim.fn.getline('.'),
      pattern,
      col - 1):len()
    vim.fn.cursor(vim.fn.line('.'), col + match_len)
    vim.cmd('startinsert')
  end
end

vim.keymap.set(
  'i',
  '<C-j>',
  jump_to_next_cell,
  { buffer = true, silent = true, desc = "Jump to next table cell" }
)

-- ********************************************************
-- Add new row to table, duplicating current cell structure
-- ********************************************************
local function add_blank_row_below()
  local current_line = vim.fn.getline('.')
  -- Count how many columns/pipes are in the current line
  local _, pipe_count = string.gsub(current_line, "|", "")
  -- If not inside a table row, drop down a standard line safely
  if pipe_count < 2 then
    vim.api.nvim_put({ "" }, "l", true, true)
    vim.cmd('startinsert!')
    return
  end
  -- Build blank row matching structural layout (e.g., "|  |  |")
  local new_row = "|" .. string.rep("  |", pipe_count - 1)
  local row_num = vim.fn.line('.')
  vim.fn.append(row_num, new_row)
  -- Safely target the first cell interior (Column 3)
  vim.fn.cursor(row_num + 1, 3)
  vim.cmd('startinsert')
end
vim.keymap.set(
  'i',
  '<C-o>',
  add_blank_row_below,
  { buffer = true, silent = true, desc = "Add new blank table row below" })



-- ------------------------------------------------------------------------
-- **************  Text objects - chapters/code blocks ********************
-- ------------------------------------------------------------------------
-- Define chapter: heading and following to next equal/higher heading or EOF
-- Define code block: everything between two ``` lines
-- Operating on text objects uses c/d/y/gq/etc. cmd and i(nner) and a(round)
-- Via vim handlers for visual mode (xmap) and operator-pending mode (omap)
-- To create a custom text obj. is to register a function for both xmap & omap
-- i(nner) excludes delimiters; a(round) includes them
-- Algorithm: from cursor, go upward to find delim (recording level if heading);
--    then down to find boundary. i.e., start from anywhere inside aimed object
-- Once defined, ih and ah are used with operator
local M = {}

function M.select_chapter(around)
  -- standard lua, buf or buffer is idiomatic for object, string or file handle.
  -- neovim lua, bufnr, buf, or buf_id idiomatic for integer pointing to txt buf
  -- bufnr has tradition in nvim because of vimscript bufnr() built in,
  --  but buf or buf_id would be truer to standard lua coding
  local bufnr = 0
  -- nvim_win_get_cursor({integer}) current window is 0
  local cursor = vim.api.nvim_win_get_cursor(0)
  -- Cursor({lnum}, {col} [,{offset}])
  local row = cursor[1]
  -- vim.api.nvim_buf_get_lines({buf}, {start}, {end}, {indexing})
  -- 0 for start means current line
  -- -1 for end means index past last line(?)
  -- false for indexing means out-of-bounds not an error(?)
  -- vim.api.nvim_buf_get_lines(0,0,-1,false) idiomatic for get entire buffer
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  -- hash in front of a variable is the length operator
  --  returning # of characters in a string or # of items in an array/table
  local total = #lines

  -- Now find heading at or above cursor
  local start_row = nil
  local heading_level = nil
  for i = row, 1, -1 do
    -- match("^(#)%s") specifies start of line #s and %s whitespace following
    local m = lines[i]:match("^(#+)%s")
    if m then
      start_row = i
      heading_level = #m
      break
    end
  end
  if not start_row then return end

  -- Find the end: next heading of same or higher level, or EOF
  local end_row = total
  for i = start_row + 1, total do
    local m = lines[i]:match("^(#+)%s")
    if m and #m <= heading_level then
      end_row = i - 1
      while end_row > start_row and lines[end_row]:match("^%s*$") do
        end_row = end_row - 1
      end
      break
    end
  end

  local sel_start = around and start_row or start_row + 1
  if sel_start > end_row then sel_start = end_row end

  vim.cmd("normal! \27")
  vim.api.nvim_win_set_cursor(0, { sel_start, 0 })
  vim.cmd("normal! V")
  vim.api.nvim_win_set_cursor(0, { end_row, 0 })
end

-- Codeblock text object
-- ac and ic will be around and inner motions
-- algorithm is walking up to find opening code fence, then down to find close
-- opening fences found as odd-number; closing as even

function M.select_codeblock(around)
  local bufnr = 0
  local cursor = vim.api.nvim_win_get_cursor(0)
  local row = cursor[1]
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local total = #lines

  local fence_open = nil
  for i = row, 1, -1 do
    if lines[i]:match("^```") then
      local count = 0
      for j = 1, i do
        if lines[j]:match("^```") then count = count + 1 end
      end
      if count % 2 == 1 then
        fence_open = i
        break
      end
    end
  end
  if not fence_open then return end

  local fence_close = nil
  for i = fence_open + 1, total do
    if lines[i]:match("^```") then
      fence_close = i
      break
    end
  end
  if not fence_close then return end

  local sel_start = around and fence_open or fence_open + 1
  local sel_end = around and fence_close or fence_close - 1
  if sel_start > sel_end then sel_start = sel_end end

  vim.cmd("normal! \27")
  vim.api.nvim_win_set_cursor(0, { sel_start, 0 })
  vim.cmd("normal! V")
  vim.api.nvim_win_set_cursor(0, { end_row, 0 })
end

vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    local opts = { buffer = true, silent = true }
    vim.keymap.set("x", "ih", function()
      M.select_chapter(false)
    end, opts)
    vim.keymap.set("x", "ah", function()
      M.select_chapter(true)
    end, opts)
    vim.keymap.set("o", "ih", function()
      M.select_chapter(false)
    end, opts)
    vim.keymap.set("o", "ah", function()
      M.select_chapter(true)
    end, opts)
    vim.keymap.set("x", "ic", function()
      M.select_codeblock(false)
    end, opts)
    vim.keymap.set("x", "ac", function()
      M.select_codeblock(true)
    end, opts)
    vim.keymap.set("o", "ic", function()
      M.select_codeblock(false)
    end, opts)
    vim.keymap.set("o", "ac", function()
      M.select_codeblock(true)
    end, opts)
  end,
})
