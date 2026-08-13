-- ----------------
-- | KEY MAPPINGS |
-- ----------------

-- ========== LEADER ===========

-- # Define `<space>` as leader key
-- # for easiness of access on various keyboards
-- # and minimal loss of standard functionality
-- # Note: the leader key is a special key
-- # used as a prefix to create custom shortcuts
-- # WARNING: ensure that the leader key is defined
-- # as the first key map so that it can be applied
-- # to all subsequent mappings
vim.g.mapleader = " "
-- # Map local leader (used for local buffer)
-- # to the same key as general leader
-- # for consistency
vim.g.maplocalleader = " "

-- ========== HANDY VARIABLES ==========

local std_fn_exec_delay_ms = 1

-- ========== HANDY FUNCTIONS ==========

-- # Check whether plugin `blink.cmp` is installed and active
local function is_blink_cmp_active()
    local res, _ = pcall(
        function()
            require('blink.cmp')
        end
    )
    return res
end

-- # Load options module
local options_module = require('nvim-robotics.options')

-- # Load experimental module
local experimental_module = require('nvim-robotics.experimental')

-- ========== UNIVERSAL ===========

-- CONTROL MANAGEMENT

-- # Ensure consistent behaviour of `Ctrl + c` as `Esc` in all modes
-- # apart from TERMINAL mode, in which case `Ctrl + c` is an interrupt

-- # In NORMAL mode, also clear the command line
-- #
vim.api.nvim_set_keymap(
    "n",
    "<C-c>",
    '<Esc>:echo""<CR>',
    { noremap=true, silent=true }
)

-- # Note: from NORMAL mode, use `Ctrl + q` to access Visual Block
-- # because most terminals will paste clipboard with `Ctrl + v`

-- # In NORMAL and VISUAL mode, there is a complexity
-- # when replacing a single character
-- # with `r`, since Neovim prints any key / combination literally
-- # For instance, `^C` is printed when typing `Ctrl + c`.
-- # As a solution, we change the default map for `r` with an alt-map
-- # so that we can override the default `r` functionality
-- # Note: the `r` functionality is fully replicated
-- # down to the cursor shape (default found in the documentation)
vim.api.nvim_set_keymap(
    "n",
    "<A-r>",
    'r',
    { noremap=true, silent=true }
)
vim.api.nvim_set_keymap(
    "v",
    "<A-r>",
    'r',
    { noremap=true, silent=true }
)
local function replicate_r_func()
    vim.api.nvim_exec(
        [[
            " Define the guicursor default value
            " and compare it to the actual option
            " to make sure that the user has not defined a custom value
            let guicursor_default = "
                \n-v-c-sm:block,
                \i-ci-ve:ver25,
                \r-cr-o:hor20,
                \t:block-blinkon500-blinkoff500-TermCursor"
            let is_guicursor_default = v:false
            " If there is no custom cursor definition,
            " update the cursor to replicate the default `r` behaviour
            if exists('&guicursor')
                if &guicursor == guicursor_default
                    let is_guicursor_default = v:true
                endif
            endif
            if is_guicursor_default
                set guicursor=n-v:hor20
            endif
            " Poll for a key input to replicate the default `r` behaviour
            let input_code = getchar()
            let input_char = nr2char(input_code)
            " Handle the case when `Ctrl + c` is pressed by the user
            if input_code == 3
                call feedkeys("\<Esc>")
                echo ""
            " Handle the other cases by forwarding the key input
            " to the actual `r` command
            else
                call feedkeys("\<A-r>")
                call feedkeys(input_char)
                call feedkeys("\<Esc>")
            endif
            " Reset the cursor if it has been modified temporarily
            if is_guicursor_default
                set guicursor=
                    \n-v-c-sm:block,
                    \i-ci-ve:ver25,
                    \r-cr-o:hor20,
                    \t:block-blinkon500-blinkoff500-TermCursor
            endif
        ]],
        false
    )
end
vim.api.nvim_set_keymap(
    "n",
    "r",
    '',
    {
        noremap=true,
        silent=true,
        callback=replicate_r_func,
    }
)
vim.api.nvim_set_keymap(
    "v",
    "r",
    '',
    {
        noremap=true,
        silent=true,
        callback=replicate_r_func,
    }
)

vim.api.nvim_set_keymap(
    "o",
    "<C-c>",
    '<Esc>',
    { noremap=true, silent=true }
)

vim.api.nvim_set_keymap(
    "v",
    "<C-c>",
    '<Esc>',
    { noremap=true, silent=true }
)

vim.api.nvim_set_keymap(
    "i",
    "<C-c>",
    '',
    {
        noremap=true,
        silent=true,
        callback=function()
            -- # Enhance the `Ctrl + c` functionality in INSERT mode
            -- # when plugin `blink.cmp` is installed and active:
            -- # * `Ctrl + c` hides the completion menu
            -- #   if it was visible, but does not leave INSERT mode
            if (is_blink_cmp_active()
                    and require('blink.cmp').is_menu_visible()) then
                    require('blink.cmp').hide()
            else
                -- # This is the standard functionality for `Ctrl + c`
                -- # in INSERT mode
                vim.api.nvim_exec(
                    [[
                        call feedkeys("\<Esc>")
                    ]],
                    false
                )
            end
        end
    }
)

-- # In COMMAND mode, `Ctrl + c` usually executes the command
-- # and then aborts
-- # It is possible to cancel the execution by escaping the mode
-- # and clearing the command-line
vim.api.nvim_set_keymap(
    "c",
    "<C-c>",
    '',
    {
        noremap=false,
        silent=true,
        callback=function()
            -- # Enhance the `Ctrl + c` functionality in COMMAND mode
            -- # when plugin `blink.cmp` is installed and active:
            -- # * `Ctrl + c` hides the completion menu
            -- #   if it was visible, but does not leave COMMAND mode
            if (is_blink_cmp_active()
                    and require('blink.cmp').is_menu_visible()) then
                    require('blink.cmp').hide()
            else
                -- # This is the standard functionality for `Ctrl + c`
                -- # in COMMAND mode
                vim.api.nvim_exec(
                    [[
                        call feedkeys("\<C-c>", "n")
                    ]],
                    false
                )
            end
        end
    }
)

-- TERMINAL MANAGEMENT

-- # In any mode, use `<Ctrl + space>` and `e` to open a new terminal
-- # at the bottom of the current session window (split horizontally)
-- # Bonus: the TERMINAL-NORMAL mode is skipped on first entry
-- # and the terminal can be used right away
local function any_special_open_terminal()
    print("[SPECIAL] Starting a terminal in split below (if able)")
    vim.api.nvim_exec(
        [[
            sp
            term
            call feedkeys("\<C-w>J")
            call feedkeys("i")
        ]],
        false
    )
end
-- # In TERMINAL mode, use `<F2>` to get into / out of terminal edit
-- # Note: you can use `<F2>` in NORMAL mode
-- # to get into / out of INSERT mode
local function n_enter_insert()
    vim.api.nvim_exec(
        [[
            call feedkeys("i")
        ]],
        false
    )
end
local function i_exit_insert()
    -- # When the cursor is on the first column,
    -- # there is no need to move to the right after the escape
    local col_before_cursor = vim.api.nvim_win_get_cursor(0)[2]
    if col_before_cursor == 0 then
        vim.api.nvim_exec(
            [[
                call feedkeys("\<Esc>")
            ]],
            false
        )
    else
        vim.api.nvim_exec(
            [[
                call feedkeys("\<Esc>\<Right>")
            ]],
            false
        )
    end
end
local function t_browse_term()
    vim.api.nvim_exec(
        [[
            call feedkeys("\<C-\>\<C-n>")
        ]],
        false
    )
end
vim.api.nvim_set_keymap(
    "n",
    "<F2>",
    "",
    {
        noremap=true,
        silent=true,
        callback=n_enter_insert,
        desc="Enter INSERT mode",
    }
)
vim.api.nvim_set_keymap(
    "i",
    "<F2>",
    "",
    {
        noremap=true,
        silent=true,
        callback=i_exit_insert,
        desc="Exit INSERT or TERMINAL mode, back to NORMAL mode",
    }
)
vim.api.nvim_set_keymap(
    "t",
    "<F2>",
    "",
    {
        noremap=true,
        silent=true,
        callback=t_browse_term,
        desc="Enter TERMINAL mode",
    }
)

local function any_special_toggle_float_terminal()
    -- # Delay print to display the message after closing the floating window
    vim.fn.timer_start(
        1,
        function()
            print("[SPECIAL] Toggling the persistent floating terminal (if able)")
        end
    )
    vim.api.nvim_exec(
        [[
            :ToggleTerm
        ]],
        false
    )
end

-- # PRODUCTIVITY MANAGEMENT

-- # In NORMAL mode, jump from current symbol under the cursor
-- # to the next pair or associated symbol (if any)
-- # using `<S-TAB>`
-- # NOTE: the `<S-TAB>` key has no built-in keymap in NORMAL mode
-- # NOTE: this is preferred to `<TAB>` because `<C-i>` would be affected

local function n_jump_to_next_pair()
    vim.api.nvim_exec(
        [[
            call feedkeys("%")
        ]],
        false
    )
end

vim.api.nvim_set_keymap(
    "n",
    "<S-TAB>",
    "",
    {
        noremap=true,
        silent=true,
        callback=n_jump_to_next_pair,
        desc="Jump to next pair"
    }
)

-- ========== SPECIAL ===========

-- # Define a special mode
-- # to easily input keys associated with functionalities, in any mode
-- # The special mode is called `<Ctrl-space>`
-- # Press a key after the `<Ctrl-space> sequence to access a functionality
-- # TODO: bring up a little window with key input options
-- # to select functionality when special mode is entered
-- # Make sure to make this feature toggleable

local special_mode_escape_msg = "Exited special mode (key not mapped)"

-- # PART 1 = Handy functions

local function any_special_copy_out()
    -- # Adding a slight delay in the command
    -- # enables a proper update of the clipboard registers
    vim.api.nvim_exec(
        [[
            call timer_start(1, { -> execute('let @+=@a') })
        ]],
        false
    )
    print("[SPECIAL] Populated register a from register +")
end

local function any_special_copy_back_in()
    vim.api.nvim_exec(
        [[
            let @a=@+
        ]],
        false
    )
    print("[SPECIAL] Populated register a from register +")
end

local function n_special_reload()
    vim.api.nvim_exec(
        [[
            so %
        ]],
        false
    )
    print("[SPECIAL] Reloaded current file")
end

local function n_special_copy_local()
    vim.api.nvim_exec(
        [[
            call feedkeys("\"ayy")
        ]],
        false
    )
    print("[SPECIAL] Copied current line into the register a")
end

local function n_special_copy_global()
    n_special_copy_local()
    any_special_copy_out()
    print("[SPECIAL] Copied current line into the register a and updated register +")
end

local function vs_special_copy_local()
    vim.api.nvim_exec(
        [[
            call feedkeys("\"ay")
        ]],
        false
    )
    vim.api.nvim_exec(
        [[
            call feedkeys("gv\<Esc>", "n")
        ]],
        false
    )
    print("[SPECIAL] Selected text copied into the register a")
end

local function vs_special_copy_global()
    vs_special_copy_local()
    any_special_copy_out()
    print("[SPECIAL] Selected text copied into the register a and updated register +")
end

local function i_special_copy_local()
    -- # Save current cursor location
    local saved_cursor_location = vim.api.nvim_win_get_cursor(0)
    -- # Go into NORMAL mode
    vim.api.nvim_exec(
        [[
            call feedkeys("\<Esc>")
        ]],
        false
    )
    -- # Use special copy for the NORMAL mode
    n_special_copy_local()
    -- # Move cursor back to initial position (in case it moved)
    vim.api.nvim_win_set_cursor(0, saved_cursor_location)
    -- # Enter back INSERT mode (taking into account the location shift)
    if saved_cursor_location[2] == 0 then
        vim.api.nvim_exec(
            [[
                call feedkeys("i")
            ]],
            false
        )
    else
        vim.api.nvim_exec(
            [[
                call feedkeys("a")
            ]],
            false
        )
    end
    print("[SPECIAL] Copied current line into the register a")
end

local function i_special_copy_global()
    i_special_copy_local()
    any_special_copy_out()
    print("[SPECIAL] Copied current line into the register a and updated register +")
end

local function n_special_cut_local()
    vim.api.nvim_exec(
        [[
            call feedkeys("\"add")
        ]],
        false
    )
    print("[SPECIAL] Selected text copied into the register a")
end

local function n_special_cut_global()
    n_special_cut_local()
    any_special_copy_out()
    print("[SPECIAL] Selected text copied into the register a and updated register +")
end

local function vs_special_cut_local()
    vim.api.nvim_exec(
        [[
            call feedkeys("\"ad")
        ]],
        false
    )
    print("[SPECIAL] Selected line cut and saved into register a")
end

local function vs_special_cut_global()
    vs_special_cut_local()
    any_special_copy_out()
    print("[SPECIAL] Selected line cut and saved into the register a and updated register +")
end

local function n_special_paste_local()
    vim.api.nvim_exec(
        [[
            :pu a
        ]],
        false
    )
    -- # Remove trailing Windows characters on paste
    vim.fn.timer_start(
        std_fn_exec_delay_ms,
        function ()
            options_module.remove_trailing_win_chars()
        end
    )
    print("[SPECIAL] Pasted saved line from register a")
end

local function n_special_paste_global()
    any_special_copy_back_in()
    n_special_paste_local()
    print("[SPECIAL] Pasted saved line from register + and updated register a")
end

local function vs_special_paste_local()
    vim.api.nvim_exec(
        [[
            call feedkeys("\"_di\<C-r>a\<Esc>")
        ]],
        false
    )
    -- # Remove trailing Windows characters on paste
    vim.fn.timer_start(
        std_fn_exec_delay_ms,
        function ()
            options_module.remove_trailing_win_chars()
        end
    )
    print("[SPECIAL] Pasted saved line from register a")
end

local function vs_special_paste_global()
    any_special_copy_back_in()
    vs_special_paste_local()
    print("[SPECIAL] Pasted saved line from register + and updated register a")
end

local function i_special_paste_local()
    vim.api.nvim_exec(
        [[
            call feedkeys("\<C-r>a")
        ]],
        false
    )
    -- # Remove trailing Windows characters on paste
    vim.fn.timer_start(
        std_fn_exec_delay_ms,
        function ()
            options_module.remove_trailing_win_chars()
        end
    )
    print("[SPECIAL] Pasted saved line from register a")
end

local function i_special_paste_global()
    any_special_copy_back_in()
    i_special_paste_local()
    print("[SPECIAL] Pasted saved line from register + and updated register a")
end

local function c_special_paste_local()
    vim.api.nvim_exec(
        [[
            call feedkeys("\<C-r>a")
        ]],
        false
    )
    -- # TODO: update function to remove trailing Windows-specific characters
    -- # in command-line
end

local function c_special_paste_global()
    any_special_copy_back_in()
    c_special_paste_local()
end

local function t_special_paste_local()
    vim.api.nvim_exec(
        [[
            call feedkeys("\<C-\>\<C-n>\"apa")
        ]],
        false
    )
    print("[SPECIAL] Pasted saved line from register a")
end

local function t_special_paste_global()
    any_special_copy_back_in()
    t_special_paste_local()
    print("[SPECIAL] Pasted saved line from register + and updated register a")
end

local function n_special_add_line_below()
    vim.api.nvim_exec(
        [[
            call feedkeys("] ")
        ]],
        false
    )
    print("[SPECIAL] Added one line below current")
end


local function n_special_remove_line_below()
    vim.api.nvim_exec(
        [[
            +,+1d|norm! ``
        ]],
        false
    )
    print("[SPECIAL] Removed one line below current")
end

-- # Note: this "comment" action is based on the native Neovim capability
-- # to toggle code comments, inherited from the vim-commentary plugin
-- # Further note: it is complex to get cursor back to initial position
-- # relative to the line of characters after commenting,
-- # because the line gets changed,
-- # and the change depends on the block of characters used for commenting
-- # Therefore, the initial cursor position is restored absolutely
-- # and not relative to the sequence of characters
local function n_special_comment()
    -- # Save current cursor location using VISUAL mode
    vim.api.nvim_exec(
        [[
            call feedkeys("\<C-S-v>\<Esc>")
        ]],
        false
    )
    -- # Perform the commenting action
    vim.api.nvim_exec(
        [[
            call feedkeys("gcc")
        ]],
        false
    )
    -- # Move cursor back to initial location
    vim.api.nvim_exec(
        [[
            call feedkeys("gv\<Esc>")
        ]],
        false
    )
end

local function vs_special_comment()
    vim.api.nvim_exec(
        [[
            call feedkeys("gc")
        ]],
        false
    )
    -- # Move cursor back to initial location
    vim.api.nvim_exec(
        [[
            call feedkeys("gv\<Esc>")
        ]],
        false
    )
end

local function vs_special_fix_indentation()
    vim.api.nvim_exec(
        [[
            call feedkeys("=")
        ]],
        false
    )
    -- # Move cursor back to initial location
    vim.api.nvim_exec(
        [[
            call feedkeys("gv\<Esc>")
        ]],
        false
    )
end

local function i_special_comment()
    -- # Save current cursor location using VISUAL mode
    vim.api.nvim_exec(
        [[
            call feedkeys("\<Esc>\<C-S-v>\<Esc>")
        ]],
        false
    )
    -- # Perform the commenting action
    vim.api.nvim_exec(
        [[
            call feedkeys("\<Esc>gcc")
        ]],
        false
    )
    -- # Move cursor back to initial location
    vim.api.nvim_exec(
        [[
            call feedkeys("gv\<Esc>")
        ]],
        false
    )
    -- # Enter back into INSERT mode
    local current_cursor_location = vim.api.nvim_win_get_cursor(0)
    if current_cursor_location[2] == 0 then
        vim.api.nvim_exec(
            [[
                call feedkeys("i")
            ]],
            false
        )
    else
        vim.api.nvim_exec(
            [[
                call feedkeys("a")
            ]],
            false
        )
    end
end

local function n_special_undo()
    vim.api.nvim_exec(
        [[
            call feedkeys("u")
        ]],
        false
    )
end

local function n_special_redo()
    vim.api.nvim_exec(
        [[
            call feedkeys("\<C-r>")
        ]],
        false
    )
end

local function n_special_save()
    vim.api.nvim_exec(
        [[
            w!
        ]],
        false
    )
end

local function n_special_exit()
    vim.api.nvim_exec(
        [[
            set confirm
            q
        ]],
        false
    )
end

local function t_special_exit()
    vim.api.nvim_exec(
        [[
            call feedkeys("\<F2>")
        ]],
        false
    )
    vim.fn.timer_start(
        1,
        n_special_exit
    )
end

local function n_special_force_exit()
    vim.api.nvim_exec(
        [[
            set confirm
            qall!
        ]],
        false
    )
end

local function n_special_create_split()
    -- # TODO: specify direction with hjkl as well
    print("[SPECIAL] Specify direction of creation of split with arrows...")
    local input_code = vim.fn.getchar()
    if input_code == vim.g.LEFT_ARROW_CHAR_CODE then
        vim.api.nvim_exec(
            [[
                leftabove vnew
            ]],
            false
        )
        print("[SPECIAL] Created a split to the left")
    elseif input_code == vim.g.RIGHT_ARROW_CHAR_CODE then
        vim.api.nvim_exec(
            [[
                rightbelow vnew
            ]],
            false
        )
        print("[SPECIAL] Created a split to the right")
    elseif input_code == vim.g.UP_ARROW_CHAR_CODE then
        vim.api.nvim_exec(
            [[
                aboveleft new
            ]],
            false
        )
        print("[SPECIAL] Created a split above")
    elseif input_code == vim.g.DOWN_ARROW_CHAR_CODE then
        vim.api.nvim_exec(
            [[
                belowright new
            ]],
            false
        )
        print("[SPECIAL] Created a split below")
    else
        print(special_mode_escape_msg)
    end
end

local function t_special_create_split()
    vim.api.nvim_exec(
        [[
            call feedkeys("\<F2>")
        ]],
        false
    )
    vim.fn.timer_start(
        1,
        n_special_create_split
    )
end

local function n_special_move_to_split()
    -- # TODO: specify direction with hjkl as well
    print("[SPECIAL] Specify direction of movement to split with arrows...")
    local input_code = vim.fn.getchar()
    if input_code == vim.g.LEFT_ARROW_CHAR_CODE then
        vim.api.nvim_exec(
            [[
                call feedkeys("\<C-w>\<Left>")
            ]],
            false
        )
        print("[SPECIAL] Moved to split on the left")
    elseif input_code == vim.g.RIGHT_ARROW_CHAR_CODE then
        vim.api.nvim_exec(
            [[
                call feedkeys("\<C-w>\<Right>")
            ]],
            false
        )
        print("[SPECIAL] Moved to split on the right")
    elseif input_code == vim.g.UP_ARROW_CHAR_CODE then
        vim.api.nvim_exec(
            [[
                call feedkeys("\<C-w>\<Up>")
            ]],
            false
        )
        print("[SPECIAL] Moved to split above")
    elseif input_code == vim.g.DOWN_ARROW_CHAR_CODE then
        vim.api.nvim_exec(
            [[
                call feedkeys("\<C-w>\<Down>")
            ]],
            false
        )
        print("[SPECIAL] Moved to split below")
    else
        print(special_mode_escape_msg)
    end
end

local function t_special_move_to_split()
    vim.api.nvim_exec(
        [[
            call feedkeys("\<F2>")
        ]],
        false
    )
    vim.fn.timer_start(
        1,
        n_special_move_to_split
    )
end

local function i_special_blink_cmp_menu()
    if is_blink_cmp_active() then
        require('blink.cmp').show()
    end
end

local function c_special_blink_cmp_menu()
    i_special_blink_cmp_menu()
end

-- # Show all diagnostics for current buffer
-- # in a quickfix window
local function n_special_show_buffer_diagnostics()
    print("[SPECIAL] Showing diagnostics for this buffer (if any)")
    vim.diagnostic.setloclist()
end

-- # Show all diagnostics for current buffer
-- # in a quickfix window
local function n_special_show_line_diagnostics()
    print("[SPECIAL] Showing diagnostics for this line (if any)")
    vim.api.nvim_exec(
        [[
            call feedkeys("\<C-w>d")
        ]],
        false
    )
end

-- # Go to function definition for word under cursor
-- # TIP: using `Ctrl + o` helps you get back
-- # to your state before the jump / go to (the origin)
-- # TIP: using `Ctrl + i` helps you get back
-- # to your state after the jump / go to (the increment)
local function n_special_go_to_definition()
    print("[SPECIAL] Getting to function definition (if any)")
    require("fzf-lua").lsp_definitions()
end

-- # Go to reference finder for word under cursor
-- # Displays a list of symbols and particularly:
-- # * Declarations
-- # * Definitions
-- # * Type definitions
-- # * Implementations
-- # * References (gathering all of the above)
-- #
-- # NOTE: for best results with cpp-related code, use clangd
-- # Refer to LSP tips at the bottom of this file for more information
local function n_special_show_reference_finder()
    print("[SPECIAL] Showing reference finder (if any)")
    require("fzf-lua").lsp_finder()
end

-- # Show all files in cwd (current working directory) via fzf
-- # Equivalent to calling `:FfzLua files`
local function n_special_show_files()
    print("[SPECIAL] Showing files in CWD for this buffer (if any)")
    require("fzf-lua").files()
end

-- # Show file and buffer history (previously opened) via fzf
-- # Equivalent to calling `:FfzLua history`
local function n_special_show_file_history()
    print("[SPECIAL] Showing file history (if any)")
    require("fzf-lua").history()
end

-- # Perform live grep in cwd (current working directory) via fzf
-- # Equivalent to calling `:FzfLua live_grep`
-- # Equivalent to using `grep` command in cwd outside of Neovim
local function n_special_live_grep()
    print("[SPECIAL] Live grep in CWD for this buffer")
    require("fzf-lua").live_grep()
end

-- # Perform grep for word under cursor in cwd (current working directory) via fzf
-- # Equivalent to calling `:FzfLua grep_cword`
-- # Equivalent to using `grep <word>` command in cwd outside of Neovim
local function n_special_grep_cword()
    print("[SPECIAL] Grep word under cursor in CWD for this buffer")
    require("fzf-lua").grep_cword()
end

-- # Show git status results via fzf
-- # Equivalent to calling `:FzfLua git_status`
local function n_special_git_status()
    print("[SPECIAL] Showing git status results (if any)")
    require("fzf-lua").git_status()
end

-- # Show git blame results via fzf
-- # Equivalent to calling `:FzfLua git_blame`
local function n_special_git_blame()
    print("[SPECIAL] Showing git blame results (if any)")
    require("fzf-lua").git_blame()
end

-- # Toggle enhanced git diff view
local function n_special_toggle_git_diff_view()
    print("[SPECIAL] Toggling git diff view (if able)")
    -- # Check whether the diffview.lib.views is a populated table
    if next(require("diffview.lib").views) == nil then
        vim.cmd("DiffviewOpen")
    else
        vim.cmd("DiffviewClose")
    end
end

-- # Show key maps via fzf
-- # Equivalent to calling `:FzfLua keymaps`
local function n_special_show_key_maps()
    print("[SPECIAL] Showing key maps (if any)")
    require("fzf-lua").keymaps()
end

local function n_special_toggle_preview()
-- # Toggle current buffer preview
-- # by opening / closing a browser tab
    print("[SPECIAL] Toggling buffer preview in browser tab (if available)")
    vim.api.nvim_exec(
        [[
            MarkdownPreviewToggle
        ]],
        false
    )
end

local function n_special_prettify_json()
    -- # Prettify the output of json files and unidentified files only
    local current_filetype = vim.bo.filetype
    if current_filetype == "json" or current_filetype == "" then
        print("[SPECIAL] Prettifying json output (if able)")
        vim.api.nvim_exec(
            [[
                %!jq .
            ]],
            false
        )
    else
        print("[SPECIAL] Current file type is ", current_filetype," so not json, skipping.")
    end
end

-- # NOTE for debuggers
-- # The following calls might be useful during a debugging session:
-- # * `:DapStepOver` to macro step forward
-- # * `:DapStepInto` to micro step forward
-- # * `:DapStepOut` to step out
-- # * `:DapDisconnect` to stop the debugging session

local function n_special_start_debugger()
    -- # Start debugger via configured DAP servers
    -- # Can also resume a stopped debugger
    local current_filetype = vim.bo.filetype
    print("[SPECIAL] Starting debugger for ", current_filetype, " (if able)")
    vim.api.nvim_exec(
        [[
            :lua require'dap'.continue()
        ]],
        false
    )
end

local function n_special_toggle_debugger_breakpoint()
    print("[SPECIAL] Toggling breakpoint on current line (if able)")
    vim.api.nvim_exec(
        [[
            :lua require'dap'.toggle_breakpoint()
        ]],
        false
    )
end

-- # Show DAP commands via fzf
-- # Equivalent to calling `:FzfLua dap_commands`
local function n_special_show_debugger_commands()
    print("[SPECIAL] Showing DAP commands (if any)")
    require("fzf-lua").dap_commands()
end

-- # Show DAP variables via fzf
-- # Equivalent to calling `:FzfLua dap_variables`
local function n_special_show_debugger_variables()
    print("[SPECIAL] Showing DAP variables (if any)")
    require("fzf-lua").dap_variables()
end

local function n_special_create_new_tab()
    print("[SPECIAL] Creating new tab (if able)")
    vim.api.nvim_exec(
        [[
            :tabnew
        ]],
        false
    )
end

local function n_special_move_to_next_tab()
    print("[SPECIAL] Moving to next tab (if able)")
    vim.api.nvim_exec(
        [[
            :tabnext
        ]],
        false
    )
end

-- # Trigger the winresize plugin
-- # to resize, move, and focus splits
-- # NOTE: you can also use the default keymap `Ctrl + e`
local function n_special_resize_windows()
    -- # NOTE: there is a live command-line help with the winresize plugin
    -- # so there is no need to add a "SPECIAL" command-line message
    vim.api.nvim_exec(
        [[
            :WinResizerStartResize
        ]],
        false
    )
end

local function n_special_fix_local_indentation()
    print("[SPECIAL] Fixing current line identation (if able)")
    vim.api.nvim_exec(
        [[
            call feedkeys("==")
        ]],
        false
    )
end

local function n_special_fix_global_indentation()
    print("[SPECIAL] Fixing whole file identation (if able)")
    vim.api.nvim_exec(
        [[
            call feedkeys("gg=G\`\`")
        ]],
        false
    )
end

-- # Store key codes for unusual keys on starting neovim
-- # in SHADA (Shared Data between sessions)
-- # so that this action is only performed a minimal number of times.
-- # And make the variables global,
-- # so that they can be used in other config files
if vim.g.BACKSPACE_CHAR_CODE == nil then
    vim.g.BACKSPACE_CHAR_CODE = vim.api.nvim_replace_termcodes("<Bs>", true, false, true)
end
if vim.g.LEFT_ARROW_CHAR_CODE == nil then
    vim.g.LEFT_ARROW_CHAR_CODE = vim.api.nvim_replace_termcodes("<Left>", true, false, true)
end
if vim.g.RIGHT_ARROW_CHAR_CODE == nil then
    vim.g.RIGHT_ARROW_CHAR_CODE = vim.api.nvim_replace_termcodes("<Right>", true, false, true)
end
if vim.g.CTRL_RIGHT_ARROW_CHAR_CODE == nil then
    vim.g.CTRL_RIGHT_ARROW_CHAR_CODE = vim.api.nvim_replace_termcodes("<C-Right>", true, false, true)
end
if vim.g.UP_ARROW_CHAR_CODE == nil then
    vim.g.UP_ARROW_CHAR_CODE = vim.api.nvim_replace_termcodes("<Up>", true, false, true)
end
if vim.g.CTRL_UP_ARROW_CHAR_CODE == nil then
    vim.g.CTRL_UP_ARROW_CHAR_CODE = vim.api.nvim_replace_termcodes("<C-Up>", true, false, true)
end
if vim.g.DOWN_ARROW_CHAR_CODE == nil then
    vim.g.DOWN_ARROW_CHAR_CODE = vim.api.nvim_replace_termcodes("<Down>", true, false, true)
end
if vim.g.TABULAR_CHAR_CODE == nil then
    vim.g.TABULAR_CHAR_CODE = 9
end
if vim.g.SHIFT_TABULAR_CHAR_CODE == nil then
    vim.g.SHIFT_TABULAR_CHAR_CODE = vim.api.nvim_replace_termcodes("<S-Tab>", true, false, true)
end
if vim.g.ENTER_CHAR_CODE == nil then
    vim.g.ENTER_CHAR_CODE = 13
end

-- # TODO: add key to leave special mode
-- # by pressing `<Esc>` (or `Ctrl + c`)
-- # ADVANCED TODO: if desired, also map `Ctrl + c`, `Ctrl + v`,...
-- # in special mode, because different than key `c` or `v` alone
local function n_special_mode()
    print("[SPECIAL] Waiting for key input...")
    local input_code = vim.fn.getchar()
    local input_char = vim.fn.nr2char(input_code)
    if input_char == "R" then
        n_special_reload()
    elseif input_char == "a" then
        any_special_copy_out()
    elseif input_char == "z" then
        any_special_copy_back_in()
    elseif input_char == "c" then
        n_special_copy_local()
    elseif input_char == "C" then
        n_special_copy_global()
    elseif input_char == "x" then
        n_special_cut_local()
    elseif input_char == "X" then
        n_special_cut_global()
    elseif input_char == "v" then
        n_special_paste_local()
    elseif input_char == "V" then
        n_special_paste_global()
    elseif input_char == "+" then
        n_special_add_line_below()
    elseif input_char == "-" then
        n_special_remove_line_below()
    elseif input_char == "\"" then
        n_special_comment()
    elseif input_code == vim.g.BACKSPACE_CHAR_CODE then
        n_special_undo()
    elseif input_code == vim.g.ENTER_CHAR_CODE then
        n_special_redo()
    elseif input_char == "s" then
        n_special_save()
    elseif input_char == "q" then
        n_special_exit()
    elseif input_char == "Q" then
        n_special_force_exit()
    elseif input_char == "w" then
        n_special_move_to_split()
    elseif input_char == "W" then
        n_special_create_split()
    elseif input_char == "d" then
        n_special_show_line_diagnostics()
    elseif input_char == "D" then
        n_special_show_buffer_diagnostics()
    elseif input_char == "f" then
        -- # Go to "function" definition
        -- # but also works for other elements
        n_special_go_to_definition()
    elseif input_char == "r" then
        -- # Show reference finder
        -- # to identify the references and related symbol types
        n_special_show_reference_finder()
    elseif input_char == "F" then
        n_special_show_files()
    elseif input_char == "!" then
        n_special_show_file_history()
    elseif input_char == "g" then
        n_special_grep_cword()
    elseif input_char == "G" then
        n_special_live_grep()
    elseif input_char == "S" then
        n_special_git_status()
    elseif input_char == "M" then
        n_special_git_blame()
    elseif input_char == "m" then
        n_special_toggle_git_diff_view()
    elseif input_char == "K" then
        -- # NOTE: a bit limited at the moment
        n_special_show_key_maps()
    elseif input_char == "p" then
        n_special_toggle_preview()
    elseif input_char == "j" then
        n_special_prettify_json()
    elseif input_char == "B" then
        n_special_start_debugger()
    elseif input_char == "b" then
        n_special_toggle_debugger_breakpoint()
    elseif input_char == "O" then
        n_special_show_debugger_commands()
    elseif input_char == "o" then
        n_special_show_debugger_variables()
    elseif input_code == vim.g.SHIFT_TABULAR_CHAR_CODE then
        n_special_create_new_tab()
    elseif input_code == vim.g.TABULAR_CHAR_CODE then
        n_special_move_to_next_tab()
    elseif input_char == "e" then
        n_special_resize_windows()
    elseif input_char == "h" then
        experimental_module.open_help()
    elseif input_char == "i" then
        n_special_fix_local_indentation()
    elseif input_char == "I" then
        n_special_fix_global_indentation()
    elseif input_char == "T" then
        any_special_open_terminal()
    elseif input_char== "t" then
        any_special_toggle_float_terminal()
    else
        print(special_mode_escape_msg)
    end
end

local function vs_special_mode()
    print("[SPECIAL] Waiting for key input...")
    local input_code = vim.fn.getchar()
    local input_char = vim.fn.nr2char(input_code)
    if input_char == "c" then
        vs_special_copy_local()
    elseif input_char == "C" then
        vs_special_copy_global()
    elseif input_char == "x" then
        vs_special_cut_local()
    elseif input_char == "X" then
        vs_special_cut_global()
    elseif input_char == "v" then
        vs_special_paste_local()
    elseif input_char == "V" then
        vs_special_paste_global()
    elseif input_char == "a" then
        any_special_copy_out()
    elseif input_char == "z" then
        any_special_copy_back_in()
    elseif input_char == "\"" then
        vs_special_comment()
    elseif input_char == "i" then
        vs_special_fix_indentation()
    elseif input_code == vim.g.TABULAR_CHAR_CODE then
        vs_special_fix_indentation()
    elseif input_char == "T" then
        any_special_open_terminal()
    elseif input_char== "t" then
        any_special_toggle_float_terminal()
    else
        print(special_mode_escape_msg)
    end
end

local function i_special_mode()
    print("[SPECIAL] Waiting for key input...")
    local input_code = vim.fn.getchar()
    local input_char = vim.fn.nr2char(input_code)
    if input_char == "c" then
        i_special_copy_local()
    elseif input_char == "C" then
        i_special_copy_global()
    elseif input_char == "v" then
        i_special_paste_local()
    elseif input_char == "V" then
        i_special_paste_global()
    elseif input_char == "a" then
        any_special_copy_out()
    elseif input_char == "z" then
        any_special_copy_back_in()
    elseif input_char == "\"" then
        i_special_comment()
    elseif input_code == vim.g.TABULAR_CHAR_CODE then
        i_special_blink_cmp_menu()
    elseif input_char == "T" then
        any_special_open_terminal()
    elseif input_char== "t" then
        any_special_toggle_float_terminal()
    else
        print(special_mode_escape_msg)
    end
end

local function c_special_mode()
    -- print("[SPECIAL] Waiting for key input...")
    local input_code = vim.fn.getchar()
    local input_char = vim.fn.nr2char(input_code)
    if input_char == "v" then
        c_special_paste_local()
    elseif input_char == "V" then
        c_special_paste_global()
    elseif input_char == "a" then
        any_special_copy_out()
    elseif input_char == "z" then
        any_special_copy_back_in()
    elseif input_code == vim.g.TABULAR_CHAR_CODE then
        c_special_blink_cmp_menu()
    elseif input_char == "T" then
        any_special_open_terminal()
    elseif input_char== "t" then
        any_special_toggle_float_terminal()
    else
        print(special_mode_escape_msg)
    end
end

local function t_special_mode()
    print("[SPECIAL] Waiting for key input...")
    local input_char = vim.fn.nr2char(vim.fn.getchar())
    if input_char == "v" then
        t_special_paste_local()
    elseif input_char == "V" then
        t_special_paste_global()
    elseif input_char == "a" then
        any_special_copy_out()
    elseif input_char == "z" then
        any_special_copy_back_in()
    elseif input_char == "q" then
        t_special_exit()
    elseif input_char == "w" then
        t_special_move_to_split()
    elseif input_char == "W" then
        t_special_create_split()
    elseif input_char == "T" then
        any_special_open_terminal()
    elseif input_char== "t" then
        any_special_toggle_float_terminal()
    else
        print(special_mode_escape_msg)
    end
end

-- # PART 2 = Mappings

-- # NORMAL mode
vim.api.nvim_set_keymap(
    "n",
    "<C-space>",
    "",
    {
        noremap=true,
        silent=true,
        callback=n_special_mode,
        desc="Enter SPECIAL mode",
    }
)
-- # VISUAL/SELECT mode
vim.api.nvim_set_keymap(
    "v",
    "<C-space>",
    "",
    {
        noremap=true,
        silent=true,
        callback=vs_special_mode,
        desc="Enter SPECIAL mode",
    }
)

-- # INSERT mode
vim.api.nvim_set_keymap(
    "i",
    "<C-space>",
    "",
    {
        noremap=true,
        silent=true,
        callback=i_special_mode,
        desc="Enter SPECIAL mode",
    }
)

-- # COMMAND-LINE mode
vim.api.nvim_set_keymap(
    "c",
    "<C-space>",
    "",
    {
        noremap=true,
        silent=true,
        callback=c_special_mode,
        desc="Enter SPECIAL mode",
    }
)

-- # TERMINAL mode
vim.api.nvim_set_keymap(
    "t",
    "<C-space>",
    "",
    {
        noremap=true,
        silent=true,
        callback=t_special_mode,
        desc="Enter SPECIAL mode",
    }
)

-- # PART 3 = Notes on special mode
-- #
-- # 1) Copy shortcuts
-- #
-- # Note: it is not possible to map `Ctrl + c`
-- # because it is used as `Esc`
-- # Note continued: it is also not possible to map `Ctrl + Shift + c`
-- # because currently detected as `Ctrl + c`
-- # Note further: it is also not practical to only map `<leader>c`
-- # because it might not be practical in all modes
-- #
-- # OPTION 1: for new Neovim users
-- # use `yy` (whole line), `y` (selection), or right click to copy
-- # Note: as an alternative, depending on the terminal used,
-- # it might be possible to copy text with `Ctrl + Shift + c`
-- #
-- # OPTION 2: for advanced Neovim users
-- # In NORMAL mode, copy current line into the "a" register
-- # with `<Ctrl-space> + c`
-- # In NORMAL mode, share the "a" register
-- # with the "+" register
-- # using `<Ctrl-space> + a`
-- # Note: this is used to export the internal register to the clipboard
-- # Think `a` like "a-out"
-- # In NORMAL mode, share the "+" register
-- # with the "a" register
-- # using `<Ctrl-space> + z`
-- # Note: this is used to export the clipboard to the internal register
-- # Think `z` like "z-back-in"
-- # In VISUAL/SELECT mode, copy selected text into the "a" register
-- # with `<Ctrl-space> + c`

-- # 2) Cut shortcuts
-- #
-- # OPTION 1: for new Neovim users
-- # use `dd` (whole line) or `d` / `x`, or right click to cut
-- #
-- # OPTION 2: for advanced Neovim users
-- # In NORMAL mode, cut current line
-- # and save the content into the "a" register
-- # with `<Ctrl-space> + x`
-- # In VISUAL/SELECT mode, cut selected text
-- # and save the content into the "a" register
-- # with `<Ctrl-space> + x`

-- # 3) Paste shortcuts
-- #
-- # OPTION 1: for new Neovim users
-- # use `p` or right click to paste
-- # Note: as an alternative, depending on the terminal used,
-- # it might be possible to paste with `Ctrl + Shift + v`
-- #
-- # OPTION 2: for advanced Neovim users
-- # In NORMAL mode, paste the "a" register one line below than current
-- # with `<Ctrl-space> + v`
-- # In VISUAL/SELECT mode, paste the "a" register in place of the selection
-- # with `<Ctrl-space> + v`
-- # In INSERT mode, paste the "a" register right on the cursor
-- # with `<Ctrl-space> + v`
-- # Note: multi-line blocks might appear disformed
-- # In COMMAND mode, paste the "a" register right on the cursor
-- # with `<Ctrl-space> + v`
-- # In TERMINAL mode, paste the "a" register right on the cursor
-- # with `<Ctrl-space> + v`
-- # BONUS: To paste from the unnamed register, use `p`
-- # This is so that the content of `d` can be pasted without affecting `a`
-- # Maybe add another key if desired

-- # 4) Undo/redo shortcuts
-- #
-- # OPTION 1: for new Neovim users
-- # use `u` (undo) or `Ctrl + r` (redo)
-- # Note: if you hit `Ctrl + z`, you will put the current process
-- # in the background. To bring it back, enter `fg` in your terminal.
-- #
-- # OPTION 2: for advanced Neovim users
-- # In NORMAL mode, undo last action with `<Ctrl-space> + <backspace>`
-- # In NORMAL mode, redo last action with `<Ctrl-space> + <enter>`

-- # 5) Save shortcuts
-- #
-- # OPTION 1: for new Neovim users
-- # use `:w`
-- # Note: if you hit `Ctrl + s`, you will freeze the current buffer
-- # to unfreeze it, hit `Ctrl + q`
-- #
-- # OPTION 2: for advanced Neovim users
-- # In NORMAL mode, write current buffer with `<Ctrl-space> + s`

-- # 6) Exit shortcuts
-- #
-- # OPTION 1: for new Neovim users
-- # use `:q`
-- #
-- # OPTION 2: for advanced Neovim users
-- # In NORMAL mode, force exit without saving with `<Ctrl-space> + Q`

-- # 7) Window shortcuts
-- #
-- # Use `<arrows>` to move between windows
-- # once you are in the window motion special mode (`<Ctrl-space> + w`)
-- #
-- # Use `<arrows>` to create a new window
-- # once you are in the window creation special mode (`<Ctrl-space> + W`)

-- # 8) Tab shortcuts
-- #
-- # Use `<Ctrl-space> + T` to create a new tab
-- #
-- # Use `<Ctrl-space> + t` to move to next tab
-- #
-- # TODO: improve creation and navigation between tabs

-- # 9) LSP tips
-- #
-- # WARNING: for cpp-related code, you need to configure clangd properly
-- # * For cpp projects, run `cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=ON -B build`
-- #   to generate a source file compilation description file
-- #   `compile_commands.json` in your `/build` folder
-- # * For ros1 projects, run `catkin_make -DCMAKE_EXPORT_COMPILE_COMMANDS=ON`
-- #   and the `compile_commands.json` will be put in your `<ws>/build` folder
-- #
-- # Use `<Ctrl-space> + f` to go to a function definition
-- #
-- # Use `<Ctrl-space> + r` to open the reference finder
