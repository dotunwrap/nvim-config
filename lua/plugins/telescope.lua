return {
	{
		'nvim-telescope/telescope.nvim',
		cmd = 'Telescope',
    keys = {
      {
        '<leader>ff',
        function() require('telescope.builtin').find_files() end,
        desc = 'Find files',
      },
      {
        '<leader>fg',
        function() require('telescope.builtin').live_grep() end,
        desc = 'Live grep',
      },
    },
		dependencies = {
			'nvim-telescope/telescope-symbols.nvim',
			{ 'nvim-lua/plenary.nvim', lazy = true },
		},
	},
	{
		'nvim-telescope/telescope-fzf-native.nvim',
		build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release -DCMAKE_POLICY_VERSION_MINIMUM=3.5 && cmake --build build --config Release',
		config = function()
			require('telescope').load_extension('fzf')
		end,
	},
	{
		'nvim-telescope/telescope-ui-select.nvim',
		config = function()
			require('telescope').load_extension('ui-select')
		end,
	},
}
