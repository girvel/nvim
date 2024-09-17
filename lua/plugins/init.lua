return {
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end
  },
  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      require("mason-lspconfig").setup()
    end,
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      lspconfig = require("lspconfig")

      lspconfig.lua_ls.setup({
        settings = {
          Lua = {
            runtime = {
              version = "LuaJIT"
            },
            diagnostics = {
              globals = {"vim", "love"}
            }
          }
        }
      })

      lspconfig.clangd.setup {}
    end,
  },
  {
    "mrcjkb/rustaceanvim",
    version = "^3",
    ft = { "rust" },
  },
  {
    "hrsh7th/nvim-cmp",
    config = function()
      local luasnip = require("luasnip")
      local cmp = require("cmp")
      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },

        mapping = {
          ["<C-p>"] = cmp.mapping.select_prev_item(),
          ["<C-n>"] = cmp.mapping.select_next_item(),
          ["<M-Up>"] = cmp.mapping.select_prev_item(),
          ["<M-Down>"] = cmp.mapping.select_next_item(),
          ["<C-S-f>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<Tab>"] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Insert,
            select = true,
          }),
        },

        sources = {
          { name = "path" },
          { name = "nvim_lsp", keyword_length = 3 },
          { name = "nvim_lsp_signature_help" },
          { name = "nvim_lua", keyword_length = 2 },
          { name = "buffer", keyword_length = 2 },
          { name = "luasnip" },
          { name = "calc" },
        },

        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },

        formatting = {
          fields = {"menu", "abbr", "kind"},
          format = function(_, item)
            return item
          end,
        },
      })
    end,
  },
  {"hrsh7th/cmp-nvim-lsp"},
  {"hrsh7th/cmp-nvim-lua"},
  {"hrsh7th/cmp-nvim-lsp-signature-help"},
  {"hrsh7th/cmp-path"},
  {"hrsh7th/cmp-buffer"},
  {
    "nvim-treesitter/nvim-treesitter",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "lua", "rust", "toml" },
        auto_install = true,
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
        ident = { enable = false },
        rainbow = {
          enable = true,
          extended_mode = true,
          max_file_lines = nil,
        },
      })
    end,
  },
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.6",
    dependencies = { "nvim-lua/plenary.nvim" },
  },
  {
    "L3MON4D3/LuaSnip",
    config = function()
      require("luasnip.loaders.from_lua").load({paths = "./snippets"})
    end,
  },
  {"saadparwaiz1/cmp_luasnip"},
}
