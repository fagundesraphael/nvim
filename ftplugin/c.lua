local utils = require "lsp.utils"

local root_files = { "compile_commands.json", "compile_flags.txt", ".git", ".clangd" }
local paths = vim.fs.find(root_files, { stop = vim.env.HOME })
local root_dir = paths[1] and vim.fs.dirname(paths[1]) or vim.fn.getcwd()

if root_dir then
  vim.lsp.start {
    name = "clangd",
    cmd = { "clangd" },
    filetypes = { "c", "cpp" },
    root_dir = root_dir,
    capabilities = vim.tbl_extend("keep", utils.capabilities, {
      offsetEncoding = "utf-16",
    }),
    init_options = {
      compilationDatabaseDirectory = "build",
      index = {
        threads = 0,
      },
    },
    on_attach = utils.on_attach,
  }
end
