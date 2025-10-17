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

-- HANDY VARIABLES

-- # Define handy variables for plugin management via vim-plug

local plugs_install_path = table.concat{
    vim.env.HOME,
    "/.config/",
    vim.g.custom_nvim_config_name,
    "/autoload/plugs",
}
local Plug = vim.fn['plug#']

-- DOWNLOADED/INSTALLED PLUGINS

-- # List plugins downloaded/installed via vim-plug

vim.call('plug#begin', plugs_install_path)
    Plug 'windwp/nvim-autopairs'
    Plug 'scottmckendry/cyberdream.nvim'
vim.call('plug#end')

-- SETUP/ACTIVATED PLUGINS

-- # List plugins setup/activated

require("nvim-autopairs").setup({})
-- # Improve the cyberdream colorscheme experience
-- # by referring to the official setup config:
-- # https://github.com/scottmckendry/cyberdream.nvim?tab=readme-ov-file#%EF%B8%8F-configuring
require("cyberdream").setup({
    -- # Prevent use of colorscheme terminal colours
    -- # to not clash with custom terminal setup
    terminal_colors = false,
    -- # Update colors to tweak some relative contrasts
    colors = {
        -- # Modify colours for the dark mode only
        dark = {
            -- # Update foreground (white) to Off-White
            fg = "#FAF9F6",
            -- # Update comments (grey) to Steel Grey
            grey = "#71797E",
            -- # Update blue to Cornflower Blue
            blue = "#6699FF",
            -- # Update green to Jade
            green = "#00A36C",
            -- # Update cyan to Vivid Cyan
            cyan = "#11F2A3",
            -- # Update magenta to Vivid Magenta
            magenta = "#FF2BF5",
            -- # Update pink to Darker Salmon
            pink = "#F07162",
            -- # Update orange to Shade of Brown
            orange = "#F2AB38",
            -- # Update purple to Amaranth Deep Purple
            purple = "#AD15AD",
        }
    },
})
