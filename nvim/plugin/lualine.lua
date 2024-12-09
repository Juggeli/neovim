if vim.g.did_load_lualine_plugin then
  return
end
vim.g.did_load_lualine_plugin = true

require('lualine').setup {
  options = {
    theme = 'auto',
    globalstatus = true,
    disabled_filetypes = { statusline = { 'snacks_dashboard' } },
  },
  sections = {
    lualine_a = { 'mode' },
    lualine_b = {
      'branch',
      {
        'diagnostics',
        sources = { 'nvim_diagnostic' },
        sections = { 'error', 'warn', 'info', 'hint' },
        symbols = { error = ' ', warn = ' ', info = ' ', hint = ' ' },
      },
    },
    lualine_c = { 'filename' },
    lualine_x = {
      'filetype',
    },
    lualine_y = { 'progress' },
    lualine_z = { 'location' },
  },
  inactive_sections = {},
  tabline = {},
  extensions = { 'quickfix' },
}
