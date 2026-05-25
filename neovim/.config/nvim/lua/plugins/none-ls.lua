return {
  'nvimtools/none-ls.nvim',
  config = function()
    local null_ls = require 'null-ls'
    null_ls.setup {
      sources = {
        null_ls.builtins.formatting.stylua,
        null_ls.builtins.code_actions.gitsigns,
        null_ls.builtins.completion.luasnip,
        null_ls.builtins.diagnostics.golangci_lint,
      },
    }

    vim.keymap.set('n', '<leader>fo', vim.lsp.buf.format, { desc = 'Format buffer' })
  end,
}
