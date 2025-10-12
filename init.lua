-- Get the custom nvim config name
-- from the parent folder of this init script
-- and make it a global variable
-- for use in lower levels of config
vim.g.custom_nvim_config_name = vim.fn.expand('<sfile>:h:t')

-- Load the base nvim-robotics config
-- whose name can be different from the custom nvim config name
require("nvim-robotics")
