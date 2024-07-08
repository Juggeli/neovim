if vim.g.did_load_catppuccin_plugin then
  return
end
vim.g.did_load_catppuccin_plugin = true

require('catppuccin').setup {
  custom_highlights = function(colors)
    return {
      -- Set a bit brigher color for window separator
      WinSeparator = { fg = colors.surface1 },
    }
  end,
}

vim.cmd.colorscheme('catppuccin')
