-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = "*.typ",
  callback = function()
    local filepath = vim.fn.expand("%:p") -- Pega o caminho absoluto do arquivo
    -- Ignora a compilação se a pasta "/partials/" estiver no caminho
    if string.find(filepath, "/partials/") then
      return
    end

    -- Compila normalmente se não estiver na pasta partials
    vim.fn.jobstart({ "typst", "compile", filepath }, { detach = true })
  end,
})

vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = "*/lf/lfrc",
  callback = function()
    -- Check if lf is running, and send the reload command if it is
    vim.fn.system("lf -remote 'send reload'")
    vim.notify("Reloaded lf!", vim.log.levels.INFO)
  end,
})

vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = "*/sxhkd/sxhkdrc",
  command = "!pkill -USR1 -x sxhkd",
})

vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = "*/.Xresources",
  command = "!xrdb -merge ~/.Xresources",
})
