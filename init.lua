require("opt").run()
require("clipboard").run()
require("package_manager").run()

require("mason").setup()
require("mason-lspconfig").setup()

local luasnip = require("luasnip")
require("luasnip.loaders.from_lua").load({paths = "./snippets"})

require("snippets")()

require("lspconfig").lua_ls.setup({
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

require("nvim-tree").setup({})
require("keymap").run()
