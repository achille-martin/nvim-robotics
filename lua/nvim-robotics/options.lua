-- GENERAL OPTIONS

-- ///// INDENTATION \\\\\
-- # Enable the copy of indent from current line when starting a new line
-- # Note: press `Ctrl + d` to delete the indent on the new line
-- # General note: if the indentation includes a comment character / symbol
-- # from the previous line,
-- # remove the added character / symbol
-- # by pressing `Ctrl + w` (deletes the previous word) in INSERT mode
vim.opt.autoindent = true
-- # Set the number of columns that make up one level of (auto)indentation
-- # By default, 4 spaces is a good number across languages and file formats
vim.opt.shiftwidth = 4

-- ///// TABULATION \\\\\
-- # Set the number of column (or visual spaces) per tab character
-- # Neovim recommends to keep the number at 8 for display purposes
-- # However, for consistency purposes, a good default is 4
vim.opt.tabstop = 4
-- # Modify the behaviour of the tab and backspace keys
-- # Specify the amount of whitespace to be inserted
-- # when the tab key is pressed
-- # and the amount of whitespace to be removed
-- # when the backspace key is pressed
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
-- # Restrict the highlight of current cursor line
-- # to only the number on the left
vim.opt.cursorlineopt = "number"
-- # Highlight the line number of the cursor
-- # so that it is clearly visible
vim.cmd([[
    highlight CursorLineNr guibg=DarkGray guifg=Black
]])
-- # Highlight all matches on previous search pattern
vim.opt.hlsearch = true
-- # Set the minimal number of screen lines to keep
-- # above and below the cursor
-- # Keeping the vertical number consistent with the horizontal tab spacing
vim.opt.scrolloff = 4
-- # Highlight the column 80
-- # which corresponds to standard EMACS screen size
-- # and is part of PEP8 style guide
vim.opt.colorcolumn = "80"
-- # Ensure that full text is shown normally
-- # and that no block of text is replaced by a character
-- # For instance, full link syntax is shown in markdown
vim.opt.conceallevel = 0

-- ///// WINDOW DISPLAY \\\\\
-- # Specify whether the window tab line (at the top of the screen)
-- # should be displayed, or only under specific conditions
-- # By default, for a consistent window design,
-- # the window tab line is always displayed
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

-- # Keep swap files in the default location (defined in `vim.opt.directory`):
-- # `~/.local/state/<nvim_name>/swap//`
-- # Swap files are useful to retain latest unsaved changes to a file
-- # which has been closed unexpectedly by a crash
-- # They are also useful to prevent multiple users
-- # to edit the same file with the same editor
-- # If you need to recover the latest unsaved changes from a swap file,
-- # make sure that there is a (D) option in the swap text prompt
-- # because it means that no other user is editing the file
-- # and diff the swap / original files with:
-- # `:diffthis | :vnew | r # | exe "norm! ggdd" | :diffthis`
vim.opt.swapfile = true
-- # Do not keep backups of edited files
-- # Backups represent the original file before it was edited and overwritten
-- # Backups are saved in the current directory or in the folder (if created):
-- # `~/.local/state/<nvim_name>/backup//` but they might take a lot of space
-- # It is recommended to use a versioning tool (e.g. git)
-- # to keep track of changes
vim.opt.backup = false
vim.opt.writebackup = false
-- # Set the output encoding shown in terminal to UTF-8
-- # which is a Unicode format universally praised
-- # thanks to its backwards-compatibility with ASCII,
-- # its wide character bank (defined by unique code points),
-- # its storage efficiency, and its technical robustness
vim.opt.encoding = "utf-8"
-- # Set the output encoding of the file that is written
-- # to UTF-8 for consistency
vim.opt.fileencoding = "utf-8"
