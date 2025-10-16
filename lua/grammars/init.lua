local function discover_modules()
	local source = debug.getinfo(1, "S").source
	if source:sub(1, 1) == "@" then
		source = source:sub(2)
	end

	local directory = vim.fn.fnamemodify(source, ":h")
	local handle = vim.loop.fs_scandir(directory)
	if not handle then
		vim.notify(("Unable to scan Tree-sitter grammar modules in %s"):format(directory), vim.log.levels.WARN)
		return {}
	end

	local modules = {}
	while true do
		local name, entry_type = vim.loop.fs_scandir_next(handle)
		if not name then
			break
		end

		if entry_type == "file" and name:sub(-4) == ".lua" and name ~= "init.lua" then
			modules[#modules + 1] = "grammars." .. name:sub(1, -5)
		end
	end

	table.sort(modules)
	return modules
end

local function append_unique(list, value)
	for _, item in ipairs(list) do
		if item == value then
			return
		end
	end
	table.insert(list, value)
end

local function normalize_spec(spec)
	if type(spec) ~= "table" then
		return { ensure_installed = {}, options = {} }
	end

	local ensure = {}
	if type(spec.ensure_installed) == "table" then
		for _, parser in ipairs(spec.ensure_installed) do
			if type(parser) == "string" then
				table.insert(ensure, parser)
			end
		end
	end

	local options = {}
	if type(spec.options) == "table" then
		options = spec.options
	end

	return {
		ensure_installed = ensure,
		options = options,
	}
end

local aggregated = {
	ensure_installed = {},
	options = {},
}

for _, module_name in ipairs(discover_modules()) do
	local ok, spec = pcall(require, module_name)
	if ok then
		local normalized = normalize_spec(spec)
		for _, parser in ipairs(normalized.ensure_installed) do
			append_unique(aggregated.ensure_installed, parser)
		end
		if type(normalized.options) == "table" then
			aggregated.options = vim.tbl_deep_extend("force", aggregated.options, normalized.options)
		end
	else
		vim.notify(("Unable to load Tree-sitter grammar module %s: %s"):format(module_name, spec), vim.log.levels.WARN)
	end
end

return aggregated
