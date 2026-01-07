if vim.g.did_load_treesitter_plugin then
  return
end
vim.g.did_load_treesitter_plugin = true

-- Highlight is enabled automatically by Neovim when parsers are available
-- Disable for dart
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'dart',
  callback = function()
    vim.treesitter.stop()
  end,
})

-- Enable treesitter-based indentation (except for dart)
vim.api.nvim_create_autocmd('FileType', {
  pattern = '*',
  callback = function()
    local ft = vim.bo.filetype
    if ft ~= 'dart' and pcall(vim.treesitter.get_parser) then
      vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end
  end,
})

-- Incremental selection using vim.treesitter API
local function get_node_at_cursor()
  local ok, node = pcall(vim.treesitter.get_node)
  return ok and node or nil
end

local selection_node = nil

local function select_node(node)
  if not node then
    return
  end
  local sr, sc, er, ec = node:range()
  vim.api.nvim_buf_set_mark(0, '<', sr + 1, sc, {})
  vim.api.nvim_buf_set_mark(0, '>', er + 1, ec - 1, {})
  vim.cmd('normal! gv')
end

local function init_selection()
  local node = get_node_at_cursor()
  if node then
    selection_node = node
    select_node(node)
  end
end

local function node_incremental()
  if not selection_node then
    init_selection()
    return
  end
  local parent = selection_node:parent()
  if parent then
    selection_node = parent
    select_node(selection_node)
  end
end

local function node_decremental()
  if not selection_node then
    return
  end
  local child = selection_node:child(0)
  if child then
    selection_node = child
    select_node(selection_node)
  else
    selection_node = nil
    vim.cmd('normal! \027') -- ESC
  end
end

vim.keymap.set('n', '<C-space>', init_selection, { desc = 'Init treesitter selection' })
vim.keymap.set('x', '<C-space>', node_incremental, { desc = 'Expand treesitter selection' })
vim.keymap.set('x', '<bs>', node_decremental, { desc = 'Shrink treesitter selection' })
