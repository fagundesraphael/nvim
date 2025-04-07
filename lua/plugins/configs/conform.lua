local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    javascript = { "prettierd" },
    typescript = { "prettierd" },
    javascriptreact = { "prettierd" },
    typescriptreact = { "prettierd" },
    -- python = function(bufnr)
    --   if require("conform").get_formatter_info("ruff_format", bufnr).available then
    --     return { "ruff_format" }
    --   else
    --     return { "isort", "black", "autopep8" }
    --   end
    -- end,
    python = { "black" },
    c = { "clang_format" },
    cpp = { "clang_format" },
    go = { "gofumpt", "gofmt", "golines" },
    yaml = { "yamlfmt" },
    xml = { "xmlformatter" },
  },
}

require("conform").setup(options)
