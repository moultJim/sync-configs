-- ********************************************************
-- * Save and run the current Lua file in a bottom split. *
-- ********************************************************
-- Automatically returns your focus to the code block so you
--  don't get trapped in the terminal buffer.
vim.keymap.set('n', '<leader>rx', function()
  -- Force write the lesson file so the changes register
  vim.cmd('silent! write')
  -- Use mini.misc to find the root or just execute directly
  local current_file = vim.fn.expand('%:p')
  -- Open a terminal at the bottom, 12 rows high
  vim.cmd('botright 12split | terminal lua "' .. current_file .. '"')
  -- Fall back to Normal mode instantly so ChromeOS doesn't
  --  hijack terminal insert mode bindings
  vim.cmd('wincmd p') 
end, { desc = '[R]un e[X]ternal Lua Lesson' })

-- **********************************************************
-- * Open floating execution window to run code             *
-- * Track running state and buffer of execution window     *
-- **********************************************************
local run_win = nil
local run_buf = nil

vim.keymap.set('n', '<leader>rx', function()
  -- Automatically write any pending lesson edits
  vim.cmd('silent! write')
  
  local current_file = vim.fn.expand('%:p')

  -- Clean up the buffer if it already exists to avoid
  --  stacking hidden terminal instances
  if run_buf and vim.api.nvim_buf_is_valid(run_buf) then
    vim.api.nvim_buf_delete(run_buf, { force = true })
  end

  -- Calculate custom dimensions for a centered layout
  local width = math.ceil(vim.o.columns * 0.8)
  local height = math.ceil(vim.o.lines * 0.7)
  local row = math.ceil((vim.o.lines - height) / 2)
  local col = math.ceil((vim.o.columns - width) / 2)

  -- 1. Create a raw scratch buffer
  run_buf = vim.api.nvim_create_buf(false, true)

  -- 2. Spawn the floating window housing that buffer
  run_win = vim.api.nvim_open_win(run_buf, true, {
    relative = 'editor',
    width = width,
    height = height,
    row = row,
    col = col,
    style = 'minimal',
    border = 'rounded',
    title = ' Lesson Output ',
    title_pos = 'center',
  })

  -- 3. Run system interpreter inside this floating buffer
  vim.fn.termopen('lua "' .. current_file .. '"')

  -- 4. Target the specific bufnr to map an escape sequence
  --      that Chrome cannot hijack.
  -- Pressing <Space><Space> inside the floating terminal
  --      instantly pops you back to code editing.
  vim.keymap.set('t', '<Space><Space>', function()
    if run_win and vim.api.nvim_win_is_valid(run_win) then
      vim.api.nvim_win_close(run_win, true)
    end
  end, { buffer = run_buf, desc = 'Close lesson float cleanly' })

  -- Drop automatically into Terminal execution mode 
  vim.cmd('startinsert')
end, { desc = '[R]un e[X]ternal Lua Lesson' })

