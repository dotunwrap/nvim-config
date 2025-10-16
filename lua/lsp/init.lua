local module_utils = require("utils.modules")

local function normalize_server_entry(entry)
	if type(entry) ~= "table" then
		return {
			config = {},
			enable = true,
		}
	end

	local normalized = vim.deepcopy(entry)

	if type(normalized.config) ~= "table" then
		normalized.config = {}
	end

	if type(normalized.opts) == "table" then
		normalized.config = vim.tbl_deep_extend("force", normalized.config, normalized.opts)
		normalized.opts = nil
	end

	if type(normalized.enable) ~= "boolean" then
		normalized.enable = true
	end

	return normalized
end

local function normalize_spec(spec)
	if type(spec) ~= "table" then
		return { ensure_installed = {}, servers = {} }
	end

	local ensure = {}
	if type(spec.ensure_installed) == "table" then
		for _, server in ipairs(spec.ensure_installed) do
			if type(server) == "string" then
				table.insert(ensure, server)
			end
		end
	end

	local servers = {}
	if type(spec.servers) == "table" then
		for server, config in pairs(spec.servers) do
			if type(server) == "string" then
				servers[server] = normalize_server_entry(config)
			end
		end
	end

	return {
		ensure_installed = ensure,
		servers = servers,
	}
end

return module_utils.collect({
	namespace = "lsp",
	source = debug.getinfo(1, "S").source,
	default = {
		ensure_installed = {},
		servers = {},
	},
	normalize = normalize_spec,
	merge = function(aggregated, spec)
		for _, server in ipairs(spec.ensure_installed or {}) do
			module_utils.append_unique(aggregated.ensure_installed, server)
		end
		for server, config in pairs(spec.servers or {}) do
			aggregated.servers[server] = config
		end
	end,
})
