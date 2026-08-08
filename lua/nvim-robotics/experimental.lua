-- ----------------
-- | EXPERIMENTAL |
-- ----------------

-- # Define as re-usable module

local M = {}

-- # Define re-usable variables

local fzf_intervention_flag = false

-- ========== SYNTAX HIGHLIGHTING ===========

-- # Custom log file syntax highlighting definition

vim.api.nvim_create_autocmd(
    { "BufRead", "BufNewFile" },
    {
        pattern = "*.log",
        callback = function()
            vim.bo.filetype = "my_custom_log"
        end,
    }
)

vim.api.nvim_create_autocmd("FileType", {
    pattern = "my_custom_log",
    callback = function()
        -- # Define syntax highlighting with regex
        -- # by order of application
        vim.cmd([[
            syntax match LogNumber /\v\d+/
            syntax region LogStringDoubleQuotes start=/"/ end=/"/
            syntax region LogStringSingleQuotes start=/'/ end=/'/
            syntax match LogOperator /\(<=\|>=\|==\|!=\|=\|<\|>\|+\|-\|*\|%\|&\)/
            syntax match LogBracketSquare /\[\|\]/
            syntax match LogBracketCircular /(\|)/
            syntax match LogBracketCurly /{\|}/
            syntax match LogInfo /\[\s*\(INFO\|info\)\s*\]/
            syntax match LogDebug /\[\s*\(DEBUG\|debug\)\s*\]/
            syntax match LogWarn /\[\s*\(WARN\|warn\|WARNING\|warning\)\s*\]/
            syntax match LogError /\[\s*\(ERR\|err\|ERROR\|error\)\s*\]/

            highlight default link LogOperator Operator
            highlight default link LogStringDoubleQuotes String
            highlight default link LogStringSingleQuotes String
        ]])
        -- # Define custom colours for specific groups
        -- # and try to re-use the colorscheme hues
        vim.api.nvim_set_hl(0, "LogNumber", {
            fg = "#F2AB38",
        })
        vim.api.nvim_set_hl(0, "LogBracketSquare", {
            fg = "#FF2BF5",
        })
        vim.api.nvim_set_hl(0, "LogBracketCircular", {
            fg = "#FF2BF5",
        })
        vim.api.nvim_set_hl(0, "LogBracketCurly", {
            fg = "#FF2BF5",
        })
        vim.api.nvim_set_hl(0, "LogInfo", {
            bg = "#6699FF",
        })
        vim.api.nvim_set_hl(0, "LogDebug", {
            bg = "#71797E",
        })
        vim.api.nvim_set_hl(0, "LogWarn", {
            bg = "#F07162",
        })
        vim.api.nvim_set_hl(0, "LogError", {
            bg = "#DE3163",
        })
    end,
})

-- # Custom rosinstall file syntax highlighting definition

vim.api.nvim_create_autocmd(
    { "BufRead", "BufNewFile" },
    {
        pattern = "*.rosinstall",
        callback = function()
            vim.bo.filetype = "my_custom_rosinstall"
        end,
    }
)

vim.api.nvim_create_autocmd("FileType", {
    pattern = "my_custom_rosinstall",
    callback = function()
        -- # Define syntax highlighting with regex
        -- # by order of application
        vim.cmd([[
            syntax region RosInstStringDoubleQuotes start=/"/ end=/"/
            syntax region RosInstStringSingleQuotes start=/'/ end=/'/
            syntax match RosInstBracketSquare /\[\|\]/
            syntax match RosInstBracketCircular /(\|)/
            syntax match RosInstBracketCurly /{\|}/
            syntax match RosInstDash /-/
            syntax match RosInstGitField /git:/
            syntax match RosInstLocalNameField /local-name:/
            syntax match RosInstUriField /uri:/
            syntax match RosInstVersionField /version:/
        ]])
        -- # Define custom colours for specific groups
        -- # and try to re-use the colorscheme hues
        vim.api.nvim_set_hl(0, "RosInstBracketSquare", {
            fg = "#FF2BF5",
        })
        vim.api.nvim_set_hl(0, "RosInstBracketCircular", {
            fg = "#FF2BF5",
        })
        vim.api.nvim_set_hl(0, "RosInstBracketCurly", {
            fg = "#FF2BF5",
        })
        vim.api.nvim_set_hl(0, "RosInstDash", {
            fg = "#FF2BF5",
        })
        vim.api.nvim_set_hl(0, "RosInstGitField", {
            fg = "#71797E",
        })
        vim.api.nvim_set_hl(0, "RosInstLocalNameField", {
            fg = "#6699FF",
        })
        vim.api.nvim_set_hl(0, "RosInstUriField", {
            fg = "#F2AB38",
        })
        vim.api.nvim_set_hl(0, "RosInstVersionField", {
            fg = "#DE3163",
        })
        vim.api.nvim_set_hl(0, "RosInstStringDoubleQuotes", {
            fg = "#00A36C",
        })
        vim.api.nvim_set_hl(0, "RosInstStringSingleQuotes", {
            fg = "#00A36C",
        })
    end,
})

-- ========== DISPLAY MANAGEMENT ===========

-- # Display a floating help window
function M.open_help()
    -- # Indicate loading of the help
    print("[SPECIAL] Opening help doc (if able)")

    -- # Define local handy variables
    local screen_width_percentage = 0.9
    local screen_height_percentage = 0.7

    -- # Define the text lines to display
    local lines = {
        " Welcome to the help doc",
        " =======================",
        "",
        "[Press `q` or `Esc` to close this window]",
        "",
        "Press `Ctrl + Space` to enter the special mode,",
        "and follow up with one of the following keys to perform quick actions:",
        "",
        "| Key    | Action                                                   |",
        "| ------ | -------------------------------------------------------- |",
        "| ======================= WINDOW MANAGEMENT ======================= |",
        "| `W`    | Create split (arrow for direction of split)              |",
        "| `w`    | Move to split (arrow for direction of movement)          |",
        "| `T`    | Create new tab                                           |",
        "| `t`    | Move to next tab (repeat to cycle through)               |",
        "| ======================== FILE MANAGEMENT ======================== |",
        "| `R`    | Reload lua config (only works with `.lua` nvim config)   |",
        "| `c`    | Copy locally (internal clipboard)                        |",
        "| `C`    | Copy globally (external clipboard)                       |",
        "| `a`    | Copy from local to global                                |",
        "| `z`    | Copy from global to local                                |",
        "| `v`    | Paste locally                                            |",
        "| `V`    | Paste globally                                           |",
        "| `x`    | Cut locally                                              |",
        "| `X`    | Cut globally                                             |",
        "| `s`    | Save file                                                |",
        "| `q`    | Close file (asking to save)                              |",
        "| `Q`    | Force close session (not asking to save)                 |",
        "| `Enter`| Redo action                                              |",
        "| `Back` | Undo action                                              |",
        "| ======================== LINE MANAGEMENT ======================== |",
        "| `+`    | Add line below                                           |",
        "| `-`    | Remove line below                                        |",
        "| `\"`    | Comment out / uncomment line                             |",
        "| `i`    | Fix indentation (for current file)                       |",
        "| ======================= SEARCH MANAGEMENT ======================= |",
        "| `F`    | Open the files picker (select a file to open)            |",
        "| `!`    | Show file history (list opened files)                    |",
        "| `g`    | Grep (word under cursor)                                 |",
        "| `G`    | Live grep (search any word)                              |",
        "| `f`    | Go to definition (word under cursor)                     |",
        "| `r`    | Open the reference finder (word under cursor)            |",
        "| `K`    | Show key maps (Work In Progress)                         |",
        "| `Tab`  | Show word completion (used in INSERT/COMMAND mode)       |",
        "| ====================== TERMINAL MANAGEMENT ====================== |",
        "| `e`    | Open new terminal in split below (`F2` to switch focus)  |",
        "| ======================= ERROR MANAGEMENT ======================== |",
        "| `d`    | Show line diagnostics                                    |",
        "| `D`    | Show file diagnostics                                    |",
        "| ===================== DEBUGGING MANAGEMENT ====================== |",
        "| `b`    | Toggle debugger breakpoint (on current line)             |",
        "| `B`    | Start debugger (if available for filetype)               |",
        "| `o`    | Show debugger variables                                  |",
        "| `O`    | Show debugger commands                                   |",
        "| ======================== GIT MANAGEMENT ========================= |",
        "| `S`    | Open git status                                          |",
        "| `M`    | Open git blame                                           |",
        "| ====================== MARKDOWN MANAGEMENT ====================== |",
        "| `p`    | Toggle markdown preview in separate web window           |",
        "| ======================== JSON MANAGEMENT ======================== |",
        "| `j`    | Prettify json file                                       |",
    }

    -- # Create an unlisted, scratch buffer (not saved to a file)
    -- # and set a name for uniqueness
    -- # (empty name here so that the title of the window does not show up)
    -- # NOTE: make sure that there is only one such buffer at a time
    local buf_name = " "
    local existing_buf = vim.fn.bufnr(buf_name)
    if existing_buf ~= -1 and vim.api.nvim_buf_is_valid(existing_buf) then
        return nil
    end
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_name(buf, buf_name)

    -- # Get the total screen dimensions to center the window
    local main_ui_info = vim.api.nvim_list_uis()[1]
    local screen_width = main_ui_info.width
    local screen_height = main_ui_info.height

    -- # Calculate dimensions to fit the window
    local win_width = math.ceil(screen_width * screen_width_percentage)
    local win_height = math.ceil(screen_height * screen_height_percentage)
    local row = math.ceil((screen_height - win_height) / 2)
    local col = math.ceil((screen_width - win_width) / 2)

    -- # Set configuration options for the floating window
    local win_opts = {
        relative = "editor",
        width = win_width,
        height = win_height,
        row = row,
        col = col,
        style = "minimal",
        border = "rounded",
    }

    -- # Open the window and focus it
    local win = vim.api.nvim_open_win(buf, true, win_opts)

    -- # Populate the buffer with the custom text
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

    -- # Set buffer options to make it read-only for text viewing
    vim.api.nvim_set_option_value("modifiable", false, { buf = buf })
    vim.api.nvim_set_option_value("buftype", "nofile", { buf = buf })

    -- # Create custom highlighting for the window
    vim.cmd([[
        highlight MyHelpDocBg guibg=#242424
        highlight MyHelpDocBorder guifg=#6699FF
    ]])
    vim.api.nvim_win_set_option(
        win,
        "winhighlight",
        "Normal:MyHelpDocBg,FloatBorder:MyHelpDocBorder"
    )
    -- # Set text highlighting to markdown
    vim.api.nvim_buf_set_option(buf, "filetype", "markdown")

    -- # Create a unique group to auto-close the buffer
    local auto_close_group = vim.api.nvim_create_augroup("AutoClose" .. win, { clear = true })

    -- # Create a function to close the window and clear the buffer
    local function close_and_clear()
        -- # Clarify closing action, except for fzf interventions
        if not fzf_intervention_flag then
            print("[SPECIAL] Closing help doc")
        end
        vim.schedule(function()
            if vim.api.nvim_win_is_valid(win) then
                vim.api.nvim_win_close(win, true)
            end
            if vim.api.nvim_buf_is_valid(buf) then
                -- # Delete the buffer to reset uniqueness
                vim.api.nvim_buf_delete(buf, { force = true })
            end
        end)
        -- # Delete the autocommand group to prevent redundant execution loops
        vim.api.nvim_del_augroup_by_id(auto_close_group)
        fzf_intervention_flag = false
    end

    -- # Trigger close and clear function
    -- # when the cursor switches windows or the buffer loses focus
    vim.api.nvim_create_autocmd({ "WinLeave", "BufLeave" }, {
        group = auto_close_group,
        buffer = buf, -- Only track events originating from this specific buffer
        callback = function()
            close_and_clear()
        end,
    })

    -- # Trigger close and clear function
    -- # when standard window opening techniques are bypassed (e.g. by `fzf`)
    vim.api.nvim_create_autocmd({ "FileType", "TermOpen" }, {
        group = auto_close_group,
        callback = function(args)
            -- # NOTE: fzf-lua sets the filetype of its terminal buffer to "fzf"
            if vim.bo[args.buf].filetype == "fzf" or string.match(vim.api.nvim_buf_get_name(args.buf), "fzf") then
                fzf_intervention_flag = true
                close_and_clear()
            end
        end,
    })

    -- # Set keymaps to close the window easily
    local closing_keys = { '<Esc>', '<C-c>', 'q' }
    local map_opts = { silent = true, buffer = buf }
    for _, key in ipairs(closing_keys) do
        vim.keymap.set("n", key, close_and_clear, map_opts)
    end
end

-- # Create an autocommand that triggers when Neovim finishes initialising
-- # to write a subtle welcome message in the command bar
-- # NOTE: the message is only displayed if no specific file as been opened
vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
        -- # Check if Neovim was launched without any file arguments
        if vim.fn.argc() == 0 then
            -- # Print the message in the command bar
            vim.api.nvim_echo({
                { "Press `Ctrl + Space`, then press `h`, to open the help doc", "Title" } },
                false,
                {}
            )
        end
    end,
})

return M
