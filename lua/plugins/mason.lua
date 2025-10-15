return {
	{ "mason-org/mason.nvim", opts = {} },
	{
		"mason-org/mason-lspconfig.nvim",
		opts = function()
			local lsp = require("lsp")
			return {
				ensure_installed = lsp.ensure_installed,
			}
		end,
		dependencies = {
			{ "mason-org/mason.nvim", opts = {} },
			"neovim/nvim-lspconfig",
		},
	},
}
