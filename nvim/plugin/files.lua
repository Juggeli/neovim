if vim.g.did_load_files_plugin then
  return
end
vim.g.did_load_files_plugin = true

local files = require('mini.files')

files.setup()

vim.keymap.set('n', '<space>e', files.open, { desc = 'Open files [e]explorer' })
