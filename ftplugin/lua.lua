local utils = require "lsp.utils"

local root_files = { ".git", ".luarc.json", ".luacheckrc", "stylua.toml", ".stylua.toml" }
local paths = vim.fs.find(root_files, { stop = vim.env.HOME })
local root_dir = paths[1] and vim.fs.dirname(paths[1]) or vim.fn.getcwd()

if root_dir then
  vim.lsp.start {
    name = "lua_ls",
    cmd = { "lua-language-server" },
    filetypes = { "lua" },
    root_dir = root_dir,
    capabilities = utils.capabilities,
    settings = {
      Lua = {
        diagnostics = {
          globals = { "vim" },
        },
        workspace = {
          library = {
            vim.fn.expand "$VIMRUNTIME/lua",
            vim.fn.expand "$VIMRUNTIME/lua/vim/lsp",
          },
          maxPreload = 100000,
          preloadFileSize = 10000,
        },
      },
    },
    on_attach = utils.on_attach,
  }
end
