-- ~/.config/nvim/lua/plugins/treesitter.lua

-- Safe require check for the new rewrite structure
local status_ok, ts = pcall(require, "nvim-treesitter")
if not status_ok then
  return
end

-- Pin your runtime installation directory
ts.setup {
  install_dir = vim.fn.stdpath('data') .. '/site'
}

-- In the rewrite, you explicitly pass an array to install parsers
ts.install {
  "lua",
  "vim",
  "vimdoc",
  "query",
  "markdown",
  "markdown_inline",
  "bash",
  "regex"
}

-- Core Highlighting is now safely handled natively by Neovim.
-- To ensure treesitter highlighting starts up on your filetypes automatically:
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'lua', 'vim', 'markdown', 'bash' }, -- Add languages as needed
  callback = function()
    vim.treesitter.start()
  end,
})

-- Add a handy manual/automatic hook log indicator inside your existing treesitter.lua
vim.api.nvim_create_autocmd("User", {
  pattern = "TSUpdate",
  callback = function()
    vim.notify("Treesitter parsers compilation process triggered!", vim.log.levels.INFO)
  end,
})
