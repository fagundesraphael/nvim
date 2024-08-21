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

--  lualine config
local config = {
  options = {
    component_separators = "",
    section_separators = "",
    theme = "rose-pine-alt",
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
local function ins_mode(component)
  table.insert(config.sections.lualine_a, component)
end

local function ins_filename(component)
  table.insert(config.sections.lualine_b, component)
end

local function ins_left(component)
  table.insert(config.sections.lualine_c, component)
end

-- right component
local function ins_right(component)
  table.insert(config.sections.lualine_x, component)
end

local function ins_directory(component)
  table.insert(config.sections.lualine_z, component)
end

ins_mode {
  "mode",
  color = { gui = "bold" },
}

ins_filename {
  "filename",
  cond = conditions.buffer_not_empty,
  color = { gui = "bold" },
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
  color = { gui = "bold" },
}

ins_left {
  "diff",
  symbols = { added = " ", modified = " ", removed = " " },
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
  symbols = { error = " ", warn = " ", info = " ", hint = "󰌶 " },
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
  color = { gui = "bold" },
}

ins_right {
  function()
    local line = vim.fn.line "."
    local col = vim.fn.col "."
    return string.format("Ln %d, Col %d", line, col)
  end,
}

ins_right {
  function()
    local current_line = vim.fn.line "."
    local total_lines = vim.fn.line "$"
    local progress_percentage = (current_line / total_lines) * 100
    local progress_icons = {
      " ",
      "▂",
      "▃",
      "▄",
      "▅",
      "▆",
      "▇",
      "█",
    }
    local icon_index = math.ceil((#progress_icons - 1) * (progress_percentage / 100))
    icon_index = math.max(1, icon_index)
    local icon = progress_icons[icon_index]
    return string.format("%s %.1d%%%%", icon, progress_percentage)
  end,
  color = { gui = "bold" },
}

ins_directory {
  function()
    return ""
  end,
  color = { gui = "bold" },
}

ins_directory {
  function()
    return vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
  end,
  color = { gui = "bold" },
}

lualine.setup(config)
