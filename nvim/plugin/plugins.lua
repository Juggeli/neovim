if vim.g.did_load_plugins_plugin then
  return
end
vim.g.did_load_plugins_plugin = true

-- many plugins annoyingly require a call to a 'setup' function to be loaded,
-- even with default configs

require('which-key').setup()
require('dressing').setup()
require('mini.statusline').setup()
require('mini.git').setup()
require('mini.diff').setup({
  view = {
    style = 'sign',
    signs = { add = '▎', change = '▎', delete = '' },
  }
})
require('mini.tabline').setup()
require('mini.comment').setup()
