local map = vim.keymap.set

-- path file
map("n", "<leader>pt", function()
  vim.cmd [[echo expand('%:p')]]
end, { desc = "Show File Path" })

--format
map("n", "<leader>fm", function()
  require("conform").format { lsp_fallback = true }
end, { desc = "general format file" })

-- exit insert mode with jk
map("i", "jk", "<ESC>", { noremap = true, silent = true })
map("i", "kj", "<ESC>", { noremap = true, silent = true })

map("n", "<leader>P", '"_dP', { noremap = true, silent = true })
-- Insert mode mappings
map("i", "<C-b>", "<ESC>^i", { desc = "move to beginning of line" })
map("i", "<C-e>", "<End>", { desc = "move to end of line" })
map("i", "<C-h>", "<Left>", { desc = "move left" })
map("i", "<C-l>", "<Right>", { desc = "move right" })
map("i", "<C-j>", "<Down>", { desc = "move down" })
map("i", "<C-k>", "<Up>", { desc = "move up" })

-- move lines
map("i", "<A-j>", "<Esc>:m .+1<CR>==gi", { desc = "Move line down" })
map("i", "<A-k>", "<Esc>:m .-2<CR>==gi", { desc = "Move line up" })

map("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move line down" })
map("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move line up" })

-- General mappings
map("n", "<C-d>", "<c-d>zz", { desc = "Scroll down and center" })
map("n", "<C-u>", "<C-u>zz", { desc = "Scroll up and center" })
-- clear highlights
map("n", "<Esc>", "<cmd>noh<CR>", { desc = "clear search highlights" })
-- lines moving normal mode
map("n", "j", "v:count || mode(1)[0:1] == 'no' ? 'j' : 'gj'", { expr = true, noremap = true, silent = true })
map("n", "k", "v:count || mode(1)[0:1] == 'no' ? 'k' : 'gk'", { expr = true, noremap = true, silent = true })
map("n", "<Up>", "v:count || mode(1)[0:1] == 'no' ? 'k' : 'gk'", { expr = true, noremap = true, silent = true })
map("n", "<Down>", "v:count || mode(1)[0:1] == 'no' ? 'j' : 'gj'", { expr = true, noremap = true, silent = true })

-- lines moving visual mode
map("v", "<Up>", "v:count || mode(1)[0:1] == 'no' ? 'k' : 'gk'", { expr = true, noremap = true, silent = true })
map("v", "<Down>", "v:count || mode(1)[0:1] == 'no' ? 'j' : 'gj'", { expr = true, noremap = true, silent = true })
map("v", "<", "<gv", { desc = "Indent line" })
map("v", ">", ">gv", { desc = "Indent line" })

-- tmux
map("n", "<C-h>", "<cmd> TmuxNavigateLeft<CR>")
map("n", "<C-l>", "<cmd> TmuxNavigateRight<CR>")
map("n", "<C-j>", "<cmd> TmuxNavigateDown<CR>")
map("n", "<C-k>", "<cmd> TmuxNavigateUp<CR>")

-- window navigation
map("n", "<C-h>", "<C-w>h", { desc = "switch to left window" })
map("n", "<C-l>", "<C-w>l", { desc = "switch to right window" })
map("n", "<C-j>", "<C-w>j", { desc = "switch to bottom window" })
map("n", "<C-k>", "<C-w>k", { desc = "switch to top window" })

map("n", "<C-s>", "<cmd>w<CR>", { desc = "save file" })

map("n", "<leader>n", "<cmd>set nu!<CR>", { desc = "toggle line numbers" })
map("n", "<leader>rn", "<cmd>set rnu!<CR>", { desc = "toggle relative numbers" })

map("n", "<C-n>", "<cmd>NvimTreeToggle<CR>", { desc = "toggle nvimtree window" })
map("n", "<leader>e", "<cmd>NvimTreeFocus<CR>", { desc = "focus nvimtree window" })

-- fzf-lua
map("n", "<leader>fw", "<cmd>FzfLua live_grep --fixed-strings<CR>", { desc = "search live with fzf-lua" })
map("n", "<leader>fb", "<cmd>FzfLua buffers<CR>", { desc = "find buffers with fzf-lua" })
map("n", "<leader>fh", "<cmd>FzfLua help_tags<CR>", { desc = "search help tags with fzf-lua" })
map("n", "<leader>ma", "<cmd>FzfLua marks<CR>", { desc = "find marks with fzf-lua" })
map("n", "<leader>fo", "<cmd>FzfLua oldfiles<CR>", { desc = "find old files with fzf-lua" })
map("n", "<leader>fz", "<cmd>FzfLua blines --fixed-strings<CR>", { desc = "find in current buffer with fzf-lua" })
map("n", "<leader>cm", "<cmd>FzfLua git_commits<CR>", { desc = "browse git commits with fzf-lua" })
map("n", "<leader>gt", "<cmd>FzfLua git_status<CR>", { desc = "git status with fzf-lua" })
map("n", "<leader>ff", "<cmd>FzfLua files<CR>", { desc = "find files with fzf-lua" })
map("n", "<leader>fc", "<cmd>FzfLua command_history<CR>", { desc = "find in current buffer with fzf-lua" })
map("n", "<leader>fds", "<cmd>FzfLua lsp_document_symbols<CR>", { desc = "Document symbols with fzf-lua" })
map("n", "<leader>th", "<cmd>FzfLua colorschemes<CR>", { desc = "change colorscheme with fzf-lua" })

-- Comment
map("n", "<leader>/", "gcc", { desc = "toggle comment", remap = true })
map("v", "<leader>/", "gc", { desc = "toggle comment", remap = true })

map("n", "<leader>wK", "<cmd>WhichKey <CR>", { desc = "whichkey all keymaps" })

map("n", "<leader>wk", function()
  vim.cmd("WhichKey " .. vim.fn.input "WhichKey: ")
end, { desc = "whichkey query lookup" })

-- Blankline
map("n", "<leader>cc", function()
  local config = { scope = {} }
  config.scope.exclude = { language = {}, node_type = {} }
  config.scope.include = { node_type = {} }
  local node = require("ibl.scope").get(vim.api.nvim_get_current_buf(), config)

  if node then
    local start_row, _, end_row, _ = node:range()
    if start_row ~= end_row then
      vim.api.nvim_win_set_cursor(vim.api.nvim_get_current_win(), { start_row + 1, 0 })
      vim.api.nvim_feedkeys("_", "n", true)
    end
  end
end, { desc = "blankline jump to current context" })

-- DAP mappings
local dap_map = vim.keymap.set

dap_map("n", "<F10>", "<cmd>lua require('dap').toggle_breakpoint()<CR>", { desc = "Toggle breakpoint" })
dap_map("n", "<F5>", "<cmd>lua require('dap').continue()<CR>", { desc = "Continue" })
dap_map("n", "<F9>", "<cmd>lua require('dap').restart()<CR>", { desc = "Restart" })
dap_map("n", "<F7>", "<cmd>lua require('dap').step_out()<CR>", { desc = "Step out" })
dap_map("n", "<F6>", "<cmd>lua require('dap').step_into()<CR>", { desc = "Step into" })
dap_map("n", "<F8>", "<cmd>lua require('dap').step_over()<CR>", { desc = "Step over" })
dap_map("n", "<leader>dpr", function()
  local args = vim.fn.input "Arguments: "
  vim.cmd("RustLsp debuggables " .. args)
end, { desc = "Select and run Rust debuggable" })

-- Crates mappings
local crates_map = vim.keymap.set

crates_map("n", "<leader>rcu", function()
  require("crates").upgrade_all_crates()
end, { desc = "Update crates" })

-- DAP Python mappings
local dap_python_map = vim.keymap.set

dap_python_map("n", "<F10>", "<cmd>DapToggleBreakpoint<CR>", { desc = "Toggle breakpoint" })
dap_python_map("n", "<F5>", "<cmd>DapContinue<CR>", { desc = "Continue" })
dap_python_map("n", "<F9>", "<cmd>DapRestart<CR>", { desc = "Restart" })
dap_python_map("n", "<F7>", "<cmd>DapStepOut<CR>", { desc = "Step out" })
dap_python_map("n", "<F6>", "<cmd>DapStepInto<CR>", { desc = "Step into" })
dap_python_map("n", "<F8>", "<cmd>DapStepOver<CR>", { desc = "Step over" })

-- DAP Go mappings
local dap_go_map = vim.keymap.set

dap_go_map("n", "<F10>", "<cmd>DapToggleBreakpoint<CR>", { desc = "Toggle breakpoint" })
dap_go_map("n", "<F5>", "<cmd>DapContinue<CR>", { desc = "Continue" })
dap_go_map("n", "<F9>", "<cmd>DapRestart<CR>", { desc = "Restart" })
dap_go_map("n", "<F7>", "<cmd>DapStepOut<CR>", { desc = "Step out" })
dap_go_map("n", "<F6>", "<cmd>DapStepInto<CR>", { desc = "Step into" })
dap_go_map("n", "<F8>", "<cmd>DapStepOver<CR>", { desc = "Step over" })

-- Gopher mappings
local gopher_map = vim.keymap.set

gopher_map("n", "<leader>gsj", "<cmd>GoTagAdd json<CR>", { desc = "Add json struct tags" })
gopher_map("n", "<leader>gsy", "<cmd>GoTagAdd yaml<CR>", { desc = "Add yaml struct tags" })

-- gitsigns
map("n", "<leader>]c", "<cmd> lua require('gitsigns').next_hunk()<CR>")
map("n", "<leader>[c", "<cmd> lua require('gitsigns').prev_hunk()<CR>")
map("n", "<leader>rh", "<cmd> lua require('gitsigns').reset_hunk()<CR>")
map("n", "<leader>ph", "<cmd> lua require('gitsigns').preview_hunk()<CR>")
map("n", "<leader>gb", "<cmd> lua require('gitsigns').blame_line()<CR>")
map("n", "<leader>td", "<cmd> lua require('gitsigns').toggle_deleted()<CR>")

-- Java JPA mappings
map("n", "<leader>jpce", "<cmd>CreateNewJPAEntity<CR>", { desc = "Create New JPA Entity" })
map("n", "<leader>jpcr", "<cmd>CreateJPARepository<CR>", { desc = "Create JPA Repository" })
map("n", "<leader>jpcfi", "<cmd>CreateEntityField id<CR>", { desc = "Create Entity Field - id" })
map("n", "<leader>jpcfb", "<cmd>CreateEntityField basic<CR>", { desc = "Create Entity Field - basic" })
map("n", "<leader>jpcfe", "<cmd>CreateEntityField enum<CR>", { desc = "Create Entity Field - enum" })
map(
  "n",
  "<leader>jpcro",
  "<cmd>CreateEntityRelationship one-to-one<CR>",
  { desc = "Create Entity Relationship - One to One" }
)
map(
  "n",
  "<leader>jpcrm",
  "<cmd>CreateEntityRelationship many-to-one<CR>",
  { desc = "Create Entity Relationship - Many to One" }
)

-- bufferline, cycle buffers
map("n", "<Tab>", "<cmd>bnext<CR>")
map("n", "<S-Tab>", "<cmd>bprev<CR>")
-- map("n", "<Tab>", "<cmd> BufferLineCycleNext <CR>")
-- map("n", "<S-Tab>", "<cmd> BufferLineCyclePrev <CR>")
map("n", "<leader>b", "<cmd> enew <CR>")
-- map("n", "<leader>x", "<cmd> bp | sp | bn | bd <CR>")
map("n", "<leader>x", function()
  if vim.bo.modified then
    local choice = vim.fn.confirm("Buffer não salvo. Deseja salvar?", "&Sim\n&Não\n&Cancelar", 3)
    if choice == 1 then
      vim.cmd "write"
    elseif choice == 3 then
      return
    end
  end

  local current = vim.api.nvim_get_current_buf()
  vim.cmd "bnext"
  vim.cmd("bdelete " .. current)
end, { noremap = true, silent = true })
