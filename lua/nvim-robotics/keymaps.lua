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

-- ========== UNIVERSAL ===========

-- # Ensure consistent behaviour of `Ctrl + c` as `Esc`
-- # in all modes (apart from TERMINAL mode)
-- # In NORMAL mode, also clear the command line
-- # Note: OPERATOR-PENDING mode has not been included

vim.api.nvim_set_keymap(
    "n",
    "<C-c>",
    '<Esc>:echo""<CR>',
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
    '<Esc>',
    { noremap=true, silent=true }
)

vim.api.nvim_set_keymap(
    "c",
    "<C-c>",
    '<Esc>',
    { noremap=true, silent=true }
)

-- # TIP: use `Ctrl + q` to access Visual Block
-- # because most terminals will paste clipboard with `Ctrl + v`

-- ========== SPECIAL ===========

-- # Define a special mode
-- # to easily input keys associated with functionalities, in any mode
-- # The special mode is called `<Ctrl-space>`
-- # Press a key after the `<Ctrl-space> sequence to access a functionality
-- # TODO: bring up a little window with key input options
-- # to select functionality when special mode is entered
-- # Make sure to make this feature toggleable

-- # PART 1 = Handy functions

local function n_special_reload()
    vim.api.nvim_exec(
        [[
            so %
        ]],
        false
    )
    print("[SPECIAL] Reloaded current file")
end

local function n_special_copy()
    vim.api.nvim_exec(
        [[
           call feedkeys("\"ayy")
        ]],
        false
    )
    print("[SPECIAL] Copied current line into the register a")
end

local function n_special_copy_out()
    vim.api.nvim_exec(
        [[
            let @+=@a
        ]],
        false
    )
    print("[SPECIAL] Populated register + from register a")
end

local function n_special_copy_back_in()
    vim.api.nvim_exec(
        [[
            let @a=@+
        ]],
        false
    )
    print("[SPECIAL] Populated register a from register +")
end

local function vs_special_copy()
    vim.api.nvim_exec(
        [[
            call feedkeys("\"ay")
        ]],
        false
    )
    print("[SPECIAL] Selected text copied into the register a")
end

local function n_special_cut()
    vim.api.nvim_exec(
        [[
            call feedkeys("\"add")
        ]],
        false
    )
    print("[SPECIAL] Selected text copied into the register a")
end

local function vs_special_cut()
    vim.api.nvim_exec(
        [[
            call feedkeys("\"ad")
        ]],
        false
    )
    print("[SPECIAL] Selected line cut and saved into register a")
end

local function n_special_paste()
    vim.api.nvim_exec(
        [[
            :pu a
        ]],
        false
    )
    print("[SPECIAL] Pasted saved line from register a")
end

local function vs_special_paste()
    vim.api.nvim_exec(
        [[
            call feedkeys("di\<C-r>a\<Esc>")
        ]],
        false
    )
    print("[SPECIAL] Pasted saved line from register a")
end

local function i_special_paste()
    vim.api.nvim_exec(
        [[
            call feedkeys("\<C-r>a")
        ]],
        false
    )
    print("[SPECIAL] Pasted saved line from register a")
end

local function c_special_paste()
    vim.api.nvim_exec(
        [[
            call feedkeys("\<C-r>a")
        ]],
        false
    )
end

local function t_special_paste()
    vim.api.nvim_exec(
        [[
            call feedkeys("\<C-\\>\<C-n>\"apa")
        ]],
        false
    )
    print("[SPECIAL] Pasted saved line from register a")
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
            w
        ]],
        false
    )
end

local function n_special_exit()
    vim.api.nvim_exec(
        [[
            q
        ]],
        false
    )
end

-- # Store the key codes for unusual keys on opening window/buffer
local bs_char_code = ""
local enter_char_code = ""
vim.api.nvim_create_augroup(
    "UnusualCharCodes",
    { clear = true }
)
local function get_unusual_key_codes()
    vim.fn.timer_start(
        1,
        function()
            vim.api.nvim_exec(
                [[
                    call feedkeys("\<BS>")
                ]],
                false
            )
        end
    )
    bs_char_code = vim.fn.getchar()
    vim.fn.timer_start(
        1,
        function()
            vim.api.nvim_exec(
                [[
                    call feedkeys("\<CR>")
                ]],
                false
            )
        end
    )
    enter_char_code = vim.fn.getchar()
end
vim.api.nvim_create_autocmd(
    { "WinEnter", "BufEnter" },
    {
        group = "UnusualCharCodes",
        desc = "Collect unusual char codes on accessing window/buffer",
        callback = get_unusual_key_codes,
    }
)

local special_mode_escape_msg = "Exited special mode (key not mapped)"

-- # TODO: add key to leave special mode
-- # by pressing `<Esc>` (or `Ctrl + c`)
-- # ADVANCED TODO: if desired, also map `Ctrl + c`, `Ctrl + v`,...
-- # in special mode, because different than key `c` or `v` alone
local function n_special_mode()
    print("[SPECIAL] Waiting for key input...")
    local input_code = vim.fn.getchar()
    local input_char = vim.fn.nr2char(input_code)
    if input_char == "r" then
        n_special_reload()
    elseif input_char == "c" then
        n_special_copy()
    elseif input_char == "a" then
        n_special_copy_out()
    elseif input_char == "z" then
        n_special_copy_back_in()
    elseif input_char == "x" then
        n_special_cut()
    elseif input_char == "v" then
        n_special_paste()
    elseif input_code == bs_char_code then
        n_special_undo()
    elseif input_code == enter_char_code then
        n_special_redo()
    elseif input_char == "s" then
        n_special_save()
    elseif input_char == "q" then
        n_special_exit()
    else
        print(special_mode_escape_msg)
    end
end

local function vs_special_mode()
    print("[SPECIAL] Waiting for key input...")
    local input_char = vim.fn.nr2char(vim.fn.getchar())
    if input_char == "c" then
        vs_special_copy()
    elseif input_char == "x" then
        vs_special_cut()
    elseif input_char == "v" then
        vs_special_paste()
    else
        print(special_mode_escape_msg)
    end
end

local function i_special_mode()
    print("[SPECIAL] Waiting for key input...")
    local input_char = vim.fn.nr2char(vim.fn.getchar())
    if input_char == "v" then
        i_special_paste()
    else
        print(special_mode_escape_msg)
    end
end

local function c_special_mode()
    -- print("[SPECIAL] Waiting for key input...")
    local input_char = vim.fn.nr2char(vim.fn.getchar())
    if input_char == "v" then
        c_special_paste()
    else
        print(special_mode_escape_msg)
    end
end

local function t_special_mode()
    print("[SPECIAL] Waiting for key input...")
    local input_char = vim.fn.nr2char(vim.fn.getchar())
    if input_char == "v" then
        t_special_paste()
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
-- #
-- # OPTION 2: for advanced Neovim users
-- # In NORMAL mode, undo last action with `<Ctrl-space> + <backspace>`
-- # In NORMAL mode, redo last action with `<Ctrl-space> + <enter>`

-- # 5) Save shortcuts
-- #
-- # OPTION 1: for new Neovim users
-- # use `:w`
-- #
-- # OPTION 2: for advanced Neovim users
-- # In NORMAL mode, write current buffer with `<Ctrl-space> + s`

-- # 6) Exit shortcuts
-- #
-- # OPTION 1: for new Neovim users
-- # use `:q`
-- #
-- # OPTION 2: for advanced Neovim users
-- # In NORMAL mode, exit without saving with `<Ctrl-space> + q`
