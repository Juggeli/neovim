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
    }
  end,
  integrations = {
    noice = true,
    notify = true,
    which_key = true,
    mini = {
      enabled = true,
    },
    blink_cmp = true,
    grug_far = true,
    neotest = true,
    snacks = true,
  },
}

vim.cmd.colorscheme('catppuccin')
