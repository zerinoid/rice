return {
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        javascript = { "biome" },
        typescript = { "biome" },
        json = { "biome" },
      },
      formatters = {
        biome = {
          -- Pass the --config-path pointing directly to your global file
          prepend_args = function()
            return { "format", "--config-path=" .. vim.fn.expand("~/.config/nvim/biome.json") }
          end,
        },
      },
    },
  },
}
