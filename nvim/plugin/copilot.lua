if vim.g.did_load_copilot_plugin then
  return
end
vim.g.did_load_copilot_plugin = true

require('copilot').setup {
  panel = {
    enabled = false,
  },
  suggestion = {
    enabled = true,
    auto_trigger = false,
    hide_during_completion = true,
    debounce = 75,
    keymap = {
      accept = '<C-y>',
      accept_word = false,
      accept_line = false,
      next = false,
      prev = false,
      dismiss = '<C-d>',
    },
  },
}

vim.keymap.set('i', '<C-]>', function()
  require('cmp').close()
  require('copilot.suggestion').next()
end, { desc = 'Show Next Copilot Suggestion' })

vim.keymap.set('i', '<C-[>', function()
  require('cmp').close()
  require('copilot.suggestion').prev()
end, { desc = 'Show Previous Copilot Suggestion' })
