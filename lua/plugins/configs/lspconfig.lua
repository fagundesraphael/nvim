local M = {}
local map = vim.keymap.set

-- export on_attach & capabilities
M.on_attach = function(_, bufnr)
  local function opts(desc)
    return { buffer = bufnr, desc = "LSP " .. desc }
  end

  map("n", "gD", vim.lsp.buf.declaration, opts "Go to declaration")
  map("n", "gd", vim.lsp.buf.definition, opts "Go to definition")
  map("n", "K", vim.lsp.buf.hover, opts "Hover")
  map("n", "gi", vim.lsp.buf.implementation, opts "Go to implementation")
  map("n", "<leader>h", vim.lsp.buf.signature_help, opts "Show signature help")
  map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts "Add workspace folder")
  map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts "Remove workspace folder")

  map("n", "<leader>wl", function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, opts "List workspace folders")

  map(
    { "n" },
    "<leader>lf",
    "<cmd>lua vim.diagnostic.open_float { border = 'rounded' }<CR>",
    { desc = "Floating diagnostic" }
  )

  map("n", "<leader>D", vim.lsp.buf.type_definition, opts "Go to type definition")

  map("n", "<leader>ra", vim.lsp.buf.rename, opts "Rename")
  map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts "Code action")
  map("n", "gr", vim.lsp.buf.references, opts "Show references")
end

-- disable semanticTokens
M.on_init = function(client, _)
  if client.supports_method "textDocument/semanticTokens" then
    client.server_capabilities.semanticTokensProvider = nil
  end
end

M.capabilities = vim.lsp.protocol.make_client_capabilities()

M.capabilities.textDocument.completion.completionItem = {
  documentationFormat = { "markdown", "plaintext" },
  snippetSupport = true,
  preselectSupport = true,
  insertReplaceSupport = true,
  labelDetailsSupport = true,
  deprecatedSupport = true,
  commitCharactersSupport = true,
  tagSupport = { valueSet = { 1 } },
  resolveSupport = {
    properties = {
      "documentation",
      "detail",
      "additionalTextEdits",
    },
  },
}

M.defaults = function()
  local lspconfig = require "lspconfig"

  lspconfig.lua_ls.setup {
    on_attach = M.on_attach,
    capabilities = M.capabilities,
    on_init = M.on_init,

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
  }

  local function organize_imports()
    local params = {
      command = "_typescript.organizeImports",
      arguments = { vim.api.nvim_buf_get_name(0) },
    }
    vim.lsp.buf.execute_command(params)
  end

  lspconfig.ts_ls.setup {
    on_attach = M.on_attach,
    capabilities = M.capabilities,
    on_init = M.on_init,
    init_options = {
      preferences = {
        disableSuggestions = true,
      },
    },
    commands = {
      OrganizeImports = {
        organize_imports,
        description = "Organize Imports",
      },
    },
  }

  lspconfig.clangd.setup {
    on_attach = M.on_attach,
    on_init = M.on_init,
    capabilities = vim.tbl_extend("keep", M.capabilities, {
      offsetEncoding = "utf-16",
    }),
    cmd = { "clangd" },
    filetypes = { "c", "cpp", "objc", "objcpp" },
    root_dir = lspconfig.util.root_pattern("compile_commands.json", "compile_flags.txt", ".git"),
    init_options = {
      compilationDatabaseDirectory = "build",
      index = {
        threads = 0,
      },
    },
  }

  -- lspconfig.jedi_language_server.setup {
  --   on_attach = M.on_attach,
  --   capabilities = M.capabilities,
  --   on_init = M.on_init,
  --   settings = {
  --     jedi = {
  --       completion = {
  --         disableSnippets = false,
  --         fuzzy = true,
  --       },
  --       diagnostics = {
  --         enable = true,
  --       },
  --     },
  --   },
  -- }

  lspconfig.basedpyright.setup {
    on_attach = M.on_attach,
    capabilities = M.capabilities,
    on_init = M.on_init,
    settings = {
      basedpyright = {
        analysis = {
          autoSearchPaths = true,
          diagnosticMode = "openFilesOnly",
          useLibraryCodeForTypes = true,
          typeCheckingMode = "standard",
          autoImportCompletions = true,
          reportUnusedImport = "information",
          reportUnusedFunction = "information",
          reportUnusedVariable = "information",
          reportOptionalMemberAccess = "none",
          reportOptionalSubscript = "warning",
          reportPrivateImportUsage = "none",
          reportUnusedParameter = "default",
          reportAny = "default",
        },
      },
    },
  }

  -- setup multiple servers with same default options
  require("java").setup {}
  local servers = {
    "bashls",
    "cssls",
    "html",
    "jsonls",
    "jdtls",
    "gopls",
    "yamlls",
    "lemminx",
  }

  for _, lsp in ipairs(servers) do
    lspconfig[lsp].setup {
      on_attach = M.on_attach,
      capabilities = M.capabilities,
      on_init = M.on_init,
    }
  end
end

return M
