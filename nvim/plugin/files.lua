if vim.g.did_load_files_plugin then
  return
end
vim.g.did_load_files_plugin = true

local files = require('mini.files')

files.setup()

local minifiles_toggle = function()
  if not MiniFiles.close() then
    MiniFiles.open(vim.api.nvim_buf_get_name(0))
  end
end

vim.keymap.set('n', '<space>e', minifiles_toggle, { desc = 'Open file explorer' })
