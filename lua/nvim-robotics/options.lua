-- GENERAL OPTIONS

-- ///// TEXT DISPLAY \\\\\
-- # Highlight current horizontal cursor line
-- # Might make screen redrawing slower though
vim.opt.cursorline = true
-- # Restrict the highlight of current cursor line
-- # to only the number on the left
vim.opt.cursorlineopt = "number"
-- # Highlight the line number of the cursor
-- # so that it is clearly visible
vim.cmd(
    [[
        highlight CursorLineNr guibg=DarkGray guifg=Black
    ]]
)
-- # Highlight all matches on previous search pattern
vim.opt.hlsearch = true
-- # Specify the highlight colour of search matches
-- # to ensure visibility
vim.cmd(
    [[
        highlight Search guibg=Yellow guifg=Black
    ]]
)
-- # Set the minimal number of screen lines to keep
-- # above and below the cursor
-- # By default, setting the value to 2 lines
-- # is optimal for any language
-- # and does not disturb user experience much
vim.opt.scrolloff = 2
-- # Highlight the column 80
-- # which corresponds to standard EMACS screen size
-- # and is part of PEP8 style guide
vim.opt.colorcolumn = "80"
-- # Ensure that full text is shown normally
-- # and that no block of text is replaced by a character
-- # For instance, full link syntax is shown in markdown
vim.opt.conceallevel = 0
-- # Force text wrapping if line is longer than screen size
vim.opt.wrap = true

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
-- # When splitting window horizontally,
-- # show newest window on top
vim.opt.splitbelow = false
-- # When splitting window vertically,
-- # show newest window to the right
vim.opt.splitright = true
-- # Show sign column on the left of number column
vim.opt.signcolumn = "yes"

-- ///// CONTROL \\\\\
-- # Enable mouse controls in all modes
-- # so that it can be used seamlessly alongside the keyboard
vim.opt.mouse = "a"

-- ///// MEMORY MANAGEMENT \\\\\
-- # Share the system clipboard (`+` register)
-- # with neovim default register (`unnamed` register)
-- # so that copy, cut, and paste actions can be performed
-- # within neovim (`y`, `d`, and `p`)
-- # as well as outside neovim (`Ctrl + c`, `Ctrl + x`, and `Ctrl + v`)
-- # seamlessly
-- # Note that the neovim actions populate the `unnamed` and `+` registers
-- # but the actions outside of neovim only populate the `+` register
-- # However, the neovim paste action will now source from the `+` register
-- # Extra note: to reduce Neovim startup time,
-- # we can schedule the setting to be executed after `UiEnter`
-- # (when the user interface connects)
vim.schedule(
    function()
        vim.opt.clipboard = "unnamedplus"
    end
)
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

-- ///// SEARCH \\\\\
-- # Ignore case of normal letters when searching
vim.opt.ignorecase = true
-- # Override the `ignorecase` option
-- # if the search pattern contains upper case characters
vim.opt.smartcase = true
-- # Do not search as characters are entered
vim.opt.incsearch = false

-- ///// AUTO-COMPLETION \\\\\
-- # Set maximum number of items to show in the popup menu
-- # for autocompletion (via `Ctrl + p` or `Ctrl + n`)
-- # while in INSERT mode
-- # To avoid odd behaviours, the maximum space available is used
-- # for the popup menu
vim.opt.pumheight = 0
-- # Define the expected behaviour of the INSERT mode completion tool:
-- # Menu opens even if there is only one match
-- # Fuzzy match runs in the background so that it is more forgiving
-- # Matches are not inserted until the user decides to (e.g. with `enter`)
-- # More information about matches is provided in the preview window
vim.opt.completeopt = { "menu", "menuone", "noinsert", "fuzzy", "preview" }

-- ///// FORMATTING \\\\\
-- # Command to remove all trailing whitespace (key maps?)
