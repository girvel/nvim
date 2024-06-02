vim.opt.relativenumber = true
vim.opt.number = true

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4

vim.opt.expandtab = true

vim.opt.autoindent = true
vim.opt.smartindent = false
vim.opt.cindent = false

vim.cmd("filetype indent off")

vim.api.nvim_create_autocmd("FileType", {
  pattern = "lua",
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.softtabstop = 2
  end
})

if vim.fn.has('wsl') == 1 then
  -- TODO integrate w/ windows clipboard
  -- vim.opt.clipboard = "unnamedplus"
  -- vim.api.nvim_create_autocmd('TextYankPost', {
  --   group = vim.api.nvim_create_augroup('Yank', { clear = true }),
  --   callback = function()
  --     vim.fn.system('clip.exe', vim.fn.getreg('"'))
  --   end,
  -- })
end

local function escape(str)
  local escape_chars = [[;,."|\]]
  return vim.fn.escape(str, escape_chars)
end

local en = [[`qwertyuiop[]asdfghjkl;'zxcvbnm]]
local ru = [[ёйцукенгшщзхъфывапролджэячсмить]]
local en_shift = [[~QWERTYUIOP{}ASDFGHJKL:"ZXCVBNM<>]]
local ru_shift = [[ËЙЦУКЕНГШЩЗХЪФЫВАПРОЛДЖЭЯЧСМИТЬБЮ]]

vim.opt.langmap = vim.fn.join({
    escape(ru_shift) .. ';' .. escape(en_shift),
    escape(ru) .. ';' .. escape(en),
}, ',')

-- PACKAGE MANAGER: LAZY --

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
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
  {"hrsh7th/cmp-vsnip"},
  {"hrsh7th/cmp-path"},
  {"hrsh7th/cmp-buffer"},
  {"hrsh7th/vim-vsnip"},
  {"nvim-treesitter/nvim-treesitter"},
  {"nvim-tree/nvim-tree.lua"},
  {"catppuccin/nvim", name = "catppuccin", priority = 1000 },
})

if vim.fn.has("wsl") == 1 then
  require("catppuccin").setup({

  })

  vim.cmd.colorscheme("catppuccin")
end

require("mason").setup({
  ui = {
    icons = {
      package_installed = "+",
      package_pending = "~",
      package_uninstalled = "-",
    }
  }
})
require("mason-lspconfig").setup()

require("lspconfig").lua_ls.setup({
  settings = {
    Lua = {
      diagnostics = {
        globals = {"vim", "love"}
      }
    }
  }
})

local cmp = require("cmp")
local cmp_config = {
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },

  mapping = {
    ["<C-p>"] = cmp.mapping.select_prev_item(),
    ["<C-n>"] = cmp.mapping.select_next_item(),
    ["<S-Tab>"] = cmp.mapping.select_prev_item(),
    ["<Tab>"] = cmp.mapping.select_next_item(),
    ["<C-S-f>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = function(...)
      print(vim.inspect {...})
      return cmp.mapping.complete()(...)
    end,
    ["<C-e>"] = cmp.mapping.abort(),
    ["<CR>"] = cmp.mapping.confirm({
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
    { name = "vsnip", keyword_length = 2 },
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
}

cmp.setup(cmp_config)

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

vim.keymap.set("n", "<C-T>", ":NvimTreeFocus<CR>")
vim.keymap.set("n", "<M-t>", ":NvimTreeRefresh<CR>")

vim.keymap.set("n", ":й", ":q")
vim.keymap.set("n", ":ц", ":w")
vim.keymap.set("n", ":цй", ":wq")
vim.keymap.set("n", ":!й", ":!q")
