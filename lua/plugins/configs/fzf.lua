local fzf = require "fzf-lua"

fzf.setup {
  winopts = {
    height = 0.85,
    width = 0.87,
    preview = {
      default = "bat",
      hidden = "nohidden",
    },
    border = true,
    borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
  },
  fzf_colors = {
    ["fg+"] = { "fg", "Comment" },
    ["bg+"] = { "bg", "Normal" },
    ["gutter"] = { "bg", "Normal" },
  },
  keymap = {
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
  cmd = {
    files = { "rg --files --hidden --follow --glob '!{.git,node_modules}/*'" },
    grep = { "rg" },
    live_grep = { "rg --hidden --follow" },
  },
}

return fzf
