return {
  run = function()
    vim.opt.relativenumber = true
    vim.opt.number = true

    vim.opt.tabstop = 4
    vim.opt.shiftwidth = 4
    vim.opt.softtabstop = 4

    vim.opt.expandtab = true

    vim.opt.autoindent = true
    vim.opt.smartindent = false
    vim.opt.cindent = false

    vim.opt.termguicolors = true

    vim.g.mapleader = " "

    vim.cmd("filetype indent off")
    vim.cmd(":set cc=100")

    vim.api.nvim_create_autocmd("FileType", {
      pattern = "lua",
      callback = function()
        vim.opt_local.tabstop = 2
        vim.opt_local.shiftwidth = 2
        vim.opt_local.softtabstop = 2
      end
    })

    vim.api.nvim_create_autocmd("FileType", {
      pattern = "html",
      callback = function()
        vim.opt_local.tabstop = 2
        vim.opt_local.shiftwidth = 2
        vim.opt_local.softtabstop = 2
      end
    })
  end,
}
