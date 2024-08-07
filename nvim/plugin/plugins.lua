if vim.g.did_load_plugins_plugin then
  return
end
vim.g.did_load_plugins_plugin = true

-- many plugins annoyingly require a call to a 'setup' function to be loaded,
-- even with default configs


require('which-key').setup()
require('dressing').setup()
require('stay-centered').setup {
  skip_filetypes = { 'minifiles' },
}
require('auto-save').setup {
  execution_message = {
    enabled = false,
  },
  -- Save after minute of idle
  debounce_delay = 60000,
}
