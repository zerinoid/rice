return {
  {
    "chomosuke/typst-preview.nvim",
    ft = "typst",
    version = "0.3.*",
    build = function()
      require("typst-preview").update()
    end,
    opts = {
      -- Custom configurations go here
      follow_cursor = true,
    },
    keys = {
      { "<leader>op", "<cmd>TypstPreviewToggle<cr>", desc = "Toggle Typst Preview" },
      { "<leader>oc", "<cmd>w<CR><cmd>LspTinymistExportPdf<CR>", desc = "Compile Typst" },
    },
  },
}
