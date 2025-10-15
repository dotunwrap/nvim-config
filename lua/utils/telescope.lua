local logger = require("utils.notify")

local M = {}

M.state = {
	pickers = {
		find_files = {
			show_hidden = false,
			callable = require("telescope.builtin").find_files,
		},
		file_browser = {
			show_hidden = false,
			callable = require("telescope").extensions.file_browser.file_browser,
		},
	},
}

local prompt_title_picker_name_map = {
	["Find Files"] = "find_files",
	["File Browser"] = "file_browser",
}

function M.translate_prompt_title_to_picker_name(prompt_title)
	if not prompt_title_picker_name_map[prompt_title] then
		vim.warning(string.format("Failed to translate prompt_title to picker name for %s", prompt_title))
		return
	end

	return prompt_title_picker_name_map[prompt_title]
end

local function set_hidden_flag(prompt_bufnr, hidden)
	local picker = require("telescope.actions.state").get_current_picker(prompt_bufnr)
	local opts = {}

	require("telescope.actions").close(prompt_bufnr)

	if picker and picker.cwd then
		opts.cwd = picker.cwd
	end

	local picker_name = M.translate_prompt_title_to_picker_name(picker.prompt_title) or nil

	if not picker_name then
		logger.warning(string.format("Failed to get picker_name for %s", picker.prompt_title))
	end

	if M.state.pickers[picker_name] and M.state.pickers[picker_name].show_hidden ~= nil then
		M.state.pickers[picker_name].show_hidden = hidden
	end
	opts.hidden = hidden

	M.state.pickers[picker_name].callable(opts)
end

-- Close and relaunch the picker showing hidden files
function M.show_hidden(prompt_bufnr)
	set_hidden_flag(prompt_bufnr, true)
end

-- Close and relaunch the picker without showing hidden files
function M.hide_hidden(prompt_bufnr)
	set_hidden_flag(prompt_bufnr, false)
end

-- Close and relaunch the picker toggling hidden files
function M.toggle_hidden(prompt_bufnr)
	local picker = require("telescope.actions.state").get_current_picker(prompt_bufnr)

	if not picker then
		logger.warning("Failed to retrieve picker")
		return
	end

	if not picker.prompt_title then
		logger.warning("Failed to retrieve picker's prompt_title")
	end

	local picker_name = M.translate_prompt_title_to_picker_name(picker.prompt_title)
	if not picker_name then
		return
	end

	local show_hidden = (M.state.pickers[picker_name] or {}).show_hidden
	if show_hidden == nil then
		vim.warning(string.format("No `show_hidden` state for picker %s", picker_name))
	end

	set_hidden_flag(prompt_bufnr, not show_hidden)
end

return M
