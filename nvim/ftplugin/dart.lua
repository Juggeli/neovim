-- Exit if the language server isn't available
if vim.fn.executable('dart') ~= 1 then
  return
end

local root_files = {
  'pubspec.yaml',
}

vim.lsp.start {
  name = 'dartls',
  cmd = { 'dart', 'language-server', '--protocol=lsp' },
  root_dir = vim.fs.dirname(vim.fs.find(root_files, { upward = true })[1]),
  capabilities = require('user.lsp').make_client_capabilities(),
  init_options = {
    onlyAnalyzeProjectsWithOpenFiles = true,
    suggestFromUnimportedLibraries = true,
    closingLabels = true,
    outline = true,
    flutterOutline = true,
  },
  settings = {
    dart = {
      completeFunctionCalls = true,
      showTodos = true,
    },
  },
}
