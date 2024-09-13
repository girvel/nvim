require("opt").run()

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
local cmp_config = {
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

vim.keymap.set("n", ":W", ":w")

vim.keymap.set("n", "<C-Left>", "<C-O>")
vim.keymap.set("n", "<C-Right>", "<C-I>")

local builtin = require("telescope.builtin")

vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
vim.keymap.set("n", "<leader>fr", builtin.resume, {})
vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
vim.keymap.set("n", "<leader>fh", builtin.help_tags, {})
vim.keymap.set("n", "<leader>ft", builtin.treesitter, {})
vim.keymap.set("n", "<leader>fd", builtin.oldfiles, {})

vim.keymap.set("n", "<leader>lr", vim.lsp.buf.rename, {})

--vim.keymap.set("n", "<leader>cr", ":%luafile ~/.config/nvim/init.lua<CR>")

vim.keymap.set("i", "<M-CR>", function() luasnip.jump(1) end, {silent = true})

vim.keymap.set("i", "<M-o>", function()
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>ggO", true, false, true), "n", false)
end, {remap = true})

vim.keymap.set("n", "<M-o>", function()
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>ggO", true, false, true), "n", false)
end, {remap = true})

vim.keymap.set("n", "<leader>cf", ":ToggleTerm direction=float<CR>")
vim.keymap.set("n", "<leader>cv", ":ToggleTerm direction=vertical size=80<CR>")
vim.keymap.set("n", "<leader>ch", ":ToggleTerm direction=horizontal size=15<CR>")

_G.set_terminal_keymaps = function()
  vim.keymap.set("t", "<esc>", "<C-\\><C-n>")
  vim.keymap.set('t', '<C-w>', "<C-\\><C-n><C-w>")
end
vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")
