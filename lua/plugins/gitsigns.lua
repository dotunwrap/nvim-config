return {
	{
		"lewis6991/gitsigns.nvim",
		keys = {
			{
				"<leader>gb",
				function()
					require("gitsigns").blame_line()
				end,
				desc = "Git blame line",
			},
			{
				"<leader>gd",
				function()
					require("gitsigns").diffthis()
				end,
				desc = "Git diff",
			},
		},
	},
}
