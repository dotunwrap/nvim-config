return {
	ensure_installed = { "mdx_analyzer" },
	servers = {
		mdx_analyzer = {
			config = {
				init_options = {
					typescript = {
						enabled = true,
					},
				},
			},
		},
	},
}
