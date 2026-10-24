-- enable faster startup by caching compiled lua modules
vim.loader.enable()
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- 1. Load your package configurations FIRST so plugins establish their variables
require("pack")

-- 2. Load your custom environment settings and mappings
require("options")
require("keymaps")

-- 3. Load your autocommands LAST so they have the definitive final word over plugins
require("autocmds")

