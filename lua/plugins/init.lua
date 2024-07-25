local plugins = {
  {
    lazy = true,
    "nvim-lua/plenary.nvim",
  },

  {
    "rose-pine/neovim",
    init = function()
      vim.cmd.colorscheme "rose-pine-moon"
    end,
    name = "rose-pine",
  },

  -- file tree
  {
    "nvim-tree/nvim-tree.lua",
    cmd = { "NvimTreeToggle", "NvimTreeFocus" },
    opts = function()
      return require "plugins.configs.nvim-tree"
    end,
    config = function(_, opts)
      require("nvim-tree").setup(opts)
    end,
  },

  -- icons, for UI related plugins
  {
    "nvim-tree/nvim-web-devicons",
    config = function()
      require("nvim-web-devicons").setup()
    end,
  },

  -- syntax highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require "plugins.configs.treesitter"
    end,
  },

  -- buffer + tab line
  {
    "akinsho/bufferline.nvim",
    event = "ColorScheme",
    config = function()
      require("bufferline").setup()
    end,
  },

  -- statusline

  {
    "nvim-lualine/lualine.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require "plugins.configs.lualine"
    end,
  },

  -- we use cmp plugin only when in insert mode
  -- so lets lazyload it at InsertEnter event, to know all the events check h-events
  -- completion , now all of these plugins are dependent on cmp, we load them after cmp
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      -- cmp sources
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-nvim-lsp",
      "saadparwaiz1/cmp_luasnip",
      "hrsh7th/cmp-nvim-lua",

      -- snippets
      --list of default snippets
      "rafamadriz/friendly-snippets",

      -- snippets engine
      {
        "L3MON4D3/LuaSnip",
        config = function()
          require("luasnip.loaders.from_vscode").lazy_load()
        end,
      },

      -- autopairs , autocompletes ()[] etc
      {
        "windwp/nvim-autopairs",
        config = function()
          require("nvim-autopairs").setup()

          --  cmp integration
          local cmp_autopairs = require "nvim-autopairs.completion.cmp"
          local cmp = require "cmp"
          cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
        end,
      },
    },
    config = function()
      require "plugins.configs.cmp"
    end,
  },

  {
    "williamboman/mason.nvim",
    opts = {
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    },
  },

  -- lsp

  {
    "neovim/nvim-lspconfig",
    event = "User FilePost",
    config = function()
      require("plugins.configs.lspconfig").defaults()
    end,
  },

  -- formatting , linting
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    lazy = true,
    config = function()
      require "plugins.configs.conform"
    end,
  },

  {
    "mfussenegger/nvim-lint",
    event = "VeryLazy",
    config = function()
      require "plugins.configs.lint"
    end,
  },
  -- indent lines
  {
    "lukas-reineke/indent-blankline.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("ibl").setup {
        indent = { char = "│" },
        scope = { char = "│", highlight = "Comment" },
      }
    end,
  },

  -- files finder etc
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    config = function()
      require "plugins.configs.telescope"
    end,
  },

  {
    "nvim-telescope/telescope-ui-select.nvim",
  },

  -- git status on signcolumn etc

  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = function()
      return require "plugins.configs.gitsigns"
    end,
    config = function(_, opts)
      require("gitsigns").setup(opts)
    end,
  },

  {
    "kdheepak/lazygit.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = "LazyGit",
  },

  {
    "sindrets/diffview.nvim",
    event = "VeryLazy",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles" },
  },

  {
    "NeogitOrg/neogit",
    ft = { "diff" },
    cmd = "Neogit",
    dependencies = {
      "sindrets/diffview.nvim",
      "nvim-lua/plenary.nvim",
    },
    opts = {
      signs = { section = { "", "" }, item = { "", "" } },
      disable_commit_confirmation = true,
      integrations = { diffview = true },
    },
  },

  -- lsp spinner
  {
    "j-hui/fidget.nvim",
    tag = "legacy",
    event = "LspAttach",
    opts = {
      text = {
        spinner = "pipe",
        done = "✔",
        commenced = "Started",
        completed = "Completed",
      },
      timer = {
        spinner_rate = 125,
        fidget_decay = 2000,
        task_decay = 1000,
      },
    },
  },

  -- word navigation
  {
    "jinh0/eyeliner.nvim",
    event = "VeryLazy",
    config = function()
      require("eyeliner").setup {
        highlight_on_key = true,
      }
    end,
  },

  {
    "kevinhwang91/nvim-bqf",
    config = function()
      require("bqf").setup()
    end,
  },

  {
    "nacro90/numb.nvim",
    config = function()
      require("numb").setup()
    end,
  },

  {
    "folke/which-key.nvim",
    keys = { "<leader>", '"', "'", "`" },
    -- "c", "v", "g","<c-r>", },
    cmd = "WhichKey",
    config = function(_, opts)
      require("which-key").setup(opts)
    end,
  },

  {
    "christoomey/vim-tmux-navigator",
  },

  -- DAP

  {
    "mfussenegger/nvim-dap",
    after = "catppuccin",
    config = function(_, opts)
      require("dapui").setup(opts)
    end,
  },
  {
    "rcarriga/nvim-dap-ui",
    after = "catppuccin",
    event = "VeryLazy",
    dependencies = {
      "mfussenegger/nvim-dap",
    },
    opts = function()
      return require "plugins.configs.dap_config"
    end,
    config = function(_, opts)
      require("dapui").setup(opts)
    end,
  },
  {
    "mfussenegger/nvim-dap-python",
    ft = "python",
    dependencies = {
      "mfussenegger/nvim-dap",
      "rcarriga/nvim-dap-ui",
    },
    config = function()
      local path = "~/.local/share/nvim/mason/packages/debugpy/venv/bin/python"
      require("dap-python").setup(path)
    end,
  },
  {
    "leoluz/nvim-dap-go",
    ft = "go",
    dependencies = {
      "mfussenegger/nvim-dap",
      "rcarriga/nvim-dap-ui",
    },
    config = function(_, opts)
      require("dap-go").setup(opts)
    end,
  },
  {
    "theHamsta/nvim-dap-virtual-text",
    lazy = false,
    config = function(_, opts)
      require("nvim-dap-virtual-text").setup()
    end,
  },
  {
    "nvim-neotest/nvim-nio",
  },
  -- Rust
  {
    "mrcjkb/rustaceanvim",
    version = "^4",
    ft = { "rust" },
    dependencies = "neovim/nvim-lspconfig",
    config = function()
      require "plugins.configs.rustaceanvim"
    end,
  },
  {
    "saecki/crates.nvim",
    ft = { "toml" },
    config = function(_, opts)
      local crates = require "crates"
      crates.setup(opts)
      require("cmp").setup.buffer {
        sources = { { name = "crates" } },
      }
      crates.show()
    end,
  },
  {
    "rust-lang/rust.vim",
    ft = "rust",
    init = function()
      vim.g.rustfmt_autosave = 1
    end,
  },

  -- Java
  {
    "nvim-java/nvim-java",
    dependencies = {
      "nvim-java/lua-async-await",
      "nvim-java/nvim-java-refactor",
      "nvim-java/nvim-java-core",
      "nvim-java/nvim-java-test",
      "nvim-java/nvim-java-dap",
      "MunifTanjim/nui.nvim",
      "neovim/nvim-lspconfig",
      "mfussenegger/nvim-dap",
      {
        "williamboman/mason.nvim",
        opts = {
          registries = {
            "github:nvim-java/mason-registry",
            "github:mason-org/mason-registry",
          },
        },
      },
    },
  },

  {
    "karb94/neoscroll.nvim",
    keys = { "<C-d>", "<C-u>" },
    config = function()
      require("neoscroll").setup { mappings = {
        "<C-u>",
        "<C-d>",
      } }
    end,
  },

  {
    "RRethy/vim-illuminate",
    event = { "CursorHold", "CursorHoldI" },
    dependencies = "nvim-treesitter",
    config = function()
      require("illuminate").configure {
        under_cursor = true,
        max_file_lines = nil,
        delay = 100,
        providers = {
          "lsp",
          "treesitter",
          "regex",
        },
        filetypes_denylist = {
          "NvimTree",
          "Trouble",
          "Outline",
          "TelescopePrompt",
          "Empty",
          "dirvish",
          "fugitive",
          "alpha",
          "packer",
          "neogitstatus",
          "spectre_panel",
          "toggleterm",
          "DressingSelect",
          "aerial",
        },
      }
    end,
  },

  -- {
  --   "microsoft/vscode-js-debug",
  --   build = "npm install --legacy-peer-deps && npx gulp vsDebugServerBundle && mv dist out",
  -- },
  -- {
  --   "mxsdev/nvim-dap-vscode-js",
  --   opts = {
  --     debugger_path = vim.fn.stdpath "data" .. "/lazy/vscode-js-debug",
  --     adapters = { "pwa-node", "pwa-chrome" },
  --   },
  -- },

  -- {
  --   "zbirenbaum/copilot.lua",
  --   cmd = "Copilot",
  --   event = "InsertEnter",
  --   dependencies = {
  --     "zbirenbaum/copilot-cmp",
  --   },
  --   config = function()
  --     require "plugins.configs.copilot"
  --   end,
  -- },

  -- {
  --   "ThePrimeagen/harpoon",
  --   branch = "harpoon2",
  --   dependencies = { "nvim-lua/plenary.nvim" },
  --   config = function()
  --     require "plugins.configs.harpoon"
  --   end,
  -- },
}

require("lazy").setup(plugins, require "lazy_config")
