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

    local function desc(description)
      return { noremap = true, silent = true, buffer = bufnr, desc = description }
    end
    local keymap = vim.keymap
    keymap.set('n', '<leader>cl', '<cmd>LspInfo<cr>', desc('Lsp Info'))
    keymap.set('n', 'gd', vim.lsp.buf.definition, desc('Goto Definition'))
    keymap.set('n', 'gr', function()
      require('mini.extra').pickers.lsp { scope = 'references' }
    end, desc('References'))
    keymap.set('n', 'gI', vim.lsp.buf.implementation, desc('Goto Implementation'))
    keymap.set('n', 'gy', vim.lsp.buf.type_definition, desc('Goto Type Definition'))
    keymap.set('n', 'gD', vim.lsp.buf.declaration, desc('Goto Declaration'))
    keymap.set('n', 'P', vim.lsp.buf.hover, desc('Hover'))
    keymap.set('n', '<leader>k', vim.lsp.buf.signature_help, desc('Signature Help'))
    keymap.set('i', '<C-k>', vim.lsp.buf.signature_help, desc('Signature Help'))
    keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, desc('Code Action'))
    keymap.set('n', '<leader>cc', vim.lsp.codelens.run, desc('Codelens Run'))
    keymap.set('n', '<leader>cC', vim.lsp.codelens.refresh, desc('Codelens Refresh'))
    keymap.set('n', '<leader>cr', vim.lsp.buf.rename, desc('Rename'))
    keymap.set('n', '<leader>fd', builtin.lsp_document_symbols, { desc = 'Document Symbols' })
    keymap.set('n', '<leader>fs', builtin.lsp_dynamic_workspace_symbols, { desc = 'Workspace Symbols' })

    if client and client.server_capabilities.inlayHintProvider then
      keymap.set('n', '<leader>uh', function()
        local current_setting = vim.lsp.inlay_hint.is_enabled { bufnr = bufnr }
        vim.lsp.inlay_hint.enable(not current_setting, { bufnr = bufnr })
      end, desc('Toggle Inlay Hints'))
    end

    -- Add rounded borders to hover and signature help
    vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, { border = 'rounded' })
    vim.lsp.handlers['textDocument/signatureHelp'] =
      vim.lsp.with(vim.lsp.handlers.signature_help, { border = 'rounded' })

    -- The following two autocommands are used to highlight references of the
    -- word under your cursor when your cursor rests there for a little while.
    --    See `:help CursorHold` for information about when this is executed
    --
    -- When you move your cursor, the highlights will be cleared (the second autocommand).
    if client and client.server_capabilities.documentHighlightProvider then
      local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
      vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.document_highlight,
      })

      vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.clear_references,
      })

      vim.api.nvim_create_autocmd('LspDetach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
        callback = function(event2)
          vim.lsp.buf.clear_references()
          vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
        end,
      })
    end
  end,
})
