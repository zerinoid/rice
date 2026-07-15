return {
  -- 1. Disable the default mini.surround plugin
  { "nvim-mini/mini.surround", enabled = false },

  -- 2. Add and configure nvim-surround
  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({
        -- Configuration options go here, or leave empty for defaults
      })
    end,
  },
}
