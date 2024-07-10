if vim.g.did_load_keymaps_plugin then
  return
end
vim.g.did_load_keymaps_plugin = true

local keymap = vim.keymap
local diagnostic = vim.diagnostic

local function bufremove(buf)
  buf = buf or 0
  buf = buf == 0 and vim.api.nvim_get_current_buf() or buf

  if vim.bo.modified then
    local choice = vim.fn.confirm(('Save changes to %q?'):format(vim.fn.bufname()), '&Yes\n&No\n&Cancel')
    if choice == 0 or choice == 3 then -- 0 for <Esc>/<C-c> and 3 for Cancel
      return
    end
    if choice == 1 then -- Yes
      vim.cmd.write()
    end
  end

  for _, win in ipairs(vim.fn.win_findbuf(buf)) do
    vim.api.nvim_win_call(win, function()
      if not vim.api.nvim_win_is_valid(win) or vim.api.nvim_win_get_buf(win) ~= buf then
        return
      end
      -- Try using alternate buffer
      local alt = vim.fn.bufnr('#')
      if alt ~= buf and vim.fn.buflisted(alt) == 1 then
        vim.api.nvim_win_set_buf(win, alt)
        return
      end

      -- Try using previous buffer
      local has_previous = pcall(vim.cmd, 'bprevious')
      if has_previous and buf ~= vim.api.nvim_win_get_buf(win) then
        return
      end

      -- Create new listed buffer
      local new_buf = vim.api.nvim_create_buf(true, false)
      vim.api.nvim_win_set_buf(win, new_buf)
    end)
  end
  if vim.api.nvim_buf_is_valid(buf) then
    pcall(vim.cmd, 'bdelete! ' .. buf)
  end
end

-- better up/down
keymap.set({ 'n', 'x' }, 'j', "v:count == 0 ? 'gj' : 'j'", { desc = 'Down', expr = true, silent = true })
keymap.set({ 'n', 'x' }, '<Down>', "v:count == 0 ? 'gj' : 'j'", { desc = 'Down', expr = true, silent = true })
keymap.set({ 'n', 'x' }, 'k', "v:count == 0 ? 'gk' : 'k'", { desc = 'Up', expr = true, silent = true })
keymap.set({ 'n', 'x' }, '<Up>', "v:count == 0 ? 'gk' : 'k'", { desc = 'Up', expr = true, silent = true })

-- Buffer list navigation
keymap.set('n', '<S-h>', vim.cmd.bprevious, { silent = true, desc = 'Previous Buffer' })
keymap.set('n', '<S-l>', vim.cmd.bnext, { silent = true, desc = 'Next Buffer' })
keymap.set('n', '<leader>bd', bufremove, { desc = 'Delete Buffer' })

-- Move to window using the <ctrl> hjkl keys
keymap.set('n', '<C-h>', '<C-w>h', { desc = 'Go to Left Window', remap = true })
keymap.set('n', '<C-j>', '<C-w>j', { desc = 'Go to Lower Window', remap = true })
keymap.set('n', '<C-k>', '<C-w>k', { desc = 'Go to Upper Window', remap = true })
keymap.set('n', '<C-l>', '<C-w>l', { desc = 'Go to Right Window', remap = true })

-- Skip wrapped lines when moving up or down
keymap.set({ 'n', 'x' }, 'j', "v:count == 0 ? 'gj' : 'j'", { desc = 'Down', expr = true, silent = true })
keymap.set({ 'n', 'x' }, '<Down>', "v:count == 0 ? 'gj' : 'j'", { desc = 'Down', expr = true, silent = true })
keymap.set({ 'n', 'x' }, 'k', "v:count == 0 ? 'gk' : 'k'", { desc = 'Up', expr = true, silent = true })
keymap.set({ 'n', 'x' }, '<Up>', "v:count == 0 ? 'gk' : 'k'", { desc = 'Up', expr = true, silent = true })

-- Move Lines
keymap.set('n', '<A-j>', '<cmd>m .+1<cr>==', { desc = 'Move Down' })
keymap.set('n', '<A-k>', '<cmd>m .-2<cr>==', { desc = 'Move Up' })
keymap.set('i', '<A-j>', '<esc><cmd>m .+1<cr>==gi', { desc = 'Move Down' })
keymap.set('i', '<A-k>', '<esc><cmd>m .-2<cr>==gi', { desc = 'Move Up' })
keymap.set('v', '<A-j>', ":m '>+1<cr>gv=gv", { desc = 'Move Down' })
keymap.set('v', '<A-k>', ":m '<-2<cr>gv=gv", { desc = 'Move Up' })

-- Clear search with <esc>
keymap.set({ 'i', 'n' }, '<esc>', '<cmd>noh<cr><esc>', { desc = 'Escape and Clear hlsearch' })

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
keymap.set('n', 'n', "'Nn'[v:searchforward].'zv'", { expr = true, desc = 'Next Search Result' })
keymap.set('x', 'n', "'Nn'[v:searchforward]", { expr = true, desc = 'Next Search Result' })
keymap.set('o', 'n', "'Nn'[v:searchforward]", { expr = true, desc = 'Next Search Result' })
keymap.set('n', 'N', "'nN'[v:searchforward].'zv'", { expr = true, desc = 'Prev Search Result' })
keymap.set('x', 'N', "'nN'[v:searchforward]", { expr = true, desc = 'Prev Search Result' })
keymap.set('o', 'N', "'nN'[v:searchforward]", { expr = true, desc = 'Prev Search Result' })

-- Save file
keymap.set({ 'i', 'x', 'n', 's' }, '<C-s>', '<cmd>w<cr><esc>', { desc = 'Save File' })

-- Better indenting
keymap.set('v', '<', '<gv')
keymap.set('v', '>', '>gv')

-- Commenting
keymap.set('n', 'gco', 'o<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>', { desc = 'Add Comment Below' })
keymap.set('n', 'gcO', 'O<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>', { desc = 'Add Comment Above' })

-- New file
keymap.set('n', '<leader>fn', '<cmd>enew<cr>', { desc = 'New File' })

-- Open location/quickfix list
keymap.set('n', '<leader>xl', '<cmd>lopen<cr>', { desc = 'Location List' })
keymap.set('n', '<leader>xq', '<cmd>copen<cr>', { desc = 'Quickfix List' })

-- Quickfix navigation
keymap.set('n', '[q', vim.cmd.cprev, { desc = 'Previous Quickfix' })
keymap.set('n', ']q', vim.cmd.cnext, { desc = 'Next Quickfix' })

-- Diagnostics
local severity = diagnostic.severity
keymap.set('n', '[d', diagnostic.goto_prev, { noremap = true, silent = true, desc = 'Previous Diagnostic' })
keymap.set('n', ']d', diagnostic.goto_next, { noremap = true, silent = true, desc = 'Next Diagnostic' })
keymap.set('n', '[e', function()
  diagnostic.goto_prev {
    severity = severity.ERROR,
  }
end, { noremap = true, silent = true, desc = 'Previous Error' })
keymap.set('n', ']e', function()
  diagnostic.goto_next {
    severity = severity.ERROR,
  }
end, { noremap = true, silent = true, desc = 'Next Error' })
keymap.set('n', '[w', function()
  diagnostic.goto_prev {
    severity = severity.WARN,
  }
end, { noremap = true, silent = true, desc = 'Previous Warning' })
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
keymap.set('n', '<leader>us', toggle_spell_check, { noremap = true, silent = true, desc = 'Toggle Spelling' })
keymap.set('n', '<leader>uw', toggle_word_wrap, { desc = 'Toggle Word Wrap' })

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
keymap.set('n', '<leader>ww', '<C-W>p', { desc = 'Other Window', remap = true })
keymap.set('n', '<leader>wd', '<C-W>c', { desc = 'Delete Window', remap = true })
keymap.set('n', '<leader>w-', '<C-W>s', { desc = 'Split Window Below', remap = true })
keymap.set('n', '<leader>w|', '<C-W>v', { desc = 'Split Window Right', remap = true })
keymap.set('n', '<leader>-', '<C-W>s', { desc = 'Split Window Below', remap = true })
keymap.set('n', '<leader>|', '<C-W>v', { desc = 'Split Window Right', remap = true })

-- Quit
keymap.set('n', '<leader>qq', '<cmd>qa<cr>', { desc = 'Quit All' })

keymap.set('n', '<leader>xx', function()
  require('mini.extra').pickers.diagnostic()
end, { desc = 'Show Diagnostics' })
