if vim.g.did_load_catppuccin_plugin then
  return
end
vim.g.did_load_catppuccin_plugin = true

require('catppuccin').setup {
  custom_highlights = function(colors)
    return {
      -- Set a bit brighter color for window separator
      WinSeparator = { fg = colors.surface1 },

      MiniIndentscopeSymbol = { fg = colors.surface2 },
      MiniTablineCurrent = { fg = colors.text, bg = colors.surface0, sp = colors.red, style = { 'bold' } },
      MiniTablineModifiedCurrent = { fg = colors.green, bg = colors.surface0, style = { 'bold' } },
    }
  end,
  integrations = {
    noice = true,
    notify = true,
    which_key = true,
    mini = {
      enabled = true,
    },
  },
}

vim.cmd.colorscheme('catppuccin')
