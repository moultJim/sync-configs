-- vim.keymap.set(modes, lhs, rhs, opts)
-- modes single string or table (e.g., {"n", "v"})
-- "x" is visual only; "v" visual and select
-- "i" insert; "c" command; "" all modes
-- lhs left hand side: keys pressed
-- rhs rght hand side: action: cmds  or keys

-- ***CONROL***
vim.keymap.set("n", "<leader>re", "<cmd>restart<cr>", { desc = "Restart" })
vim.keymap.set(
  "n",
  "<leader>up",
  function()
    vim.pack.update()
  end,
  { desc = "Update plugins" }
)
vim.keymap.set('i', 'jj', '<Esc>', { desc = 'Exit ins mode' })

-- ***GENERAL EDIT - NORMAL MODE***
-- Delete w/o yanking: Handles counts (e.g., <leader>2d deletes 2 lines)
vim.keymap.set('n', '<leader>d', function()
  return '"_' .. vim.v.count1 .. 'd'
end, { expr = true, desc = "Del line(s) w/o yank" })
-- Delete character w/o yanking
vim.keymap.set('n', 'x', '"_x', { desc = "Delete char w/o yank" })
-- Change text w/o yanking (handles counts like <leader>2c)
vim.keymap.set('n', '<leader>c', function()
  return '"_' .. vim.v.count1 .. 'c'
end, { expr = true, desc = "Change w/o yank" })
-- Change full line w/o yanking (handles counts like <leader>2cc)
vim.keymap.set('n', '<leader>cc', function()
  return '"_' .. vim.v.count1 .. 'S'
end, { expr = true, desc = "Change line w/o yank" })
-- (Note: For <leader>cc, using S behind the scenes is a clean Vim trick
-- to clear line and enter insert mode while respecting counts perfectly).
vim.keymap.set("n", "<leader>mj", "m .+1<CR>==", { desc = "Move line down 1" })
vim.keymap.set("n", "<leader>mk", "m .-2<CR>==", { desc = "Move line up 1" })

-- ***EDIT - VISUAL MODE***
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "move lines dwn in vis select" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "move lines up in vis select" })
vim.keymap.set("v", "<", "<gv", { desc = "Unindent and keep select" })
vim.keymap.set("v", ">", ">gv", { desc = "Indent and keep select" })
vim.keymap.set("x", "p", [["_dP]], { desc = "Paste over select w/o losing yank" })
vim.keymap.set('v', '<leader>d', '"_d', { desc = "Delete selec w/o yank" })
-- Delete visual selection character-wise without yanking
vim.keymap.set('v', 'x', '"_x', { desc = "Delete select w/o yank" })

-- Change visual selection without yanking
vim.keymap.set('v', '<leader>c', '"_c', { desc = "Change select w/o yank" })

-- ***NAVIGATION***
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "scroll dwn 1/2 pg, & center" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "scroll up 1/2 pg, & center" })
vim.keymap.set("n", "H", "^", { desc = "go to non-blank start of line" })
vim.keymap.set("n", "L", "$", { desc = "go to end of line" })

--***SEARCH***
vim.keymap.set("n", "n", "nzzzv", { desc = "Next search result cursor centered" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous search result cursor centered" })
vim.keymap.set(
  "n",
  "<leader>s",
  [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
  { desc = "Replace word cursor is on globally" }
)
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlights" })

-- ***FILES***
vim.keymap.set("n", "<leader>w", "<cmd>w<CR>", { desc = "Quick save buffer" })
vim.keymap.set(
  "n",
  "<leader>cx",
  "<cmd>!chmod +x %<CR>",
  { silent = true, desc = "makes file executable" }
)
