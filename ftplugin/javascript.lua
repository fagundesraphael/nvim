local utils = require "lsp.utils"

local root_files = { "package.json", "tsconfig.json", ".git" }
local paths = vim.fs.find(root_files, { stop = vim.env.HOME })
local root_dir = paths[1] and vim.fs.dirname(paths[1]) or vim.fn.getcwd()

if root_dir then
  vim.lsp.start {
    name = "ts_ls",
    cmd = { "typescript-language-server", "--stdio" },
    filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" },
    root_dir = root_dir,
    capabilities = utils.capabilities,
    init_options = {
      preferences = {
        disableSuggestions = true,
      },
    },
    handlers = {},
    on_attach = function(client, bufnr)
      utils.on_attach(client, bufnr)

      vim.api.nvim_buf_create_user_command(bufnr, "OrganizeImports", function()
        local params = {
          command = "_typescript.organizeImports",
          arguments = { vim.api.nvim_buf_get_name(0) },
        }
        vim.lsp.buf.execute_command(params)
      end, { desc = "Organize Imports" })
    end,
  }
end
