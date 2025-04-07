vim.api.nvim_create_user_command("MasonInstallAll", function()
  vim.cmd " MasonInstall xmlformatter black codelldb debugpy eslint_d goimports golines js-debug-adapter prettierd stylua djlint golangci-lint yamlfmt "
end, {})
