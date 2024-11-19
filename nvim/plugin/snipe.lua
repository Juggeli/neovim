if vim.g.did_load_snipe_plugin then
  return
end
vim.g.did_load_snipe_plugin = true

local snipe = require('snipe')
snipe.setup()
vim.keymap.set('n', 'gb', snipe.open_buffer_menu)
