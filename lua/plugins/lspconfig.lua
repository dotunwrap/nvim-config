return {
	{
		"neovim/nvim-lspconfig",
		config = function()
			local registry = require("lsp")

			for server, spec in pairs(registry.servers) do
				local config = {}
				if type(spec.config) == "table" then
					config = vim.deepcopy(spec.config)
				end

				if type(spec.before_enable) == "function" then
					local result = spec.before_enable(server, config)
					if type(result) == "table" then
						config = result
					end
				end

				if type(spec.setup) == "function" then
					local result = spec.setup(server, config)
					if result == false then
						goto continue
					elseif type(result) == "table" then
						config = result
					end
				end

				if type(config) == "table" and next(config) ~= nil then
					vim.lsp.config(server, config)
				end

				if spec.enable ~= false then
					if vim.lsp.config[server] == nil then
						vim.notify(("No vim.lsp.config entry for %s"):format(server), vim.log.levels.WARN)
					else
						vim.lsp.enable(server)
						if type(spec.after_enable) == "function" then
							spec.after_enable(server)
						end
					end
				end

				::continue::
			end
		end,
	},
}
