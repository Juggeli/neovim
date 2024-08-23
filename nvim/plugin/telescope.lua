if vim.g.did_load_telescope_plugin then
  return
end
vim.g.did_load_telescope_plugin = true

local telescope = require('telescope')
local actions = require('telescope.actions')
local builtin = require('telescope.builtin')

local ivy = require('telescope.themes').get_ivy()

vim.keymap.set('n', '<leader>ff', '<cmd>Telescope frecency workspace=CWD theme=ivy<cr>', { desc = 'Find files' })
vim.keymap.set('n', '<leader><space>', '<cmd>Telescope frecency workspace=CWD theme=ivy<cr>', { desc = 'Find files' })
vim.keymap.set('n', '<leader>fr', function()
  builtin.oldfiles(ivy)
end, { desc = 'Find Recent Files' })
vim.keymap.set('n', '<leader>/', function()
  builtin.live_grep(ivy)
end, { desc = 'Grep (Root Dir)' })
vim.keymap.set('n', '<leader>fw', function()
  builtin.grep_string(ivy)
end, { desc = 'Grep Current String' })
vim.keymap.set('n', '<leader>fq', function()
  builtin.quickfix(ivy)
end, { desc = 'Quick Fix List' })

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
    frecency = {
      show_filter_column = false,
      matcher = 'fuzzy',
    },
  },
  pickers = {
    oldfiles = {
      cwd_only = true,
    },
  },
}

telescope.load_extension('fzy_native')
telescope.load_extension('frecency')
