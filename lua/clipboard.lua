return {
  run = function()
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
  end,
}
