-- ~/.config/nvim/lua/plugins/sxhkd.lua
return {
  {
    "kovetskiy/sxhkd-vim",
    lazy = false, -- Load immediately so it's always ready
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      -- Ensure sxhkd filetypes are recognized by Neovim
      vim.filetype.add({
        extension = {
          sxhkdrc = "sxhkdrc",
        },
        filename = {
          sxhkdrc = "sxhkdrc",
        },
      })
    end,
  },
}
