return {
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        javascript = { "biome" },
        typescript = { "biome" },
        json = { "biome" },
        -- Add C and C++ support here
        c = { "clang_format" },
        cpp = { "clang_format" },
      },
      formatters = {
        biome = {
          -- Pass the --config-path pointing directly to your global file
          prepend_args = function()
            return { "format", "--config-path=" .. vim.fn.expand("~/.config/nvim/biome.json") }
          end,
        },
        -- Add clang-format configuration here
        clang_format = {
          prepend_args = { "--style=file", "--fallback-style=LLVM" },
        },
      },
    },
  },
}
