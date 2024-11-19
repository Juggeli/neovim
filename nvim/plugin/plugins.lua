if vim.g.did_load_plugins_plugin then
  return
end
vim.g.did_load_plugins_plugin = true

-- many plugins annoyingly require a call to a 'setup' function to be loaded,
-- even with default configs

require('which-key').setup()
require('dressing').setup()
require('stay-centered').setup {
  skip_filetypes = { 'minifiles', '' },
}
require('auto-save').setup {
  -- Save after minute of idle
  debounce_delay = 60000,
}
require('ultimate-autopair').setup {}
require('nvim-highlight-colors').setup {
  render = 'virtual',
}
