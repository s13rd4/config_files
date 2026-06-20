return {
  { 'tpope/vim-sleuth' },
  {
    -- replaces the archived neodev.nvim: types for the vim API + plugins,
    -- loaded on demand only in Lua files.
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        -- load luvit types when the `vim.uv` word is found
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },
  {
    -- Quick file marks / navigation. Keymaps live under <leader>m to avoid the
    -- tmux <C-hjkl> nav and the <leader>h git-hunk group.
    'theprimeagen/harpoon',
    keys = {
      { '<leader>ma', function() require('harpoon.mark').add_file() end, desc = 'Harpoon: add file' },
      { '<leader>mm', function() require('harpoon.ui').toggle_quick_menu() end, desc = 'Harpoon: menu' },
      { '<leader>1', function() require('harpoon.ui').nav_file(1) end, desc = 'Harpoon: file 1' },
      { '<leader>2', function() require('harpoon.ui').nav_file(2) end, desc = 'Harpoon: file 2' },
      { '<leader>3', function() require('harpoon.ui').nav_file(3) end, desc = 'Harpoon: file 3' },
      { '<leader>4', function() require('harpoon.ui').nav_file(4) end, desc = 'Harpoon: file 4' },
    },
  },
  {
    'kevinhwang91/nvim-bqf',
    ft = 'qf',
    config = true
  },
  {
    'akinsho/toggleterm.nvim',
    opts = {
      open_mapping = [[<c-\>]],
      direction = 'float',
    },
  },
}
