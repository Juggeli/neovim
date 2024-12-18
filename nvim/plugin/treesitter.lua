if vim.g.did_load_treesitter_plugin then
  return
end
vim.g.did_load_treesitter_plugin = true

local configs = require('nvim-treesitter.configs')

---@diagnostic disable-next-line: missing-fields
configs.setup {
  highlight = {
    enable = true,
    disable = { 'dart' },
  },
  indent = {
    enable = true,
    disable = { 'dart' },
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = '<C-space>',
      node_incremental = '<C-space>',
      scope_incremental = false,
      node_decremental = '<bs>',
    },
  },
}
