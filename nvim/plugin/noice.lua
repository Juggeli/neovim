if vim.g.did_load_noice_plugin then
  return
end
vim.g.did_load_noice_plugin = true

require('noice').setup {
  lsp = {
    -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
    override = {
      ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
      ['vim.lsp.util.stylize_markdown'] = true,
      ['cmp.entry.get_documentation'] = true, -- requires hrsh7th/nvim-cmp
    },
    -- progress = {
    --   enabled = false,
    -- },
    hover = {
      enabled = false,
    },
    signature = {
      enabled = false,
    },
  },
  -- you can enable a preset for easier configuration
  presets = {
    bottom_search = true, -- use a classic bottom cmdline for search
    command_palette = true, -- position the cmdline and popupmenu together
    long_message_to_split = true, -- long messages will be sent to a split
    inc_rename = false, -- enables an input dialog for inc-rename.nvim
    lsp_doc_border = false, -- add a border to hover docs and signature help
  },
}

vim.keymap.set('n', '<leader>sn', '', { desc = '+noice' })
vim.keymap.set('n', '<leader>snl', function()
  require('noice').cmd('last')
end, { desc = 'Noice Last Message' })
vim.keymap.set('n', '<leader>snh', function()
  require('noice').cmd('history')
end, { desc = 'Noice History' })
vim.keymap.set('n', '<leader>sna', function()
  require('noice').cmd('all')
end, { desc = 'Noice All' })
vim.keymap.set('n', '<leader>snd', function()
  require('noice').cmd('dismiss')
end, { desc = 'Dismiss All' })
vim.keymap.set('n', '<leader>snt', function()
  require('noice').cmd('pick')
end, { desc = 'Noice Picker (Telescope/FzfLua)' })
vim.keymap.set({ 'n', 'i', 's' }, '<c-f>', function()
  if not require('noice.lsp').scroll(4) then
    return '<c-f>'
  end
end, { silent = true, expr = true })
vim.keymap.set({ 'n', 'i', 's' }, '<c-b>', function()
  if not require('noice.lsp').scroll(-4) then
    return '<c-b>'
  end
end, { silent = true, expr = true })
