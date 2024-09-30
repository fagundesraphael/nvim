require("lint").linters_by_ft = {
  javascript = { "eslint" },
  typescript = { "eslint" },
  javascriptreact = { "eslint" },
  typescriptreact = { "eslint" },
  python = { "flake8" },
  django = { "djlint" },
  go = {
    "golangcilint",
  },
}
-- require("lint").linters.flake8.args = { "--ignore=E501" }

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
  callback = function()
    require("lint").try_lint()
  end,
})
