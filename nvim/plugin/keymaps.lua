if vim.g.did_load_keymaps_plugin then
  return
end
vim.g.did_load_keymaps_plugin = true

local keymap = vim.keymap
local diagnostic = vim.diagnostic
local builtin = require('telescope.builtin')
local ivy = require('telescope.themes').get_ivy()

-- Move to window using the <ctrl> hjkl keys
keymap.set('n', '<C-h>', '<C-w>h', { desc = 'Go to left window', remap = true })
keymap.set('n', '<C-j>', '<C-w>j', { desc = 'Go to lower window', remap = true })
keymap.set('n', '<C-k>', '<C-w>k', { desc = 'Go to upper window', remap = true })
keymap.set('n', '<C-l>', '<C-w>l', { desc = 'Go to right window', remap = true })

-- Skip wrapped lines when moving up or down
keymap.set({ 'n', 'x' }, 'j', "v:count == 0 ? 'gj' : 'j'", { desc = 'Down', expr = true, silent = true })
keymap.set({ 'n', 'x' }, '<Down>', "v:count == 0 ? 'gj' : 'j'", { desc = 'Down', expr = true, silent = true })
keymap.set({ 'n', 'x' }, 'k', "v:count == 0 ? 'gk' : 'k'", { desc = 'Up', expr = true, silent = true })
keymap.set({ 'n', 'x' }, '<Up>', "v:count == 0 ? 'gk' : 'k'", { desc = 'Up', expr = true, silent = true })

-- Move Lines
keymap.set('n', '<A-j>', '<cmd>m .+1<cr>==', { desc = 'Move down' })
keymap.set('n', '<A-k>', '<cmd>m .-2<cr>==', { desc = 'Move up' })
keymap.set('i', '<A-j>', '<esc><cmd>m .+1<cr>==gi', { desc = 'Move down' })
keymap.set('i', '<A-k>', '<esc><cmd>m .-2<cr>==gi', { desc = 'Move up' })
keymap.set('v', '<A-j>', ":m '>+1<cr>gv=gv", { desc = 'Move down' })
keymap.set('v', '<A-k>', ":m '<-2<cr>gv=gv", { desc = 'Move up' })

-- Clear search with <esc>
keymap.set({ 'i', 'n' }, '<esc>', '<cmd>noh<cr><esc>', { desc = 'Escape and clear hlsearch' })

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
keymap.set('n', 'n', "'Nn'[v:searchforward].'zv'", { expr = true, desc = 'Next search result' })
keymap.set('x', 'n', "'Nn'[v:searchforward]", { expr = true, desc = 'Next search result' })
keymap.set('o', 'n', "'Nn'[v:searchforward]", { expr = true, desc = 'Next search result' })
keymap.set('n', 'N', "'nN'[v:searchforward].'zv'", { expr = true, desc = 'Prev search result' })
keymap.set('x', 'N', "'nN'[v:searchforward]", { expr = true, desc = 'Prev search result' })
keymap.set('o', 'N', "'nN'[v:searchforward]", { expr = true, desc = 'Prev search result' })

-- Save file
keymap.set({ 'i', 'x', 'n', 's' }, '<C-s>', '<cmd>w<cr><esc>', { desc = 'Save file' })

-- Keep visual selection when indenting
keymap.set('v', '<', '<gv')
keymap.set('v', '>', '>gv')

-- Commenting
keymap.set('n', 'gco', 'o<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>', { desc = 'Add comment below' })
keymap.set('n', 'gcO', 'O<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>', { desc = 'Add comment above' })

-- New file
keymap.set('n', '<leader>fn', '<cmd>enew<cr>', { desc = 'New file' })

-- Open location/quickfix list
keymap.set('n', '<leader>xl', '<cmd>lopen<cr>', { desc = 'Location list' })
keymap.set('n', '<leader>xq', '<cmd>copen<cr>', { desc = 'Quickfix list' })

-- Quickfix navigation
keymap.set('n', '[q', vim.cmd.cprev, { desc = 'Previous quickfix' })
keymap.set('n', ']q', vim.cmd.cnext, { desc = 'Next quickfix' })

-- Diagnostics
local severity = diagnostic.severity
keymap.set('n', '[d', diagnostic.goto_prev, { noremap = true, silent = true, desc = 'Previous diagnostic' })
keymap.set('n', ']d', diagnostic.goto_next, { noremap = true, silent = true, desc = 'Next diagnostic' })
keymap.set('n', '[e', function()
  diagnostic.goto_prev {
    severity = severity.ERROR,
  }
end, { noremap = true, silent = true, desc = 'Previous error' })
keymap.set('n', ']e', function()
  diagnostic.goto_next {
    severity = severity.ERROR,
  }
end, { noremap = true, silent = true, desc = 'Next error' })
keymap.set('n', '[w', function()
  diagnostic.goto_prev {
    severity = severity.WARN,
  }
end, { noremap = true, silent = true, desc = 'Previous warning' })
keymap.set('n', ']w', function()
  diagnostic.goto_next {
    severity = severity.WARN,
  }
end, { noremap = true, silent = true, desc = 'Next warning' })
keymap.set('n', '[h', function()
  diagnostic.goto_prev {
    severity = severity.HINT,
  }
end, { noremap = true, silent = true, desc = 'Previous Hint' })
keymap.set('n', ']h', function()
  diagnostic.goto_next {
    severity = severity.HINT,
  }
end, { noremap = true, silent = true, desc = 'Next Hint' })

-- Toggle options
local function toggle_spell_check()
  if vim.opt.spell then
    vim.opt.spell = false
  else
    vim.opt.spell = true
  end
end
local function toggle_word_wrap()
  if vim.wo.wrap then
    vim.wo.wrap = false
  else
    vim.wo.wrap = true
  end
end
keymap.set('n', '<leader>us', toggle_spell_check, { noremap = true, silent = true, desc = 'Toggle spelling' })
keymap.set('n', '<leader>uw', toggle_word_wrap, { desc = 'Toggle word wrap' })

-- Fast scrolling
keymap.set('n', '<S-j>', '10j', { desc = 'Scroll down' })
keymap.set('n', '<S-k>', '10k', { desc = 'Scroll up' })

-- Disable horizontal scrolling with mouse
keymap.set('n', '<ScrollWheelRight>', '<Nop>')
keymap.set('n', '<ScrollWheelLeft>', '<Nop>')
keymap.set('n', '<S-ScrollWheelUp>', '<ScrollWheelRight>')
keymap.set('n', '<S-ScrollWheelDown>', '<ScrollWheelLeft>')

-- Disable replacing clipboard on change
keymap.set('n', 'c', '"_c', { desc = 'Change without replacing clipboard' })
keymap.set('n', 'C', '"_C', { desc = 'Change without replacing clipboard' })

-- Windows
keymap.set('n', '<leader>ww', '<C-W>p', { desc = 'Other window', remap = true })
keymap.set('n', '<leader>wd', '<C-W>c', { desc = 'Delete window', remap = true })
keymap.set('n', '<leader>w-', '<C-W>s', { desc = 'Split window below', remap = true })
keymap.set('n', '<leader>w|', '<C-W>v', { desc = 'Split window right', remap = true })
keymap.set('n', '<leader>-', '<C-W>s', { desc = 'Split window below', remap = true })
keymap.set('n', '<leader>|', '<C-W>v', { desc = 'Split window right', remap = true })

-- Quit
keymap.set('n', '<leader>qq', '<cmd>qa<cr>', { desc = 'Quit all' })

-- Show diagnostics
keymap.set('n', '<leader>xx', function()
  local ivy_diagnostics = require('telescope.themes').get_ivy {
    sort_by = 'severity',
  }
  builtin.diagnostics(ivy_diagnostics)
end, { desc = 'Show Diagnostics' })

keymap.set('n', '<leader>d', '<cmd>lua vim.diagnostic.open_float()<CR>', { desc = 'Show diagnostics float' })

-- Show keymaps
keymap.set('n', '<leader>uk', function()
  builtin.keymaps(ivy)
end, { desc = 'Show keymaps' })

-- Don't move cursor on yank
keymap.set('x', 'y', 'ygv<Esc>', { noremap = true, silent = true })

-- Move cursor with scroll wheel
keymap.set('n', '<ScrollWheelUp>', 'k', { desc = 'Scroll up with mouse wheel' })
keymap.set('n', '<ScrollWheelDown>', 'j', { desc = 'Scroll down with mouse wheel' })

-- Auto indent on empty line.
vim.keymap.set('n', 'i', function()
  return string.match(vim.api.nvim_get_current_line(), '%g') == nil and 'cc' or 'i'
end, { expr = true, noremap = true })
