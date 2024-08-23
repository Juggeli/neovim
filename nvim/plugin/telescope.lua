if vim.g.did_load_telescope_plugin then
  return
end
vim.g.did_load_telescope_plugin = true

local telescope = require('telescope')
local actions = require('telescope.actions')
local builtin = require('telescope.builtin')

--- Like live_grep, but fuzzy (and slower)
local function fuzzy_grep(opts)
  opts = vim.tbl_extend('error', opts or {}, { search = '', prompt_title = 'Fuzzy grep' })
  builtin.grep_string(opts)
end

vim.keymap.set('n', '<leader>ff', function()
  builtin.find_files()
end, { desc = 'Find files' })
vim.keymap.set('n', '<leader><space>', function()
  builtin.find_files()
end, { desc = 'Find files' })
vim.keymap.set('n', '<leader>fr', builtin.oldfiles, { desc = 'Find Recent Files' })
vim.keymap.set('n', '<leader>/', builtin.live_grep, { desc = 'Grep (Root Dir)' })
vim.keymap.set('n', '<leader>fg', fuzzy_grep, { desc = 'Fuzzy Grep (Root Dir)' })
vim.keymap.set('n', '<leader>fw', builtin.grep_string, { desc = 'Grep Current String' })
vim.keymap.set('n', '<leader>fq', builtin.quickfix, { desc = 'Quick Fix List' })

telescope.setup {
  defaults = {
    path_display = {
      'truncate',
    },
    layout_strategy = 'vertical',
    mappings = {
      i = {
        ['<C-q>'] = actions.send_to_qflist,
        ['<C-l>'] = actions.send_to_loclist,
        ['<esc>'] = actions.close,
      },
      n = {
        q = actions.close,
      },
    },
    preview = {
      treesitter = true,
    },
    history = {
      path = vim.fn.stdpath('data') .. '/telescope_history.sqlite3',
      limit = 1000,
    },
    color_devicons = true,
    set_env = { ['COLORTERM'] = 'truecolor' },
    prompt_prefix = '   ',
    selection_caret = '  ',
    entry_prefix = '  ',
    initial_mode = 'insert',
    vimgrep_arguments = {
      'rg',
      '-L',
      '--color=never',
      '--no-heading',
      '--with-filename',
      '--line-number',
      '--column',
      '--smart-case',
    },
  },
  extensions = {
    fzy_native = {
      override_generic_sorter = false,
      override_file_sorter = true,
    },
  },
  pickers = {
    oldfiles = {
      cwd_only = true,
    },
  },
}

telescope.load_extension('fzy_native')
