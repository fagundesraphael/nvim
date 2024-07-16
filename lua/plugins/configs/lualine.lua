local lualine = require "lualine"
local devicons = require "nvim-web-devicons"

local conditions = {
  buffer_not_empty = function()
    return vim.fn.empty(vim.fn.expand "%:t") ~= 1
  end,
  hide_in_width = function()
    return vim.fn.winwidth(0) > 80
  end,
  check_git_workspace = function()
    local filepath = vim.fn.expand "%:p:h"
    local gitdir = vim.fn.finddir(".git", filepath .. ";")
    return gitdir and #gitdir > 0 and #gitdir < #filepath
  end,
}

-- Colors variant
local rose_pine_colors = {
  ["rose-pine"] = {
    base = "#191724",
    surface = "#1f1d2e",
    overlay = "#26233a",
    muted = "#6e6a86",
    subtle = "#908caa",
    text = "#e0def4",
    love = "#eb6f92",
    gold = "#f6c177",
    rose = "#ebbcba",
    pine = "#31748f",
    foam = "#9ccfd8",
    iris = "#c4a7e7",
    highlight_low = "#21202e",
    highlight_med = "#403d52",
    highlight_high = "#524f67",
  },
  ["rose-pine-moon"] = {
    base = "#232136",
    surface = "#2a273f",
    overlay = "#393552",
    muted = "#6e6a86",
    subtle = "#908caa",
    text = "#e0def4",
    love = "#eb6f92",
    gold = "#f6c177",
    rose = "#ea9a97",
    pine = "#3e8fb0",
    foam = "#9ccfd8",
    iris = "#c4a7e7",
    highlight_low = "#2a283e",
    highlight_med = "#44415a",
    highlight_high = "#56526e",
  },
  ["rose-pine-dawn"] = {
    base = "#faf4ed",
    surface = "#fffaf3",
    overlay = "#f2e9e1",
    muted = "#9893a5",
    subtle = "#797593",
    text = "#575279",
    love = "#b4637a",
    gold = "#ea9d34",
    rose = "#d7827e",
    pine = "#286983",
    foam = "#56949f",
    iris = "#907aa9",
    highlight_low = "#f4ede8",
    highlight_med = "#dfdad9",
    highlight_high = "#cecacd",
  },
}

local active_theme = vim.g.active_theme or "rose-pine"
local active_colors = rose_pine_colors[active_theme]

--  lualine config
local config = {
  options = {
    component_separators = "",
    section_separators = "",
    theme = {
      normal = { c = { fg = active_colors.text, bg = active_colors.highlight_low } },
      inactive = { c = { fg = active_colors.text, bg = active_colors.base } },
    },
  },
  sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_y = {},
    lualine_z = {},
    lualine_c = {},
    lualine_x = {},
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_y = {},
    lualine_z = {},
    lualine_c = {},
    lualine_x = {},
  },
}

-- left component
local function ins_left(component)
  table.insert(config.sections.lualine_c, component)
end

-- right component
local function ins_right(component)
  table.insert(config.sections.lualine_x, component)
end

ins_left {
  "mode",
  color = function()
    local mode_color = {
      n = active_colors.foam,
      i = active_colors.iris,
      v = active_colors.foam,
      [""] = active_colors.foam,
      V = active_colors.foam,
      c = active_colors.rose,
      no = active_colors.love,
      s = active_colors.gold,
      S = active_colors.gold,
      [""] = active_colors.gold,
      ic = active_colors.foam,
      R = active_colors.gold,
      Rv = active_colors.violet,
      cv = active_colors.love,
      ce = active_colors.love,
      r = active_colors.cyan,
      rm = active_colors.cyan,
      ["r?"] = active_colors.cyan,
      ["!"] = active_colors.love,
      t = active_colors.love,
    }
    -- return { fg = mode_color[vim.fn.mode()] }
    return { fg = mode_color[vim.fn.mode()], bg = active_colors.highlight_high, gui = "bold" }
  end,
}

ins_left {
  "filename",
  cond = conditions.buffer_not_empty,
  color = { fg = active_colors.muted, gui = "bold" },
  icons_enabled = true,
  symbols = {
    modified = " ",
    readonly = " ",
    unnamed = " [No Name]",
  },
  file_status = true,
  newfile_status = true,
  path = 0,
  shorting_target = 40,
  symbols = {
    modified = "[+]",
    readonly = "[-]",
    unnamed = "[No Name]",
  },
  fmt = function(str)
    local icon, color = devicons.get_icon_color(vim.fn.expand "%:t", vim.fn.expand "%:e")
    if icon then
      return icon .. " " .. str
    end
    return str
  end,
}

ins_left {
  "branch",
  icon = " ",
  color = { fg = active_colors.muted, gui = "bold" },
}

ins_left {
  "diff",
  symbols = { added = " ", modified = " ", removed = " " },
  diff_color = {
    added = { fg = active_colors.iris },
    modified = { fg = active_colors.iris },
    removed = { fg = active_colors.iris },
  },
  cond = conditions.hide_in_width,
}

ins_left {
  function()
    return "%="
  end,
}

ins_right {
  "diagnostics",
  sources = { "nvim_diagnostic" },
  symbols = { error = " ", warn = " ", info = " ", hint = " " },
  diagnostics_color = {
    error = { fg = active_colors.love },
    warn = { fg = active_colors.gold },
    info = { fg = active_colors.foam },
  },
}

ins_right {
  function()
    local msg = "No Active Lsp"
    local buf_ft = vim.api.nvim_buf_get_option(0, "filetype")
    local clients = vim.lsp.get_active_clients()
    if next(clients) == nil then
      return msg
    end
    for _, client in ipairs(clients) do
      local filetypes = client.config.filetypes
      if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
        return client.name
      end
    end
    return msg
  end,
  icon = "  LSP ~",
  color = { fg = active_colors.foam, gui = "bold" },
}

ins_right {
  function()
    local line = vim.fn.line "."
    local col = vim.fn.col "."
    return string.format("Ln %d, Col %d", line, col)
  end,
  color = { fg = active_colors.muted },
}

ins_right {
  function()
    return ""
  end,
  color = { fg = active_colors.love, bg = active_colors.highlight_high, gui = "bold" },
}

ins_right {
  function()
    return vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
  end,
  color = { fg = active_colors.love, bg = active_colors.highlight_high, gui = "bold" },
}

lualine.setup(config)
