return {
	{
		"sudormrfbin/cheatsheet.nvim",
		keys = {
			{
				"<leader>fc",
				function()
					require("cheatsheet").show_cheatsheet()
				end,
				desc = "Find commands",
			},
		},
		dependencies = { "nvim-lua/plenary.nvim", lazy = true },
	},
}
