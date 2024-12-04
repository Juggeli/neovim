if vim.g.did_load_telescope_plugin then
  return
end
vim.g.did_load_telescope_plugin = true

local telescope = require('telescope')
local actions = require('telescope.actions')
local builtin = require('telescope.builtin')
local ivy = require('telescope.themes').get_ivy {
  cwd_only = true,
}

vim.keymap.set('n', '<leader>ff', function()
  require('telescope').extensions.smart_open.smart_open(ivy)
end, { desc = 'Find files' })

vim.keymap.set('n', '<leader>r', function()
  builtin.resume(ivy)
end, { desc = 'Resume last telescope' })

vim.keymap.set('n', '<leader>/', function()
  builtin.live_grep(ivy)
end, { desc = 'Grep (root dir)' })

vim.keymap.set('n', '<leader>fw', function()
  builtin.grep_string(ivy)
end, { desc = 'Grep string under cursor' })

vim.keymap.set('n', '<leader>fq', function()
  builtin.quickfix(ivy)
end, { desc = 'Quick fix list' })

vim.keymap.set('n', '<leader><space>', function()
  local buffers_ivy = require('telescope.themes').get_ivy {
    sort_mru = true,
    ignore_current_buffer = true,
  }
  builtin.buffers(buffers_ivy)
end, { desc = 'List open buffers' })

telescope.setup {
  defaults = {
    path_display = {
      'truncate',
    },
    mappings = {
      i = {
        ['<C-q>'] = actions.send_to_qflist,
        ['<C-l>'] = actions.send_to_loclist,
        ['<esc>'] = actions.close,
        ['<C-d>'] = require('telescope.actions').delete_buffer,
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
telescope.load_extension('smart_open')
