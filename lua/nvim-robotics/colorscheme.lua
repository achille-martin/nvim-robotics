-- ---------------
-- | COLORSCHEME |
-- ---------------

-- =============== MAIN COLORSCHEME ===============

-- # Load main colorscheme,
-- # selected for its high-contrast, futuristic feel
-- # and logical highlighting
-- # Note: changes to main colorscheme defaults
-- # can be done in the `plugins.lua` config,
-- # in which the colorscheme is loaded as plugin
-- # Another note: `silent!` enables to ignore errors
-- # if the colorscheme is not yet installed
vim.cmd("silent! colorscheme cyberdream")

-- =============== COLORSCHEME FIXES ===============

-- # Highlight the line number of the cursor
-- # so that it is clearly visible
vim.cmd(
    [[
        highlight CursorLineNr guibg=#FFFDD0 guifg=Black
    ]]
)

-- # Specify the highlight colour of search matches
-- # to ensure visibility
vim.cmd(
    [[
        highlight Search guibg=#F1FF5E guifg=Black
    ]]
)

-- # Setting bright colour
-- # for active status line
-- # to identify the focused window or buffer easily
vim.cmd(
    [[
        highlight StatusLine guibg=#FFFDD0 guifg=Black
    ]]
)
