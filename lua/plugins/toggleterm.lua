return {
  {
    'akinsho/toggleterm.nvim',
    version = '*',
    cmd = 'ToggleTerm',
    build = ':ToggleTerm',
    opts = {
      open_mapping = [[<C-'>]],
    },
    keys = {
      {
        '<C-\'>',
        function() require('toggleterm').toggle() end,
        desc = 'Toggle terminal',
      },
      {
        '<leader>tf',
        function() require('toggleterm').toggle(nil, nil, nil, 'float') end,
        desc = 'Spawn floating terminal',
      },
      {
        '<leader>th',
        function() require('toggleterm').toggle(nil, nil, nil, 'horizontal') end,
        desc = 'Spawn horizontal terminal',
      },
      {
        '<leader>tv',
        function() require('toggleterm').toggle(nil, nil, nil, 'vertical') end,
        desc = 'Spawn vertical terminal',
      },
    },
  },
}
