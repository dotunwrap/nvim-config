return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "master",
		lazy = false,
		build = ":TSUpdate",
		config = function()
			local registry = require("grammars")
			local configs = require("nvim-treesitter.configs")
			local opts = vim.tbl_deep_extend("force", {
				ensure_installed = registry.ensure_installed,
				highlight = {
					enable = true,
				},
			}, registry.options or {})

			configs.setup(opts)
		end,
	},
}
