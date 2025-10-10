-- A personal neovim configuration from the ground up.
--
-- This is the first time I've written a configuration in regular lua and vimscript in a long time given my love for nix and nvf. This may be sloppy.
--
-- @author: Gabby Simpson <gabby@dotunwrap.dev>

-- CONFIG

local config = {
	theme = {
		colorscheme = 'gruvbox',
	},
}

-- INIT

vim.loader.enable()

require('globals')
require('options')
require('config.lazy')
require('keymaps')
require('colorschemes').set(config.theme.colorscheme)
