if vim.g.did_load_ai_plugin then
  return
end
vim.g.did_load_ai_plugin = true

local extras = require('mini.extra')
require('mini.ai').setup {
  n_lines = 500,
  custom_textobjects = {
    B = extras.gen_ai_spec.buffer(),
    D = extras.gen_ai_spec.diagnostic(),
    I = extras.gen_ai_spec.indent(),
    L = extras.gen_ai_spec.line(),
    N = extras.gen_ai_spec.number(),
  },
}
