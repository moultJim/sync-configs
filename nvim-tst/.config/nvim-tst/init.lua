local shared_config = vim.fn.expand("~/.config/nvim")
local shared_data = vim.fn.expand("~/.local/share/nvim")

-- 1. Explicitly prepend the main config folder to the Runtime Path
vim.opt.rtp:prepend(shared_config)

-- 2. Dynamically find all actual plugin directories in your main nvim data folder
local plugin_paths = vim.fn.glob(shared_data .. "/site/pack/*/*/*", false, true)

for _, path in ipairs(plugin_paths) do
    if vim.fn.isdirectory(path) == 1 then
        -- Add to Neovim's runtime path so vim commands, docs, and configurations work
        vim.opt.rtp:append(path)
        
        -- Add to Lua's package path so require() works perfectly
        package.path = package.path .. ";" .. path .. "/lua/?.lua;" .. path .. "/lua/?/init.lua"
    end
end

-- 3. Add your main shared lua directory to the package path
package.path = package.path .. ";" .. shared_config .. "/lua/?.lua;" .. shared_config .. "/lua/?/init.lua"

-- 4. Execute the shared root init.lua file
vim.cmd("source " .. shared_config .. "/init.lua")

