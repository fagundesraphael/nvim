-- mason, write correct names only

vim.api.nvim_create_user_command("MasonInstallAll", function()
  vim.cmd "MasonInstall css-lsp html-lsp lua-language-server black clang-format codelldb debugpy eslint_d gopls goimports golines gopls isort js-debug-adapter lua-language-server prettier prettierd jedi-language-server ruff stylua typescript-language-server clangd pyright autopep8 jdtls "
end, {})
