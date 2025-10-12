-- -----------
-- | PLUGINS |
-- -----------

-- =============== GUIDE ===============

-- PLUGIN MANAGER SELECTION

-- # Select your favourite plugin manager
-- # The one provided in this repo config is vim-plug, accessible via:
-- # https://github.com/junegunn/vim-plug
-- # This plugin manager is automatically installed
-- # and it is upgraded to the latest version available
-- # when the repo config is installed
-- #
-- # Note: to keep upgrading vim-plug, run `:PlugUpgrade`

-- PLUGIN DOWNLOAD/INSTALLATION

-- # Pick a plugin you wish to install
-- # (e.g. `https://github.com/windwp/nvim-autopairs`),
-- # head over to the list of plugins downloaded/installed in this file
-- # and add a line between the calls for `plug#begin` and `plug#end`
-- # (e.g. `Plug 'windwp/nvim-autopairs'`)
-- # Then, reload your config
-- # and install the new plugin with: `:PlugInstall`
-- # (leave window with `q`)

-- PLUGIN SETUP

-- # Once the desired plugin is installed,
-- # head over to the list of plugins setup/activated in this file
-- # and add a line to specify the setup and configuration of the plugin
-- # (e.g. `require("nvim-autopairs").setup()`)
-- # This step ensures that the plugin is actually loaded
-- # and ready to use

-- PLUGIN MANAGEMENT

-- # * Update a plugin with: `:PlugUpdate [<plugin_name>]`
-- # * Check the status of plugins with: `:PlugStatus`
-- # * Show the difference between current and latest version of a plugin
-- #   with: `:PlugDiff`

-- PLUGIN REMOVAL

-- # If you want to stop using a plugin,
-- # head over to the list of plugins downloaded/installed in this file
-- # and remove the line calling the plugin
-- # Furthermore, make sure to remove the line calling the setup of the plugin
-- # in the list of plugins setup/activated in this file
-- # Then, refresh the plugins via vim-plug with `:PlugClean`
-- #
-- # Note: you can either keep (press `Enter/N`) or remove (press `y`)
-- # the plug directory of the plugin

-- =============== PLUGIN MANAGEMENT ===============

-- Define handy variables for plugin management via vim-plug

local plugs_install_path = table.concat{
    vim.env.HOME,
    "/.config/",
    vim.g.custom_nvim_config_name,
    "/autoload/plugs",
}
local Plug = vim.fn['plug#']

-- List plugins downloaded/installed via vim-plug
vim.call('plug#begin', plugs_install_path)
    Plug 'windwp/nvim-autopairs'
vim.call('plug#end')

-- List plugins setup/activated
require("nvim-autopairs").setup({})
