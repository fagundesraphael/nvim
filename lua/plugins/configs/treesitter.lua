require("nvim-treesitter.configs").setup {
  ensure_installed = {
    -- defaults
    "vim",
    "lua",
    "vimdoc",

    -- web dev
    "html",
    "css",
    "javascript",
    "typescript",
    "tsx",

    -- low level
    "c",
    "zig",
    "rust",
    "cpp",

    -- others
    "python",
    "json",
    "yaml",
    "toml",
    "jsonc",
    "bash",
    "go",
    "java",
    "regex",
    "c_sharp",
    "sql",
  },

  highlight = {
    enable = true,
    use_languagetree = true,
  },
  folding = {
    enable = true,
  },
  indent = { enable = true },
}
