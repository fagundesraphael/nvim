local fzf = require "fzf-lua"

fzf.setup {
  winopts = {
    height = 0.85,
    width = 0.87,
  },
  keymap = {
    builtin = {
      ["<C-u>"] = "preview-page-up",
      ["<C-d>"] = "preview-page-down",
    },
    fzf = {
      ["ctrl-q"] = "abort",
      ["ctrl-u"] = "preview-half-page-up",
      ["ctrl-d"] = "preview-half-page-down",
    },
  },
  fzf_opts = {
    ["--layout"] = "default",
    ["--info"] = "default",
  },
}

return fzf
