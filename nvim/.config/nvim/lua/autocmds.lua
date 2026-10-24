-- Basic autocommands
local augroup = vim.api.nvim_create_augroup("UserConfig", {})
-- Create an autocommand group for help window management
local help_group = vim.api.nvim_create_augroup(
  "HelpWindowManagement",
  { clear = true })


-- vim.api.nvim_create_autocmd("BufReadPost", {
--   group = restore_group,
--   desc = "Restore last known cursor position safely after plugins idle",
--   callback = function(opts)
--     local exclude = { "gitcommit", "gitrebase", "commit" }
--     if vim.tbl_contains(exclude, vim.bo[opts.buf].filetype) then
--       return
--     end
--
--     local mark = vim.api.nvim_buf_get_mark(opts.buf, '"')
--     local row = mark[1]
--     local lcount = vim.api.nvim_buf_line_count(opts.buf)
--
--     if row > 1 and row <= lcount then
--       vim.schedule(function()
--         if vim.api.nvim_buf_is_valid(opts.buf) then
--           pcall(vim.api.nvim_win_set_cursor, 0, mark)
--           vim.cmd("normal! zvzz")
--         end
--       end)
--     end
--   end,
-- })

  -- Don't autocomment next line after comment
vim.api.nvim_create_autocmd("BufEnter", {
  callback = function()
-- "r" is auto after <cr>; "o" after o or O ins; "c" is for hard-wraps
    vim.opt.formatoptions:remove({ "c", "r", "o" })
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = help_group,
  pattern = "help",
  callback = function()
    -- Record the ID of the window you came from
    local original_win = vim.fn.win_getid(vim.fn.winnr('#'))
    
    -- Map 'q' inside this specific help buffer to close it and jump back
    vim.keymap.set("n", "q", function()
      -- Close the help window
      vim.cmd("q")
      -- If the original window is still valid, return focus to it
      if vim.api.nvim_win_is_valid(original_win) then
        vim.api.nvim_set_current_win(original_win)
      end
    end, { buffer = true, silent = true,
      desc = "Close help and return to previous window" }
    )
  end,
})

-- Global Terminal Quality-of-Life Autocommands
local term_group = vim.api.nvim_create_augroup("GlobalTerminalSettings", { clear = true })

vim.api.nvim_create_autocmd({ "TermOpen", "BufEnter" }, {
    group = term_group,
    pattern = "term://*",
    callback = function()
        if vim.bo.buftype == "terminal" then
            -- 1. Distraction-free UI adjustments
            vim.opt_local.number = false
            vim.opt_local.relativenumber = false
            vim.opt_local.signcolumn = "no"
            
            -- 2. Force-inject the toggle-out keymap directly inside this specific terminal buffer
            -- This overrides any environment/Chromebook key swallowing.
            local bufnr = vim.api.nvim_get_current_buf()
            vim.keymap.set("t", "<space>tt", function()
                -- Drop out of Terminal mode into Normal mode instantly
                vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-\\><C-n>", true, false, true), "n", false)
                -- Force hide the floating window via the user command we made
                vim.cmd("Floaterminal")
            end, { buffer = bufnr, desc = "Toggle terminal from within" })

            -- 3. Automatically jump into insert mode
            vim.cmd("startinsert")
        end
    end,
})

