if vim.g.did_load_lsp_plugin then
  return
end
vim.g.did_load_lsp_plugin = true

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(event)
    local bufnr = event.buf
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    local builtin = require('telescope.builtin')
    local ivy = require('telescope.themes').get_ivy()

    local function desc(description)
      return { noremap = true, silent = true, buffer = bufnr, desc = description }
    end
    local keymap = vim.keymap
    keymap.set('n', '<leader>cl', '<cmd>LspInfo<cr>', desc('Lsp info'))
    keymap.set('n', 'gd', vim.lsp.buf.definition, desc('Goto definition'))
    keymap.set('n', 'gr', function()
      builtin.lsp_references(ivy)
    end, desc('References'))
    keymap.set('n', 'gI', vim.lsp.buf.implementation, desc('Goto implementation'))
    keymap.set('n', 'gy', vim.lsp.buf.type_definition, desc('Goto type definition'))
    keymap.set('n', 'gD', vim.lsp.buf.declaration, desc('Goto declaration'))
    keymap.set('n', 'P', vim.lsp.buf.hover, desc('Hover'))
    keymap.set('n', '<leader>k', vim.lsp.buf.signature_help, desc('Signature help'))
    keymap.set('i', '<C-k>', vim.lsp.buf.signature_help, desc('Signature help'))
    keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, desc('Code action'))
    keymap.set('n', '<leader>cc', vim.lsp.codelens.run, desc('Codelens run'))
    keymap.set('n', '<leader>cC', vim.lsp.codelens.refresh, desc('Codelens refresh'))
    keymap.set('n', '<leader>cr', vim.lsp.buf.rename, desc('Rename'))
    keymap.set('n', '<leader>fd', builtin.lsp_document_symbols, { desc = 'Document symbols' })
    keymap.set('n', '<leader>fs', builtin.lsp_dynamic_workspace_symbols, { desc = 'Workspace symbols' })

    if client and client.server_capabilities.inlayHintProvider then
      keymap.set('n', '<leader>uh', function()
        local current_setting = vim.lsp.inlay_hint.is_enabled { bufnr = bufnr }
        vim.lsp.inlay_hint.enable(not current_setting, { bufnr = bufnr })
      end, desc('Toggle inlay hints'))
    end

    -- Add rounded borders to hover and signature help
    vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, { border = 'rounded' })
    vim.lsp.handlers['textDocument/signatureHelp'] =
      vim.lsp.with(vim.lsp.handlers.signature_help, { border = 'rounded' })
  end,
})
