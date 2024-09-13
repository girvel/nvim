return {
  {"williamboman/mason.nvim"},
  {"williamboman/mason-lspconfig.nvim"},
  {"neovim/nvim-lspconfig"},
  {
    "mrcjkb/rustaceanvim",
    version = "^3",
    ft = { "rust" },
  },
  {"hrsh7th/nvim-cmp"},
  {"hrsh7th/cmp-nvim-lsp"},
  {"hrsh7th/cmp-nvim-lua"},
  {"hrsh7th/cmp-nvim-lsp-signature-help"},
  {"hrsh7th/cmp-path"},
  {"hrsh7th/cmp-buffer"},
  {"nvim-treesitter/nvim-treesitter"},
  {"nvim-tree/nvim-tree.lua"},
  {"nvim-tree/nvim-web-devicons"},
  --{"catppuccin/nvim", name = "catppuccin", priority = 1000 },
  {
    "loctvl842/monokai-pro.nvim",
    config = function()
      if vim.fn.has("wsl") == 1 then
        require("monokai-pro").setup {
          filter = "spectrum",
        }
        vim.cmd.colorscheme("monokai-pro")
      end
    end
  },
  {
    "rcarriga/nvim-notify",
    config = function()
      vim.notify = require("notify")
    end
  },
  {
    'nvim-lualine/lualine.nvim',
    dependencies = {'nvim-tree/nvim-web-devicons'},
  },
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.6",
    dependencies = { "nvim-lua/plenary.nvim" },
  },
  {"L3MON4D3/LuaSnip"},
  {"saadparwaiz1/cmp_luasnip"},
  {"akinsho/bufferline.nvim", dependencies = "nvim-tree/nvim-web-devicons"},
}
