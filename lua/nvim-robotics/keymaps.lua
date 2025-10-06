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

-- # Reload current file with `<leader>r`
vim.api.nvim_set_keymap(
    "n",
    "<leader>r",
    ':so %<CR>:echo"[INFO] Reloaded current file"<CR>',
    { noremap=true, silent=true }
)

-- # Define copy shortcuts
-- # Note: it is not possible to map `Ctrl + c`
-- # because it is used as `Esc`
-- # Note continued: it is also not possible to map `Ctrl + Shift + c`
-- # because currently detected as `Ctrl + c`
-- # In NORMAL mode, copy current line into the "a" register
-- # with `<leader>c`
vim.api.nvim_set_keymap(
    "n",
    "<leader>c",
    '"ayy:echo"[INFO] Copied current line into the register a"<CR>',
    { noremap=true, silent=false }
)
-- # In VISUAL mode, copy selected text into the "a" register
-- # with `<leader>c`
vim.api.nvim_set_keymap(
    "v",
    "<leader>c",
    '"ay:echo"[INFO] Selected text copied into the register a"<CR>',
    { noremap=true, silent=false }
)
-- # In NORMAL mode, share the "a" register
-- # with the unnamed and plus registers
vim.api.nvim_set_keymap(
    "n",
    "<leader>a",
    ':let @+=@a<CR>:echo"Populated register + from register a"<CR>',
    { noremap=true, silent=true }
)
-- # Define cut shortcuts
-- # In NORMAL mode, cut current line
-- # and save the content into the "a" register
-- # with `<leader>x`
vim.api.nvim_set_keymap(
    "n",
    "<leader>x",
    '"add:echo"Current line cut and saved into register a"<CR>',
    { noremap=true, silent=false }
)
-- # In VISUAL mode, cut selected text
-- # and save the content into the "a" register
-- # with `<leader>x`
vim.api.nvim_set_keymap(
    "v",
    "<leader>x",
    '"ad:echo"Selected line cut and saved into register a"<CR>',
    { noremap=true, silent=false }
)
-- # Define paste shortcuts
-- # In NORMAL mode, paste the "a" register one line below with `<leader>v`
vim.api.nvim_set_keymap(
    "n",
    "<leader>v",
    ':pu a<CR>:echo"Pasted saved line from register a"<CR>',
    { noremap=true, silent=false }
)
-- # In INSERT mode, use `Ctrl + v` or `Ctrl + Shift + v`
-- # to paste the "+" register?
-- # because this is a terminal-linked command
-- # How about the "a" register?
-- # Note: leader key cannot be used in INSERT mode if it is <space>
-- # Compromise is to use `Alt/AltGr + v` to paste
-- # from the "a" register right on cursor in INSERT mode?
-- # TODO: find a more consistent pasting while in INSERT mode
-- # to try to re-use the leader key
vim.api.nvim_set_keymap(
    "i",
    "<M-v>",
    '<C-r>a',
    { noremap=true, silent=false }
)
-- # In VISUAL mode, paste the "a" register at the selection
-- # while replacing the selection
-- # with `<leader>v`
vim.api.nvim_set_keymap(
    "v",
    "<leader>v",
    'di<C-r>a<Esc>',
    { noremap=true, silent=false }
)

-- # Define undo/redo shortcuts
-- # In NORMAL mode, undo last action with `<leader><backspace>`
vim.api.nvim_set_keymap(
    "n",
    "<leader><BS>",
    'u',
    { noremap=true, silent=false }
)
vim.api.nvim_set_keymap(
    "n",
    "<leader><CR>",
    '<C-r>',
    { noremap=true, silent=false }
)

-- # Define save shortcuts
-- # In NORMAL mode, write current buffer with `<leader>s`
vim.api.nvim_set_keymap(
    "n",
    "<leader>s",
    ':w<CR>',
    { noremap=true, silent=false }
)

-- # Define exit shortcuts
-- # In NORMAL mode, exit without saving with `<leader>q`
vim.api.nvim_set_keymap(
    "n",
    "<leader>q",
    ':q<CR>',
    { noremap=true, silent=false }
)
