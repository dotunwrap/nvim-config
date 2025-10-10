return {
	{
		'nvim-mini/mini.ai',
		version = '*',
		config = function()
			require('mini.ai').setup()
		end,
	},
	{
		'nvim-mini/mini.basics',
		version = '*',
		config = function() require('mini.basics').setup() end
	},
	{
		'nvim-mini/mini.bufremove',
		version = '*',
		config = function() require('mini.bufremove').setup() end,
    keys = {
      {
        '<leader>bc',
        function() require('mini.bufremove').delete() end,
        desc = 'Close current buffer',
      },
    },
	},
	{
		'nvim-mini/mini.comment',
		version = '*',
		config = function()
			require('mini.comment').setup()
		end,
	},
	{
		'nvim-mini/mini.jump2d',
		version = '*',
		config = function()
			require('mini.jump2d').setup()
		end,
	},
	{
		'nvim-mini/mini.notify',
		version = '*',
		config = function()
			require('mini.notify').setup()
		end,
	},
	{
		'nvim-mini/mini.pairs',
		version = '*',
		config = function()
			require('mini.pairs').setup()
		end,
	},
	{
		'nvim-mini/mini.splitjoin',
		version = '*',
		config = function()
			require('mini.splitjoin').setup()
		end,
	},
	{
		'nvim-mini/mini.starter',
		version = '*',
		config = function()
			require('mini.starter').setup({
				header = '勇者ヒンメルならそうした'
			})
		end,
	},
	{
		'nvim-mini/mini.statusline',
		version = '*',
		config = function()
			require('mini.statusline').setup()
		end,
	},
	{
		'nvim-mini/mini.surround',
		version = '*',
		config = function()
			require('mini.surround').setup()
		end,
	},
	{
		'nvim-mini/mini.tabline',
		version = '*',
		config = function()
			require('mini.tabline').setup()
		end,
	},
}
