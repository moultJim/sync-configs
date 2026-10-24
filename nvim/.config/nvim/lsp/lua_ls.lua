return {
  settings = {
    Lua = { 
      runtime = { version = "LuaJIT" },
      workspace = { 
        checkThirdParty = false,
        library = vim.api.nvim_get_runtime_file("", true),
      },
      diagnostics = { globals = { "vim" } },
    },
  },
  -- Triggered when LUA_LS attaches to a buffer
  on_attach = function(client, bufnr)
    -- Map <leader>f to format manually via lsp
    vim.keymap.set("n", "<leader>f", function()
      vim.lsp.buf.format({ bufnr = bufnr, id = client.id, async = true }) 
    end, { buffer = bufnr, desc = "LSP: Format buffer w/StyLua" })

    -- formats the code natively on save
    vim.api.nvim_create_autocmd("BufWritePre", {
      buffer = bufnr,
      callback = function()
        vim.lsp.buf.format({ bufnr = bufnr, id = client.id, async = false })
      end,
    })
  end,
}
