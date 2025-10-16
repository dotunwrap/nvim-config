return {
	{
		"nvim-telescope/telescope.nvim",
		cmd = "Telescope",
		opts = {
			defaults = {},
			pickers = {
				live_grep = {
					theme = "ivy",
				},
				find_files = {
					theme = "ivy",
					mappings = {
						i = {
							["<C-.>"] = function(prompt_bufnr)
								require("utils.telescope").toggle_hidden(prompt_bufnr)
							end,
						},
					},
				},
			},
			extensions = {
				file_browser = {
					theme = "ivy",
					mappings = {
						i = {
							["<C-.>"] = function(prompt_bufnr)
								require("utils.telescope").toggle_hidden(prompt_bufnr)
							end,
						},
					},
				},
			},
		},
		keys = {
			{
				"<leader>ff",
				function()
					require("telescope.builtin").find_files()
				end,
				desc = "Find files",
			},
			{
				"<leader>fg",
				function()
					require("telescope.builtin").live_grep()
				end,
				desc = "Live grep",
			},
		},
		dependencies = {
			"nvim-telescope/telescope-symbols.nvim",
			"nvim-lua/plenary.nvim",
		},
	},
	{
		"nvim-telescope/telescope-fzf-native.nvim",
		build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release -DCMAKE_POLICY_VERSION_MINIMUM=3.5 && cmake --build build --config Release",
		config = function()
			require("telescope").load_extension("fzf")
		end,
		dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
	},
	{
		"nvim-telescope/telescope-ui-select.nvim",
		config = function()
			require("telescope").load_extension("ui-select")
		end,
		dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
	},
	{
		"nvim-telescope/telescope-file-browser.nvim",
		config = function()
			require("telescope").load_extension("file_browser")
		end,
		keys = {
			{
				"<leader>ft",
				function()
					require("telescope").extensions.file_browser.file_browser()
				end,
				desc = "File tree",
			},
		},
		dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
	},
}
