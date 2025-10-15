local M = {}

M.config = {
	gruvbox = function()
		return "gruvbox"
	end,
}

M.set = function(colorscheme)
	vim.cmd.colorscheme(M.config[colorscheme]())
end

return M
