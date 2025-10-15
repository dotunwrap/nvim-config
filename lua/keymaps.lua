vim.keymap.set("n", "gd", function()
	vim.lsp.buf.definition({
		on_list = function(options)
			-- custom logic to avoid showing multiple definition when you use this style of code:
			-- `local M.my_fn_name = function() ... end`.
			-- See also post here: https://www.reddit.com/r/neovim/comments/19cvgtp/any_way_to_remove_redundant_definition_in_lua_file/

			-- vim.print(options.items)
			local unique_defs = {}
			local def_loc_hash = {}

			-- each item in options.items contain the location info for a definition provided by LSP server
			for _, def_location in pairs(options.items) do
				-- use filename and line number to uniquelly indentify a definition,
				-- we do not expect/want multiple definition in single line!
				local hash_key = def_location.filename .. def_location.lnum

				if not def_loc_hash[hash_key] then
					def_loc_hash[hash_key] = true
					table.insert(unique_defs, def_location)
				end
			end

			options.items = unique_defs

			-- set the location list
			---@diagnostic disable-next-line: param-type-mismatch
			vim.fn.setloclist(0, {}, " ", options)

			-- open the location list when we have more than 1 definitions found,
			-- otherwise, jump directly to the definition
			if #options.items > 1 then
				vim.cmd.lopen()
			else
				vim.cmd([[silent! lfirst]])
			end
		end,
	})
end, { noremap = true, silent = true })

vim.keymap.set("v", "<Tab>", ">gv", { noremap = true, silent = true })
vim.keymap.set("v", "<S-Tab>", "<gv", { noremap = true, silent = true })
