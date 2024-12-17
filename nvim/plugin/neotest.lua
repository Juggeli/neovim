if vim.g.did_load_neotest_plugin then
  return
end
vim.g.did_load_neotest_plugin = true

local neotest = require('neotest')

neotest.setup {
  adapters = {
    require('neotest-dart'),
  },
}

vim.keymap.set('n', '<leader>tt', function()
  vim.cmd('write')
  neotest.run.run()
end, { desc = 'Run Nearest Test' })

vim.keymap.set('n', '<leader>tf', function()
  vim.cmd('write')
  neotest.run.run(vim.fn.expand('%'))
end, { desc = 'Run All Tests in File' })

vim.keymap.set('n', '<leader>to', function()
  neotest.output_panel.toggle()
end, { desc = 'Open Test Output' })

vim.keymap.set('n', '<leader>th', function()
  neotest.output.open()
end, { desc = 'Open Test Output Hover' })
