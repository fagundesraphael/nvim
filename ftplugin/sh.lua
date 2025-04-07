local utils = require "lsp.utils"

local root_files = { ".git" }
local paths = vim.fs.find(root_files, { stop = vim.env.HOME })
local root_dir = paths[1] and vim.fs.dirname(paths[1]) or vim.fn.getcwd()

if root_dir then
  vim.lsp.start {
    name = "bashls",
    cmd = { "bash-language-server", "start" },
    filetypes = { "sh", "zsh", "bash" },
    root_dir = root_dir,
    capabilities = utils.capabilities,
    on_attach = utils.on_attach,
  }
end
