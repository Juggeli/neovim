if vim.g.did_load_mini_plugin then
  return
end
vim.g.did_load_mini_plugin = true

require('mini.comment').setup()
require('mini.surround').setup()
require('mini.indentscope').setup {
  symbol = '│',
}
require('mini.icons').setup()
MiniIcons.mock_nvim_web_devicons()
