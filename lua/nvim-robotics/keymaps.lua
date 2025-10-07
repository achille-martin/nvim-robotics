-- ----------------
-- | KEY MAPPINGS |
-- ----------------

-- # Define <space> as leader key
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

-- # Ensure consistent behaviour of `Ctrl + c` as `Esc`
-- # in all modes
-- # In NORMAL mode, also clear the command line
vim.api.nvim_set_keymap(
    "n",
    "<C-c>",
    '<Esc>:echo""<CR>',
    { noremap=true, silent=true }
)
vim.api.nvim_set_keymap(
    "i",
    "<C-c>",
    '<Esc>',
    { noremap=true, silent=true }
)
-- # Ensure clear access to Visual Block with `Ctrl + q`
-- # because most terminals will paste clipboard with `Ctrl + v`

-- # Define a special mode
-- # to input extra keys in any mode, easily
-- # This mode is `<Ctrl-space>`
-- # Add your key after the Ctrl sequence to access a functionality
-- # TODO: bring up a little window with key options
-- # to select functionality when special mode is entered
-- #
-- # PART 1 = Handy functions
local function special_reload_normal()
    vim.api.nvim_exec(
        [[
            so %
        ]],
        false
    )
    print("[SPECIAL] Reloaded current file")
end
local function special_copy_normal()
    vim.api.nvim_exec(
        [[
           "ayy
        ]],
        false
    )
    print("[SPECIAL] Copied current line into the register a")
end
local function special_mode_normal()
    print("[WARN] Activated special mode: input a char...")
    local input_char = vim.fn.nr2char(vim.fn.getchar())
    if input_char == "r" then
        special_reload_normal()
    elseif input_char == "c" then
        special_copy_normal()
    else
        print("Not mapped (deactivated special mode)")
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
        callback=special_mode_normal,
    }
)

-- # Reload current file with `<Ctrl-space>r`
vim.api.nvim_set_keymap(
    "n",
    "<C-space>r",
    "",
    {
        noremap=true,
        silent=true,
        callback=special_reload_normal,
    }
)

-- # Define copy shortcuts
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
-- # with `<Ctrl-space>c`
vim.api.nvim_set_keymap(
    "n",
    "<C-space>c",
    "",
    {
        noremap=true,
        silent=false,
        callback=special_copy_normal,
    }
)
-- # In VISUAL mode, copy selected text into the "a" register
-- # with `<Ctrl-space>c`
vim.api.nvim_set_keymap(
    "v",
    "<C-space>c",
    '"ay:echo"[SPECIAL] Selected text copied into the register a"<CR>',
    { noremap=true, silent=false }
)
-- # In NORMAL mode, share the "a" register
-- # with the plus register
-- # using `<Ctrl-space>a`
-- # Note: this is used to export the internal register to the clipboard
-- # Think a like a-out
vim.api.nvim_set_keymap(
    "n",
    "<C-space>a",
    ':let @+=@a<CR>:echo"[SPECIAL] Populated register + from register a"<CR>',
    { noremap=true, silent=true }
)
-- # In NORMAL mode, share the plus register
-- # with the "a" register
-- # using `<Ctrl-space>z`
-- # Note: this is used to export the clipboard to the internal register
-- # Think z like z-back-in
vim.api.nvim_set_keymap(
    "n",
    "<C-space>z",
    ':let @a=@+<CR>:echo"[SPECIAL] Populated register a from register +"<CR>',
    { noremap=true, silent=true }
)
-- # Define cut shortcuts
-- #
-- # OPTION 1: for new Neovim users
-- # use `dd` (whole line) or `d` / `x`, or right click to cut
-- #
-- # OPTION 2: for advanced Neovim users
-- # In NORMAL mode, cut current line
-- # and save the content into the "a" register
-- # with `<Ctrl-space>x`
vim.api.nvim_set_keymap(
    "n",
    "<C-space>x",
    '"add:echo"[SPECIAL] Current line cut and saved into register a"<CR>',
    { noremap=true, silent=false }
)
-- # In VISUAL mode, cut selected text
-- # and save the content into the "a" register
-- # with `<Ctrl-space>x`
vim.api.nvim_set_keymap(
    "v",
    "<C-space>x",
    '"ad:echo"[SPECIAL] Selected line cut and saved into register a"<CR>',
    { noremap=true, silent=false }
)
-- # Define paste shortcuts
-- #
-- # OPTION 1: for new Neovim users
-- # use `p` or right click to paste
-- #
-- # OPTION 2: for advanced Neovim users
-- # In NORMAL mode, paste the "a" register one line below
-- # with `<Ctrl-space>v`
vim.api.nvim_set_keymap(
    "n",
    "<C-space>v",
    ':pu a<CR>:echo"[SPECIAL] Pasted saved line from register a"<CR>',
    { noremap=true, silent=false }
)
-- # In VISUAL mode, paste the "a" register at the selection
-- # while replacing the selection
-- # with `<Ctrl-space>v`
vim.api.nvim_set_keymap(
    "v",
    "<C-space>v",
    'di<C-r>a<Esc>:echo"[SPECIAL] Pasted saved line from register a"<CR>',
    { noremap=true, silent=false }
)
-- # In INSERT mode, paste the "a" register right on the cursor
-- # with `<Ctrl-space>v`
-- # Note: multi-line blocks might appear disformed
vim.api.nvim_set_keymap(
    "i",
    "<C-space>v",
    '<C-r>a',
    { noremap=true, silent=false }
)
-- # In COMMAND mode, paste the "a" register right on the cursor
-- # with `<Ctrl-space>v`
vim.api.nvim_set_keymap(
    "c",
    "<C-space>v",
    '<C-r>a',
    { noremap=true, silent=false }
)
-- # In TERMINAL mode, paste the "a" register right on the cursor
-- # with `<Ctrl-space>v`
vim.api.nvim_set_keymap(
    "t",
    "<C-space>v",
    '<C-\\><C-n>"apa',
    { noremap=true, silent=false }
)
-- # BONUS: add option to paste from the unnamed register
-- # so that the content of `d` can be pasted if needed
-- # without affecting the "a" register

-- # Define undo/redo shortcuts
-- #
-- # OPTION 1: for new Neovim users
-- # use `u` (undo) or `Ctrl + r` (redo)
-- #
-- # OPTION 2: for advanced Neovim users
-- # In NORMAL mode, undo last action with `<Ctrl-space><backspace>`
vim.api.nvim_set_keymap(
    "n",
    "<C-space><BS>",
    'u',
    { noremap=true, silent=false }
)
-- # In NORMAL mode, redo last action with `<Ctrl-space><enter>`
vim.api.nvim_set_keymap(
    "n",
    "<C-space><CR>",
    '<C-r>',
    { noremap=true, silent=false }
)

-- # Define save shortcuts
-- #
-- # OPTION 1: for new Neovim users
-- # use `:w`
-- #
-- # OPTION 2: for advanced Neovim users
-- # In NORMAL mode, write current buffer with `<Ctrl-space>s`
vim.api.nvim_set_keymap(
    "n",
    "<C-space>s",
    ':w<CR>',
    { noremap=true, silent=false }
)

-- # Define exit shortcuts
-- #
-- # OPTION 1: for new Neovim users
-- # use `:q`
-- #
-- # OPTION 2: for advanced Neovim users
-- # In NORMAL mode, exit without saving with `<Ctrl-space>q`
vim.api.nvim_set_keymap(
    "n",
    "<C-space>q",
    ':q<CR>',
    { noremap=true, silent=false }
)
