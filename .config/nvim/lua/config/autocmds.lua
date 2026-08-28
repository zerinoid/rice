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

local dwmblocks_dir = vim.fn.expand("~/.local/src/dwmblocks/")

vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = {
    dwmblocks_dir .. "config.h",
    dwmblocks_dir .. "config.def.h",
    dwmblocks_dir .. "blocks.def.h",
    dwmblocks_dir .. "blocks.h",
  },
  callback = function()
    vim.notify("Recompilando e reiniciando o dwmblocks...", vim.log.levels.INFO, { title = "dwmblocks" })

    vim.fn.jobstart(
      "make -C "
        .. dwmblocks_dir
        .. " && sudo make -C "
        .. dwmblocks_dir
        .. " install && pkill -x dwmblocks; dwmblocks &",
      {
        shell = "/usr/bin/env bash",
        on_exit = function(_, exit_code)
          if exit_code == 0 then
            vim.notify("dwmblocks atualizado com sucesso!", vim.log.levels.INFO, { title = "dwmblocks" })
          else
            vim.notify("Falha ao compilar/instalar o dwmblocks", vim.log.levels.ERROR, { title = "dwmblocks" })
          end
        end,
      }
    )
  end,
})

local dwm_dir = vim.fn.expand("~/.local/src/dwm/")

vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = { dwm_dir .. "config.h", dwm_dir .. "config.def.h" },
  callback = function()
    vim.notify("Recompilando e reiniciando o dwm...", vim.log.levels.INFO, { title = "DWM" })

    vim.fn.jobstart("make -C " .. dwm_dir .. " && sudo make -C " .. dwm_dir .. " install && kill -HUP $(pidof dwm)", {
      shell = "/usr/bin/env bash",
      on_exit = function(_, exit_code)
        if exit_code == 0 then
          vim.notify("DWM atualizado com sucesso!", vim.log.levels.INFO, { title = "DWM" })
        else
          vim.notify("Falha ao compilar/instalar o DWM", vim.log.levels.ERROR, { title = "DWM" })
        end
      end,
    })
  end,
})

-- Auto-reload power-timer.service on saving power_timer.sh
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = "power_timer.sh",
  callback = function()
    vim.fn.jobstart({ "systemctl", "--user", "restart", "power-timer.service" }, {
      on_exit = function(_, exit_code)
        if exit_code == 0 then
          vim.notify("power-timer.service restarted", vim.log.levels.INFO, { title = "Systemd" })
        else
          vim.notify("Failed to restart power-timer.service", vim.log.levels.ERROR, { title = "Systemd" })
        end
      end,
    })
  end,
})
