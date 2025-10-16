local module_utils = require("utils.modules")

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

return module_utils.collect({
	namespace = "grammars",
	source = debug.getinfo(1, "S").source,
	default = {
		ensure_installed = {},
		options = {},
	},
	normalize = normalize_spec,
	merge = function(aggregated, spec)
		for _, parser in ipairs(spec.ensure_installed or {}) do
			module_utils.append_unique(aggregated.ensure_installed, parser)
		end
		if type(spec.options) == "table" then
			aggregated.options = vim.tbl_deep_extend("force", aggregated.options, spec.options)
		end
	end,
})
