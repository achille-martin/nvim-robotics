-- ------------------
-- | INITIALISATION |
-- ------------------

-- # Ensure that key mappings are loaded first
-- # so that they are applied to the rest of the configuration
require("nvim-robotics.keymaps")
-- # Ensure that the options are set very high in the priority list
-- # so that they are applied for all subsequent config settings
require("nvim-robotics.options")
-- # Ensure that the plugins are loaded before the colorscheme
-- # and other plugin config
-- # so that the plugins are actually loaded first
require("nvim-robotics.plugins")
-- # Ensure that the colorscheme is loaded last
-- # so that all visual modifications are effective
-- # based on this config
require("nvim-robotics.colorscheme")
