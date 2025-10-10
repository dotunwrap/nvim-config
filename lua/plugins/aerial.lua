return {
  {
    'stevearc/aerial.nvim',
    opts = {
      default_direction = 'prefer_left',
    },
    keys = {
      {
        '<leader>a',
        function() require('aerial').toggle({ focus = true, direction = 'left' }) end,
        desc = 'Toggle Aerial',
      },
    },
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'nvim-tree/nvim-web-devicons'
    },
  }
}
