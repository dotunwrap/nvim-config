local modules = {
  'lsp.astro',
  'lsp.bash',
  'lsp.lua',
  'lsp.tailwindcss',
  'lsp.typescript',
  'lsp.yaml',
}

local function append_unique(list, value)
  for _, item in ipairs(list) do
    if item == value then
      return
    end
  end
  table.insert(list, value)
end

local function normalize_server_entry(entry)
  if type(entry) ~= 'table' then
    return {
      config = {},
      enable = true,
    }
  end

  local normalized = vim.deepcopy(entry)

  if type(normalized.config) ~= 'table' then
    normalized.config = {}
  end

  if type(normalized.opts) == 'table' then
    normalized.config = vim.tbl_deep_extend('force', normalized.config, normalized.opts)
    normalized.opts = nil
  end

  if type(normalized.enable) ~= 'boolean' then
    normalized.enable = true
  end

  return normalized
end

local function normalize_spec(spec)
  if type(spec) ~= 'table' then
    return { ensure_installed = {}, servers = {} }
  end

  local ensure = {}
  if type(spec.ensure_installed) == 'table' then
    for _, server in ipairs(spec.ensure_installed) do
      if type(server) == 'string' then
        table.insert(ensure, server)
      end
    end
  end

  local servers = {}
  if type(spec.servers) == 'table' then
    for server, config in pairs(spec.servers) do
      if type(server) == 'string' then
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
    vim.notify(('Unable to load LSP module %s: %s'):format(module_name, spec), vim.log.levels.WARN)
  end
end

return aggregated
