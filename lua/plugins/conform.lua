return {
	{
		"stevearc/conform.nvim",
		opts = {
			formatters = {
				{
					name = "prettierd",
					timeout = 5000,
				},
			},
			formatters_by_ft = {
				astro = { "prettierd", stop_after_first = true },
				lua = { "stylua" },
				javascript = { "prettierd", stop_after_first = true },
				rust = { "rustfmt", lsp_format = "fallback" },
				typescript = { "prettierd", stop_after_first = true },
			},
			format_on_save = {
				timeout_ms = 500,
				lsp_format = "fallback",
			},
		},
	},
}
