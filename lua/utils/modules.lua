local M = {}

local function normalize_source(source)
	if type(source) ~= "string" then
		return nil
	end
	if source:sub(1, 1) == "@" then
		source = source:sub(2)
	end
	return source
end

local function resolve_directory(opts)
	if type(opts.directory) == "string" and opts.directory ~= "" then
		return opts.directory
	end

	if type(opts.source) ~= "string" or opts.source == "" then
		opts.source = debug.getinfo(3, "S").source
	end

	local source = normalize_source(opts.source)
	if not source then
		return nil
	end

	return vim.fn.fnamemodify(source, ":h")
end

function M.append_unique(list, value)
	for _, item in ipairs(list) do
		if item == value then
			return
		end
	end
	table.insert(list, value)
end

function M.discover(opts)
	opts = opts or {}
	local namespace = assert(opts.namespace, "modules.discover requires a namespace")
	local directory = resolve_directory(opts)
	if not directory then
		return {}
	end

	local handle = vim.loop.fs_scandir(directory)
	if not handle then
		vim.notify(("Unable to scan modules in %s"):format(directory), vim.log.levels.WARN)
		return {}
	end

	local modules = {}
	while true do
		local name, entry_type = vim.loop.fs_scandir_next(handle)
		if not name then
			break
		end

		if entry_type == "file" and name:sub(-4) == ".lua" and name ~= "init.lua" then
			modules[#modules + 1] = ("%s.%s"):format(namespace, name:sub(1, -5))
		end
	end

	table.sort(modules)
	return modules
end

function M.collect(opts)
	opts = opts or {}
	local namespace = assert(opts.namespace, "modules.collect requires a namespace")
	local modules = M.discover({
		namespace = namespace,
		source = opts.source,
		directory = opts.directory,
	})

	local aggregated = {}
	if type(opts.default) == "table" then
		aggregated = vim.deepcopy(opts.default)
	end

	local normalize = opts.normalize or function(spec)
		return spec
	end

	local merge = opts.merge
		or function(accumulated, spec)
			if type(spec) == "table" then
				for key, value in pairs(spec) do
					accumulated[key] = value
				end
			end
		end

	for _, module_name in ipairs(modules) do
		local ok, spec = pcall(require, module_name)
		if ok then
			local normalized = normalize(spec, module_name) or {}
			merge(aggregated, normalized, module_name)
		else
			vim.notify(("Unable to load module %s: %s"):format(module_name, spec), vim.log.levels.WARN)
		end
	end

	return aggregated
end

return M
