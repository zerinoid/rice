-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

-- Set Space as the leader key
vim.g.mapleader = " "

-- Map <leader>fs to save the current file
vim.keymap.set("n", "<leader>fs", ":w<CR>", { desc = "Save file" })
