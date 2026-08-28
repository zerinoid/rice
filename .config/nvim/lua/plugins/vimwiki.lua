return {
  "vimwiki/vimwiki",
  init = function()
    -- Use init() so global variables are set before the plugin loads
    vim.g.vimwiki_list = {
      {
        path = "~/.local/share/nvim/vimwiki/",
        syntax = "markdown",
        ext = ".md",
      },
    }
  end,
}
