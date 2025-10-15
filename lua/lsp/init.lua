local function discover_modules()
	-- Discover sibling modules automatically so the directory drives configuration.
	local source = debug.getinfo(1, "S").source
	if source:sub(1, 1) == "@" then
		source = source:sub(2)
	end

	local directory = vim.fn.fnamemodify(source, ":h")
	local handle = vim.loop.fs_scandir(directory)
	if not handle then
		vim.notify(("Unable to scan LSP modules in %s"):format(directory), vim.log.levels.WARN)
		return {}
	end

	local modules = {}
	while true do
		local name, entry_type = vim.loop.fs_scandir_next(handle)
		if not name then
			break
		end

		if entry_type == "file" and name:sub(-4) == ".lua" and name ~= "init.lua" then
			modules[#modules + 1] = "lsp." .. name:sub(1, -5)
		end
	end

	table.sort(modules)
	return modules
end

local modules = discover_modules()

local function append_unique(list, value)
	for _, item in ipairs(list) do
		if item == value then
			return
		end
	end
	table.insert(list, value)
end

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

local aggregated = {
	ensure_installed = {},
	servers = {},
}

for _, module_name in ipairs(modules) do
	local ok, spec = pcall(require, module_name)
	if ok then
		local normalized = normalize_spec(spec)
		for _, server in ipairs(normalized.ensure_installed) do
			append_unique(aggregated.ensure_installed, server)
		end
		for server, config in pairs(normalized.servers) do
			aggregated.servers[server] = config
		end
	else
		vim.notify(("Unable to load LSP module %s: %s"):format(module_name, spec), vim.log.levels.WARN)
	end
end

return aggregated
