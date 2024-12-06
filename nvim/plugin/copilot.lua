if vim.g.did_load_copilot_plugin then
  return
end
vim.g.did_load_copilot_plugin = true

require('img-clip').setup {
  default = {
    embed_image_as_base64 = false,
    prompt_for_file_name = false,
    drag_and_drop = {
      insert_mode = true,
    },
  },
}
require('copilot').setup {
  panel = {
    enabled = false,
  },
  suggestion = {
    enabled = false,
  },
}
require('render-markdown').setup {
  file_types = { 'markdown', 'Avante' },
}
require('avante_lib').load()
require('avante').setup {
  provider = 'copilot',
  auto_suggestions_provider = 'copilot',
  hints = { enabled = false },
}
