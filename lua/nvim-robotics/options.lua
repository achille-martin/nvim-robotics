-- -------------------
-- | GENERAL OPTIONS |
-- -------------------

-- =============== FILETYPE MANAGEMENT ===============

-- AUTOMATIC CONFIG

-- # Load default/automatic filetype config
-- # which detects the filetype (e.g. python)
-- # and applies specific config/rules to the file
vim.cmd("filetype indent plugin on")
-- # Load default syntax highlighting config
vim.cmd("syntax on")

-- SPELLCHECK

-- # Force disable spellcheck on all filetypes
-- # to then be able to select specific filetypes
vim.opt.spell = false
-- # Select languages for spellchecking
vim.opt.spelllang = "en_gb"
-- # Select list of filetypes
-- # to enable spellcheck for
local spell_filetypes = {
    "text",
    "markdown"
}
-- # Create group for spellchecking
vim.api.nvim_create_augroup(
    "SpellCheck",
    { clear = true }
)
-- # Define an autocommand
-- # to enable spellcheck for the relevant group
-- # and for the desired filetypes only
-- # As a bonus, spelling suggestions are also enabled
-- # when using autocompletion (only valid for the conditions stated above)
vim.api.nvim_create_autocmd(
    { "FileType" },
    {
        group = "SpellCheck",
        pattern = spell_filetypes,
        callback = function()
            vim.opt_local.spell = true
            vim.opt_local.complete = vim.opt_local.complete + "kspell"
        end,
        desc = "Enable spellcheck for defined filetypes",
    }
)

-- =============== TEXT DISPLAY ===============

-- CURSOR

-- # Create group for cursor management
local cursor_management_group = vim.api.nvim_create_augroup(
    "CursorManagement",
    { clear = true }
)
-- # Define vimscript function to restore cursor position
-- # when reading a file into the buffer
-- # and centering the screen around the cursor when relevant
-- # but excluding specific file types and buffer types
-- # (vimscript function because lua function slower)
vim.api.nvim_exec(
    [[
        function! RestoreCursorPosition()
            " If the last edit position is set
            " and is less than the number of lines in this buffer
            " and the current file is not for editing commits
            " and the buffer is not the help,
            " or quickfix, or terminal, or even a nofile
            " Note: the \" mark is the cursor position
            " when last exited the file
            if line("'\"")
                \ && line("'\"") <= line("$")
                \ && &filetype != "gitcommit"
                \ && &buftype != "help"
                \ && &buftype != "nofile"
                \ && &buftype != "quickfix"
                \ && &buftype != "terminal"
                " Adding a short delay helps unfreeze
                " the first few frames of buffer opening
                " after jumping to mark
                " execute "normal! g`\""
                call timer_start(1, {tid -> execute("normal! g`\"")})
                " To force centre screen around cursor, uncomment below
                " call timer_start(1, {tid -> execute("normal! zz")})
                return 1
            endif
        endfunction
    ]],
    false
)
-- # Create autocommand to restore cursor position
-- # when reading a file into the buffer
-- # (vimscript used here because does not work in lua otherwise)
vim.api.nvim_exec(
    [[
        autocmd CursorManagement BufReadPost * call RestoreCursorPosition()
    ]],
    false
)
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

-- MATCH

-- # Highlight all matches on previous search pattern
vim.opt.hlsearch = true
-- # Specify the highlight colour of search matches
-- # to ensure visibility
vim.cmd(
    [[
        highlight Search guibg=Yellow guifg=Black
    ]]
)

-- SCROLL

-- # Set the minimal number of screen lines to keep
-- # above and below the cursor
-- # By default, setting the value to 2 lines
-- # is optimal for any language
-- # and does not disturb user experience much
vim.opt.scrolloff = 2

-- BOUNDARIES

-- # Highlight the column 80
-- # which corresponds to standard EMACS screen size
-- # and is part of PEP8 style guide
vim.opt.colorcolumn = "80"
-- # Force text wrapping if line is longer than screen size
vim.opt.wrap = true
-- # Display wrapped lines as visually indented
-- # (same amount of space as the beginning of that line)
-- # for visual consistency
vim.opt.breakindent = true

-- SYNTAX

-- # Ensure that full text is shown normally
-- # and that no block of text is replaced by a character
-- # For instance, full link syntax is shown in markdown
vim.opt.conceallevel = 0
-- # Create group for syntax cleanup
local syntax_cleanup_group = vim.api.nvim_create_augroup(
    "SyntaxCleanup",
    { clear = true }
)
-- # Auto-remove trailing whitespace in the whole file
-- # just before writing to Buffer,
-- # maintain cursor position,
-- # do not flag errors,
-- # and do not add anything to the search history
-- # (do not modify the last substitute pattern or substitute string)
vim.api.nvim_create_autocmd(
    "BufWritePre",
    {
        group = "SyntaxCleanup",
        desc = "Maintain win bar when unfocused",
        pattern = "*",
        callback = function()
            local curpos = vim.api.nvim_win_get_cursor(0)
            vim.cmd([[keeppatterns %s/\s\+$//ge]])
            vim.api.nvim_win_set_cursor(0, curpos)
	    end,
    }
)


-- =============== WINDOW DISPLAY ===============

-- TABLINE

-- # Specify whether the window tab line (at the top of the screen)
-- # should be displayed, or only under specific conditions
-- # By default, for a consistent window design,
-- # the window tab line is always displayed
vim.opt.showtabline = 2

-- STATUS COLUMN

-- # Ensure that all 3 columns are displayed
-- # in the status column:
-- # * Signs
-- # * Absolute number
-- # * Relative number
vim.opt.statuscolumn = "%s %{v:lnum} %{v:relnum}"
-- # Show absolute number of each line
-- # on the left side of the text area
vim.opt.number = true
-- # Show relative number of lines
-- # around the current line
-- # on the right of absolute numbers
-- # for easier navigation
vim.opt.relativenumber = true
-- # Show sign column on the left of number column
vim.opt.signcolumn = "yes"

-- COMMAND LINE

-- # Set the number of screen lines to use for the command-line
vim.opt.cmdheight = 1
-- # Hide mode information in command line
-- # since it is already displayed in the status line
vim.opt.showmode = false

-- WINDOW SPLITS

-- # When splitting window horizontally,
-- # show newest window on top
vim.opt.splitbelow = false
-- # When splitting window vertically,
-- # show newest window to the right
vim.opt.splitright = true

-- WINDOW TITLE

-- # Prevent update of the terminal window title
-- # so that terminal settings are maintained
vim.opt.title = false

-- STATUS LINE

-- # Always show a statusline in the previously focused window
vim.opt.laststatus = 2
-- # Mode identification
-- # according to the Neovim documentation
local modes = {
    ["n"] = "NORMAL",
    ["v"] = "VISUAL",
    ["V"] = "VISUAL LINE",
    ["CTRL-V"] = "VISUAL BLOCK",
    ["s"] = "SELECT",
    ["S"] = "SELECT LINE",
    ["CTRL-S"] = "SELECT BLOCK",
    ["i"] = "INSERT",
    ["ic"] = "INSERT",
    ["R"] = "REPLACE",
    ["Rv"] = "VIRTUAL REPLACE",
    ["c"] = "COMMAND",
    ["cv"] = "VIM EX",
    ["r"] = "PROMPT",
    ["rm"] = "MORE PROMPT",
    ["r?"] = "CONFIRM",
    ["!"] = "SHELL",
    ["t"] = "TERMINAL",
}
-- # Mode display from nvim identifier
local function mode()
    local current_mode = vim.api.nvim_get_mode().mode
    return string.format(" %s ", modes[current_mode])
end
-- # Current working directory display
-- # including shortened home directory
local function pwd()
    local cwd_path = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:~")
    return string.format(" [cwd: %%<%s] ", cwd_path)
end
-- # Filepath display
-- # restricted to parent folder path
-- # including shortened home directory
-- # Note that path may be truncated if too long
-- # For more information about `filename-modifiers`,
-- # refer to the Neovim documentation
local function filepath()
    local fpath = vim.fn.fnamemodify(vim.fn.expand "%", ":p:~:h")
    return string.format(" [%%<%s/] ", fpath)
end
-- # Filename display
-- # including a space at the end for aesthetics
local function filename()
    local fname = vim.fn.expand "%:t"
    return fname .. " "
end
-- # Cursor location information
-- # including line, column and percentage of page
local function cursorinfo()
    return " Line:%l | Col:%c | %P "
end
-- # Status line building
-- # including an active state when page focused
-- # and an inactive state when page unfocused
Statusline = {}
-- # Active status for status line
Statusline.active = function()
    return table.concat {
        "%#Statusline#",
        mode(),
        "%#Normal# ",
        pwd(),
        "%=%#StatusLineExtra#",
        cursorinfo(),
    }
end
-- # Inactive status for status line
function Statusline.inactive()
    return ""
end
-- # Group definition for status line
local statusline_group = vim.api.nvim_create_augroup(
    "Statusline",
    { clear = true }
)
-- # Function execution for status line
-- # when focusing on a new window or buffer
vim.api.nvim_create_autocmd(
    { "WinEnter", "BufEnter" },
    {
        group = statusline_group,
        desc = "Activate statusline on focus",
        callback = function()
            vim.opt_local.statusline = "%!v:lua.Statusline.active()"
        end,
    }
)
-- # Setting bright colour
-- # for active status line
-- # to identify the focused window or buffer easily
vim.cmd(
    [[
        highlight StatusLine guibg=Yellow guifg=Black
    ]]
)

-- # Function execution for status line
-- # when leaving a window or buffer
vim.api.nvim_create_autocmd(
    { "WinLeave", "BufLeave" },
    {
        group = statusline_group,
        desc = "Deactivate statusline when unfocused",
        callback = function()
            vim.opt_local.statusline = "%!v:lua.Statusline.inactive()"
        end,
    }
)

-- WINBAR

-- # Winbar (window bar, right under the tab line) building
-- # including an active state when page focused
-- # and an inactive state when page unfocused
Winbar = {}
-- # Active status for winbar
-- # showing absolute file path for buffer
function Winbar.active()
    return "%F"
end
-- # Inactive status for winbar
-- # similar to active status
function Winbar.inactive()
    return "%F"
end
-- # Group definition for winbar
local winbar_group = vim.api.nvim_create_augroup(
    "Winbar",
    { clear = true }
)
-- # Function execution for winbar
-- # when focusing on a new window or buffer
vim.api.nvim_create_autocmd(
    { "WinEnter", "BufEnter" },
    {
        group = winbar_group,
        desc = "Refresh win bar on focus",
        callback = function()
            vim.opt_local.winbar = "%!v:lua.Winbar.active()"
        end,
    }
)
-- # Function execution for winbar
-- # when leaving a window or buffer
vim.api.nvim_create_autocmd(
    { "WinLeave", "BufLeave" },
    {
        group = winbar_group,
        desc = "Maintain win bar when unfocused",
        callback = function()
            vim.opt_local.winbar = "%!v:lua.Winbar.inactive()"
        end,
    }
)

-- =============== CONTROL ===============

-- MOUSE

-- # Enable mouse controls in all modes
-- # so that it can be used seamlessly alongside the keyboard
vim.opt.mouse = "a"

-- =============== MEMORY MANAGEMENT ===============

-- CLIPBOARD

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

-- SWAP FILES

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

-- BACKUP FILES

-- # Do not keep backups of edited files
-- # Backups represent the original file before it was edited and overwritten
-- # Backups are saved in the current directory or in the folder (if created):
-- # `~/.local/state/<nvim_name>/backup//` but they might take a lot of space
-- # It is recommended to use a versioning tool (e.g. git)
-- # to keep track of changes
vim.opt.backup = false
vim.opt.writebackup = false

-- ENCODING

-- # Set the output encoding shown in terminal to UTF-8
-- # which is a Unicode format universally praised
-- # thanks to its backwards-compatibility with ASCII,
-- # its wide character bank (defined by unique code points),
-- # its storage efficiency, and its technical robustness
vim.opt.encoding = "utf-8"
-- # Set the output encoding of the file that is written
-- # to UTF-8 for consistency
vim.opt.fileencoding = "utf-8"

-- =============== INDENTATION ===============

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

-- =============== TABULATION ===============

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

-- =============== SEARCH ===============

-- # Ignore case of normal letters when searching
vim.opt.ignorecase = true
-- # Override the `ignorecase` option
-- # if the search pattern contains upper case characters
vim.opt.smartcase = true
-- # Search as characters are entered
-- # to get live feedback while typing (faster search)
vim.opt.incsearch = true

-- =============== AUTO-COMPLETION ===============

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

