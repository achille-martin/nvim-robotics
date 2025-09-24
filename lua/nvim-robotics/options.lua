-- GENERAL OPTIONS

-- ///// INDENTATION \\\\\
-- # Enable the copy of indent from current line when starting a new line
-- # Note: press `Ctrl + d` to delete the indent on the new line
-- # General note: if the indentation includes a comment character / symbol from the previous line,
-- # remove the added character / symbol by pressing `Ctrl + w` (deletes the previous word) in INSERT mode
vim.opt.autoindent = true
-- # Set the number of columns (or spaces) that make up one level of (auto)indentation
-- # By default, 4 spaces is a good number across languages and file formats
vim.opt.shiftwidth = 4

-- ///// TABULATION \\\\\
-- # Set the number of column (or visual spaces) per tab character
-- # Neovim recommends to keep the number at 8 for display purposes
-- # however, for consistency purposes, a good default is 4
vim.opt.tabstop = 4
-- # Modify the behaviour of the tab and backspace keys
-- # Specify the amount of whitespace to be inserted when the tab key is pressed
-- # and the amount of whitespace to be removed when the backspace key is pressed
-- # By default, 4 spaces is consistent with the `shiftwidth` option
vim.opt.softtabstop = 4
-- # Convert a tab into spaces
-- # when a whitespace command is executed or when the tab key is pressed
vim.opt.expandtab = true

-- ///// FORMATTING \\\\\
-- # Command to remove all trailing whitespace (key maps?)

-- ///// AUTO-COMPLETION \\\\\
-- #

-- ///// SEARCH \\\\\
-- # Ignore case of normal letters when searching
vim.opt.ignorecase = true
-- # Override the `ignorecase` option
-- # if the search pattern contains upper case characters
vim.opt.smartcase = true
-- # Do not search as characters are entered
vim.opt.incsearch = false

-- ///// TEXT DISPLAY \\\\\
-- # Highlight current horizontal cursor line
-- # Might make screen redrawing slower though
vim.opt.cursorline = true
-- # Highlight all matches on previous search pattern
vim.opt.hlsearch = true
-- # Set the minimal number of screen lines to keep
-- # above and below the cursor
vim.opt.scrolloff = 5

-- ///// WINDOW DISPLAY \\\\\
-- # Specify whether the window tab line (at the top of the screen)
-- # should be displayed, or only under specific conditions
-- # By default, for a consistent window design, the window tab line is always displayed
vim.opt.showtabline = 2
-- # Show absolute number of each line
-- # on the left side of the text area
vim.opt.number = true
-- # Do not show relative number of lines
-- # around the current line
-- # on the left side of the text area
vim.opt.relativenumber = false
-- # Set the number of screen lines to use for the command-line
vim.opt.cmdheight = 1

-- ///// MEMORY MANAGEMENT \\\\\
-- # Clipboard
-- # Swapfile
