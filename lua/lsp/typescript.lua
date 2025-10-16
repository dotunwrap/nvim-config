return {
	ensure_installed = { "ts_ls" },
	servers = {
		ts_ls = {
			config = {
				filetypes = {
					"javascript",
					"javascriptreact",
					"javascript.jsx",
					"typescript",
					"typescriptreact",
					"typescript.tsx",
					"svelte",
					"vue",
					"astro",
				},
			},
		},
	},
}
