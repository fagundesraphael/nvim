local utils = require "lsp.utils"

local root_files = { "Cargo.toml", ".git" }
local paths = vim.fs.find(root_files, { stop = vim.env.HOME })
local root_dir = paths[1] and vim.fs.dirname(paths[1]) or vim.fn.getcwd()

if root_dir then
  vim.lsp.start {
    name = "rust_analyzer",
    cmd = { "rust-analyzer" },
    filetypes = { "rust" },
    root_dir = root_dir,
    capabilities = utils.capabilities,
    settings = {
      ["rust-analyzer"] = {
        checkOnSave = { command = "clippy" },
        cargo = { allFeatures = true },
        procMacro = { enable = true },
        diagnostics = {
          enable = true,
          experimental = { enable = true },
        },
        inlayHints = {
          typeHints = { enable = false },
          parameterHints = { enable = true },
          chainingHints = { enable = true },
        },
      },
    },
    on_attach = utils.on_attach,
  }
end
