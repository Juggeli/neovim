-- Exit if the language server isn't available
if vim.fn.executable('dart') ~= 1 then
  return
end

require('flutter-tools').setup {
  lsp = {
    capabilities = require('user.lsp').make_client_capabilities(),
  },
}

vim.keymap.set('n', '<leader>rr', '<cmd>FlutterRun<cr>', { desc = 'Run flutter app' })
vim.keymap.set('n', '<leader>rR', '<cmd>FlutterRestart<cr>', { desc = 'Restart flutter app' })
vim.keymap.set('n', '<leader>rh', '<cmd>FlutterReload<cr>', { desc = 'Reload flutter app' })
vim.keymap.set('n', '<leader>rd', '<cmd>FlutterDevices<cr>', { desc = 'Run flutter app in selected device' })
vim.keymap.set('n', '<leader>rq', '<cmd>FlutterQuit<cr>', { desc = 'Quit running flutter app' })
vim.keymap.set('n', '<leader>re', '<cmd>FlutterEmulators<cr>', { desc = 'Run flutter app in selected emulator' })
