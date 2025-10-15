local M = {}

function M.warning(message)
	vim.notify(message, vim.log.levels.WARN, {
		title = "Warning",
		timeout = 3000,
	})
end

return M
