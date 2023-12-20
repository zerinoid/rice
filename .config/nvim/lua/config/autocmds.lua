-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
--

-- Update binds when sxhkdrc is updated.
vim.api.nvim_command([[autocmd BufWritePost *sxhkdrc :!pkill -USR1 sxhkd]])

-- Update picom when picom.conf is updated.
vim.api.nvim_command([[ autocmd BufWritePost *picom.conf !pkill -SIGUSR1 -x picom]])

-- Disables automatic commenting on newline:
vim.api.nvim_command([[ autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o ]])

-- Relaunch Dunst
-- vim.api.nvim_command([[ autocmd BufWritePost *dunstrc !pkill -SIGUSR1 -x dunst]])
