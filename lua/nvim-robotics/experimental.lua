-- ----------------
-- | EXPERIMENTAL |
-- ----------------

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

-- # Display a floating help window on Ctrl + h
-- # TODO: move the keymap to `Ctrl+space` then `h`
-- # and add a welcome message in the status line if nvim is opened
-- # without a file
-- # TODO: fix the fact that keys can be used to create new help windows
-- # when the help window is shown. Only q should unlock the editor.
-- # TODO: fix the title [Scratch] at the top.
-- # TODO: actually understand how to instantiate a proper floating window
-- # like fzf, with all the functionalities and locks in place.
local function open_help()
    -- # Define local handy variables
    local display_screen_percentage = 0.8

    -- # Define the text lines to display
    local lines = {
        " Welcome to the help (nvim-robotics)",
        " ==================================================",
        "",
        "Press 'q' to close this window.",
        "",
        "Press <Ctrl + space> at any time to enter the special mode.",
        "Follow-up with the following keys to perform specific actions",
        "| Key | Action                               |",
        "| F   | Open the files picker                |",
        "| f   | Go to definition (word under cursor) |",
    }

    -- # Create an unlisted, scratch buffer (not saved to a file)
    -- # and overwrite the [Scratch] name displayed on top of the window
    local buf = vim.api.nvim_create_buf(false, true)
    -- vim.api.nvim_buf_set_name(buf, " ")

    -- # Get the total screen dimensions to center the window
    local stats = vim.api.nvim_list_uis()[1]
    local screen_width = stats.width
    local screen_height = stats.height

    -- # Calculate dimensions to fit the window
    local win_width = math.ceil(screen_width * display_screen_percentage)
    local win_height = math.ceil(screen_height * display_screen_percentage)
    local row = math.ceil((screen_height - win_height) / 2)
    local col = math.ceil((screen_width - win_width) / 2)

    -- # Set configuration options for the float
    local win_opts = {
        relative = "editor",
        width = win_width,
        height = win_height,
        row = row,
        col = col,
        style = "minimal",     -- Removes line numbers, statuslines, etc.
        border = "rounded",    -- Options: "none", "single", "double", "rounded", "shadow"
    }

    -- # Open the window and focus it
    local win = vim.api.nvim_open_win(buf, true, win_opts)

    -- # Populate the buffer with the custom text
    -- Arguments: buffer_id, start_line, end_line, strict_indexing, lines_table
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

    -- # Optional: Set buffer options (make it read-only for text viewing)
    vim.api.nvim_set_option_value("modifiable", false, { buf = buf })
    vim.api.nvim_set_option_value("buftype", "nofile", { buf = buf })

    -- # Keymap to close the window easily by hitting 'q'
    local map_opts = { silent = true, buffer = buf }
    vim.keymap.set("n", "q", function()
        if vim.api.nvim_win_is_valid(win) then
            vim.api.nvim_win_close(win, true)
        end
    end, map_opts)
end

-- Execute the function to open the window
vim.keymap.set(
    "n",
    "<C-h>",
    open_help,
    { desc = "Open floating help window", silent = true }
)

-- -- Create an autocommand that fires when Neovim finishes initializing
-- vim.api.nvim_create_autocmd("VimEnter", {
--   callback = function()
--     -- Check if Neovim was launched without any file arguments
--     if vim.fn.argc() == 0 then
--       -- Print the message in the command bar
--       vim.api.nvim_echo({ { "Press Ctrl+h to open the help (nvim-robotics)", "Title" } }, false, {})
--     end
--   end,
-- })
