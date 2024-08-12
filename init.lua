vim.opt.relativenumber = true
vim.opt.number = true

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4

vim.opt.expandtab = true

vim.opt.autoindent = true
vim.opt.smartindent = false
vim.opt.cindent = false

vim.g.mapleader = " "

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
  {"hrsh7th/cmp-path"},
  {"hrsh7th/cmp-buffer"},
  {"nvim-treesitter/nvim-treesitter"},
  {"nvim-tree/nvim-tree.lua"},
  {"nvim-tree/nvim-web-devicons"},
  {"catppuccin/nvim", name = "catppuccin", priority = 1000 },
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.6",
    dependencies = { "nvim-lua/plenary.nvim" },
  },
  {"L3MON4D3/LuaSnip"},
  {"saadparwaiz1/cmp_luasnip"},
})

if vim.fn.has("wsl") == 1 then
  require("catppuccin").setup({

  })

  vim.cmd.colorscheme("catppuccin")
end

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
local cmp_config = {
  snippet = {
    expand = function(args)
      print(vim.inspect(args.body))
      --luasnip.lsp_expand(args.body)
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

vim.keymap.set("n", "<leader>tf", ":NvimTreeFocus<CR>")
vim.keymap.set("n", "<leader>tr", ":NvimTreeRefresh<CR>")

vim.keymap.set("n", ":й", ":q")
vim.keymap.set("n", ":ц", ":w")
vim.keymap.set("n", ":цй", ":wq")
vim.keymap.set("n", ":!й", ":!q")

vim.keymap.set("n", "<C-Left>", "<C-O>")
vim.keymap.set("n", "<C-Right>", "<C-I>")

local builtin = require("telescope.builtin")

vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
vim.keymap.set("n", "<leader>fr", builtin.resume, {})
vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
vim.keymap.set("n", "<leader>fh", builtin.help_tags, {})

vim.keymap.set("n", "<leader>lr", vim.lsp.buf.rename, {})

vim.keymap.set("i", "<M-CR>", function() luasnip.jump(1) end, {silent = true})

vim.keymap.set("i", "<C-r>", function()
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>ggO", true, false, true), "n", false)
end, {remap = true})
