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
  words = { enabled = true },
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

local keymap = vim.keymap

keymap.set('n', '<leader>gf', function()
  Snacks.lazygit.log_file()
end, { desc = 'Lazygit current file history' })

keymap.set('n', '<leader>gg', function()
  Snacks.lazygit()
end, { desc = 'Lazygit' })

keymap.set('n', '<leader>gl', function()
  Snacks.lazygit.log()
end, { desc = 'Lazygit log (cwd)' })

keymap.set({ 'n', 't' }, ']]', function()
  Snacks.words.jump(vim.v.count1)
end, { desc = 'Next reference' })

keymap.set({ 'n', 't' }, '[[', function()
  Snacks.words.jump(-vim.v.count1)
end, { desc = 'Prev reference' })

keymap.set('n', '<leader>n', function()
  Snacks.notifier.show_history()
end, { desc = 'Notification history' })

keymap.set('n', '<leader>bd', function()
  Snacks.bufdelete()
end, { desc = 'Delete buffer' })

keymap.set('n', '<leader>cR', function()
  Snacks.rename.rename_file()
end, { desc = 'Rename file' })

keymap.set('n', '<leader>.', function()
  Snacks.scratch()
end, { desc = 'Toggle scratch buffer' })

keymap.set('n', '<leader>S', function()
  Snacks.scratch.select()
end, { desc = 'Select scratch buffer' })

keymap.set('n', '<leader>n', function()
  Snacks.notifier.show_history()
end, { desc = 'Notification history' })

keymap.set('n', '<leader>gB', function()
  Snacks.gitbrowse()
end, { desc = 'Git browse' })

keymap.set('n', '<leader>un', function()
  Snacks.notifier.hide()
end, { desc = 'Dismiss all notifications' })
