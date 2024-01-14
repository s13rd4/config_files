return {
  { 'tpope/vim-sleuth' },
  {
    'folke/neodev.nvim',
    opts = {},
  },
  { 'theprimeagen/harpoon' },
  { -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    -- Enable `lukas-reineke/indent-blankline.nvim`
    -- See `:help ibl`
    main = 'ibl',
    opts = {},
  },
  {
    'numToStr/Comment.nvim',
    opts = {},
    lazy = false,
  },
  {
    'kevinhwang91/nvim-bqf',
    ft = 'qf',
    config = true
  },
  {
    'kylechui/nvim-surround',
    version = '*', -- Use for stability; omit to use `main` branch for the latest features
    event = 'VeryLazy',
    config = function()
      require('nvim-surround').setup {}
    end,
  },
  {
    'akinsho/toggleterm.nvim',
    config = true,
  },
}
