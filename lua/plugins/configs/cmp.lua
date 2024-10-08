local cmp = require "cmp"

local cmp_kinds = {
  Namespace = "󰌗",
  Text = "",
  Method = "",
  Function = "󰊕",
  Constructor = "",
  Field = "󰜢",
  Variable = "󰀫",
  Class = "󰠱",
  Interface = "",
  Module = "",
  Property = "",
  Unit = "󰑭",
  Value = "󰎠",
  Enum = "",
  Keyword = "󰌋",
  Snippet = "",
  -- Snippet = "󰘍",
  Color = "󰏘",
  File = "󰈚",
  Reference = "󰌹",
  Folder = "󰉋",
  EnumMember = "",
  Constant = "󰏿",
  Struct = "󰙅",
  Event = "",
  Operator = "󰆕",
  TypeParameter = "󰊄",
}

local function border(hl_name)
  return {
    { "╭", hl_name },
    { "─", hl_name },
    { "╮", hl_name },
    { "│", hl_name },
    { "╯", hl_name },
    { "─", hl_name },
    { "╰", hl_name },
    { "│", hl_name },
  }
end

local formatting_style = {
  fields = { "kind", "abbr", "menu" },
  format = function(entry, item)
    local icon = cmp_kinds[item.kind] or ""
    icon = " " .. icon .. " "
    item.menu = "   (" .. item.kind .. ")"
    item.kind = icon
    return item
  end,
}

cmp.setup {
  snippet = {
    expand = function(args)
      require("luasnip").lsp_expand(args.body)
    end,
  },
  mapping = {
    ["<C-p>"] = cmp.mapping.select_prev_item(),
    ["<C-n>"] = cmp.mapping.select_next_item(),
    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.close(),
    ["<CR>"] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Insert,
      select = true,
    },
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif require("luasnip").expand_or_jumpable() then
        require("luasnip").expand_or_jump()
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif require("luasnip").jumpable(-1) then
        require("luasnip").jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),
  },
  sources = {
    { name = "nvim_lsp" },
    { name = "luasnip" },
    { name = "buffer" },
    { name = "nvim_lua" },
    { name = "path" },
    { name = "spell" },
  },
  formatting = formatting_style,
  window = {
    completion = {
      side_padding = 0,
      winhighlight = "Normal:CmpPmenu,CursorLine:CmpSel,Search:None",
      scrollbar = false,
      border = border "CmpBorder",
    },
    documentation = {
      border = border "CmpDocBorder",
      winhighlight = "Normal:CmpDoc",
    },
  },
  completion = {
    completeopt = "menu,menuone,noselect",
  },
}

vim.cmd [[
  highlight! default link CmpSel PmenuSel
  highlight! default link CmpPmenu Pmenu
  highlight! default link CmpPmenuSel PmenuSel
  highlight! default link CmpBorder Pmenu
  highlight! default link CmpDoc Pmenu
  highlight! default link CmpDocBorder Pmenu
]]

vim.o.pumheight = 10

return cmp
