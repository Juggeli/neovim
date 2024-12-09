if vim.g.did_load_snacks_plugin then
  return
end
vim.g.did_load_snacks_plugin = true

local builtin = require('telescope.builtin')
local ivy = require('telescope.themes').get_ivy {
  cwd_only = true,
}

require('snacks').setup {
  notifier = { enabled = true },
  bigfile = { enabled = true },
  dashboard = {
    preset = {
      keys = {
        {
          icon = ' ',
          key = 'f',
          desc = 'Find File',
          action = function()
            require('telescope').extensions.smart_open.smart_open(ivy)
          end,
        },
        { icon = ' ', key = 'n', desc = 'New File', action = ':ene | startinsert' },
        {
          icon = ' ',
          key = 'g',
          desc = 'Find Text',
          action = function()
            builtin.live_grep(ivy)
          end,
        },
        { icon = ' ', key = 'q', desc = 'Quit', action = ':qa' },
      },
    },
    sections = {
      { section = 'header' },
      { section = 'keys', gap = 1, padding = 1 },
    },
  },
}
