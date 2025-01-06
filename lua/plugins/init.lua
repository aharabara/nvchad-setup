local overrides = require "custom.configs.overrides"
return {

  {
    "folke/twilight.nvim",
    lazy = false,
    cmd = "Twilight",
    opts = {
      context = 15,
      dimming = {
        alpha = 0.50,
      },
      expand = {
        "if_statement",
        "foreach_statement",
        "const_declaration",
        "property_declaration",
        "object_creation_expression", -- for ApiResource > Quer/Mutations
        "parameters",
        "method_declaration",
        "function_declaration",
        -- 'class_declaration'
      },
    },
    keys = {
      {
        "<leader>ach",
        "<cmd>Twilight<cr>",
        desc = "Code - Toggle scoped highlight",
      },
    },
  },
  {
    "nvim-neotest/neotest",
    lazy = true,
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
      "olimorris/neotest-phpunit",
    },
    config = function()
      require("neotest").setup {
        adapters = {
          require("neotest-phpunit")({
                        filter_dirs = { "vendor" }
        }),
        },
      }
    end,
  },
  {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment for format on save
    config = function()
      require "configs.conform"
    end,
  },

  {
    "nvim-tree/nvim-tree.lua",
    opts = overrides.nvimtree,
  },
  -- {
  --   "ahmedkhalf/project.nvim",
  --   lazy = false,
  --   config = function()
  --     require("project_nvim").setup {
  --       -- your configuration comes here
  --       -- or leave it empty to use the default settings
  --       -- refer to the configuration section below
  --     }
  --   end,
  -- },
  {
    "folke/trouble.nvim",
    -- branch = "dev",
    -- dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      height = 50,
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    },
    keys = {
      { -- FIXME: move
        "<leader>2",
        "<cmd>TroubleToggle document_diagnostics<cr>",
        desc = "Analyzer - Diagnostics",
      },
      {
        "<leader>7",
        "<cmd>TroubleToggle lsp_definitions<cr>",
        desc = "Analyzer - Definitions",
      },
      {
        "<leader>6",
        "<cmd>TroubleToggle lsp_references<cr>",
        desc = "Analyzer - References",
      },
      -- {
      --   "<leader>tl",
      --   "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
      --   desc = "LSP Definitions / references / ... (Trouble)",
      -- },
      -- {
      --   "<leader>tL",
      --   "<cmd>Trouble loclist toggle<cr>",
      --   desc = "Location List (Trouble)",
      -- },
      -- {
      --   "<leader>tQ",
      --   "<cmd>Trouble qflist toggle<cr>",
      --   desc = "Quickfix List (Trouble)",
      -- },
    },
    -- lazy = false,
  },
  {
    "hrsh7th/nvim-cmp",
    opts = overrides.cmp,
  },
  {
    cmd = "LazyGit",
    "kdheepak/lazygit.nvim",
    -- optional for floating window border decoration
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
  },
  {
    "crnvl96/lazydocker.nvim",
    -- event = "VeryLazy",
    cmd = "LazyDocker",
    opts = {}, -- automatically calls `require("lazydocker").setup()`
    dependencies = {
      "MunifTanjim/nui.nvim",
    },
  },
  {
    lazy = false,
    "aznhe21/actions-preview.nvim",
    config = function()
      vim.keymap.set({ "v", "n" }, "<space><enter>", require("actions-preview").code_actions)
    end,
  },
  {
    "smoka7/hop.nvim",
    cmd = { "HopWord" },
    version = "*",
    opts = {},
  },
  opts = function()
    return require "configs.telescope"
  end,

  {
    "nvim-telescope/telescope.nvim",
    opts = function()
      return overrides.telescope
    end,
  },
  {
    "mg979/vim-visual-multi",
    lazy = false,
  },
  -- {
  --   "mrcjkb/rustaceanvim",
  --   version = "^4", -- Recommended
  --   ft = { "rust" },
  -- },
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    lazy = false,
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    },
  },
  {
    "williamboman/mason.nvim",
    opts = overrides.mason,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = overrides.treesitter,
  },

  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end, -- Override to setup mason-lspconfig
  },
  {
    "grapp-dev/nui-components.nvim",
    dependencies = {
      "MunifTanjim/nui.nvim",
    },
  },
  {
      "olimorris/codecompanion.nvim",
        lazy = false,
      dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
      },

      config = function()
            require("codecompanion").setup({
                display = {
                    action_palette = {
                        provider = "telescope"
                    },
                    diff = {
                        provider = mini_pick
                    }
                },
                      strategies = {
        chat = {
          adapter = "openai",
        },
        inline = {
          adapter = "openai",
        },
      },
                  adapters = {
                    openai = function()
                      return require("codecompanion.adapters").extend("openai", {
                        env = {
                        },
                      })
                    end,
                  },
                })
        end,
    },
    { 'echasnovski/mini.pick', version = '*' },
  -- {
  --     'arakkkkk/kanban.nvim',
  --     cms = {'KanbanOpen'},
  --     lazy = false,
  --     config = function()
  --         require("kanban").setup({
  --             markdown = {
  --                 description_folder = "./tasks/",  -- Path to save the file corresponding to the task.
  --                 list_head = "## ",
  --             }
  --         })
  --
  --     end
  --
  -- }
  -- These are some examples, uncomment them if you want to see them work!
  -- {
  --   "neovim/nvim-lspconfig",
  --   config = function()
  --     require("nvchad.configs.lspconfig").defaults()
  --     require "configs.lspconfig"
  --   end,
  -- },
  --
  -- {
  -- 	"williamboman/mason.nvim",
  -- 	opts = {
  -- 		ensure_installed = {
  -- 			"lua-language-server", "stylua",
  -- 			"html-lsp", "css-lsp" , "prettier"
  -- 		},
  -- 	},
  -- },
  --
  -- {
  -- 	"nvim-treesitter/nvim-treesitter",
  -- 	opts = {
  -- 		ensure_installed = {
  -- 			"vim", "lua", "vimdoc",
  --      "html", "css"
  -- 		},
  -- 	},
  -- },
}
