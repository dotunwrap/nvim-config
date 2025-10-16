# Ez Neovim Config

This setup exists because I needed the same tooling I run under Nix, but on a machine where that isn't allowed. It's a regular ol' Lua configuration.

## Table of Contents
- [General Information](#general-information)
    - [Plugins](#plugins)
    - [LSP Servers](#lsp-servers)
- [Installation](#installation)

## General Information
- Plain Lua config, no frameworks wrapped around it
- lazy.nvim bootstrap with versions pinned in `lazy-lock.json`
- Stylua pre-commit hook keeps Lua files tidy

### Plugins

lazy.nvim manages the plugins. Some highlights of the configured plugins include:

- mason.nvim
- blink.cmp
- telescope.nvim
- trouble.nvim
- aerial.nvim
- conform.nvim
- gitsigns.nvim
- toggleterm.nvim

### LSP Servers

Mason and lspconfig handle LSP server management. A list of some out-of-the-box servers include:

- lua_ls
- tsserver
- astro
- tailwindcss
- terraformls
- sqlls
- bashls
- yamlls

## Installation
- Clone the repo into `~/.config/nvim`
- Launch Neovim once to trigger lazy.nvim bootstrap
- Run `:Mason` and install any missing language servers as needed
