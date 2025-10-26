-- -----------
-- | PLUGINS |
-- -----------

-- =============== GUIDE ===============

-- PLUGIN MANAGER SELECTION

-- # Select your favourite plugin manager
-- # The one provided in this repo config is vim-plug, accessible via:
-- # https://github.com/junegunn/vim-plug
-- # This plugin manager is automatically installed
-- # and it is upgraded to the latest version available
-- # when the repo config is installed
-- #
-- # Note: to keep upgrading vim-plug, run `:PlugUpgrade`

-- PLUGIN DOWNLOAD/INSTALLATION

-- # Pick a plugin you wish to install
-- # (e.g. `https://github.com/windwp/nvim-autopairs`),
-- # head over to the list of plugins downloaded/installed in this file
-- # and add a line between the calls for `plug#begin` and `plug#end`
-- # (e.g. `Plug 'windwp/nvim-autopairs'`)
-- # Then, reload your config
-- # and install the new plugin with: `:PlugInstall`
-- # (leave window with `q`)

-- PLUGIN SETUP

-- # Once the desired plugin is installed,
-- # head over to the list of plugins setup/activated in this file
-- # and add a line to specify the setup and configuration of the plugin
-- # (e.g. `require("nvim-autopairs").setup()`)
-- # This step ensures that the plugin is actually loaded
-- # and ready to use

-- PLUGIN MANAGEMENT

-- # * Update a plugin with: `:PlugUpdate [<plugin_name>]`
-- # * Check the status of plugins with: `:PlugStatus`
-- # * Show the difference between current and latest version of a plugin
-- #   with: `:PlugDiff`

-- PLUGIN REMOVAL

-- # If you want to stop using a plugin,
-- # head over to the list of plugins downloaded/installed in this file
-- # and remove the line calling the plugin
-- # Furthermore, make sure to remove the line calling the setup of the plugin
-- # in the list of plugins setup/activated in this file
-- # Then, refresh the plugins via vim-plug with `:PlugClean`
-- #
-- # Note: you can either keep (press `Enter/N`) or remove (press `y`)
-- # the plug directory of the plugin

-- =============== PLUGIN MANAGEMENT ===============

-- HANDY VARIABLES

-- # Define handy variables for plugin management via vim-plug

local plugs_install_path = table.concat{
    vim.env.HOME,
    "/.config/",
    vim.g.custom_nvim_config_name,
    "/autoload/plugs",
}
local Plug = vim.fn['plug#']

-- HANDY ROUTINES

-- # Automatically install missing plugins on startup
-- # (extracted from: https://github.com/junegunn/vim-plug/wiki/extra)
vim.cmd(
    [[
        autocmd VimEnter *
        \  if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
        \|   PlugInstall --sync | q
        \| endif
    ]]
)

-- DOWNLOADED/INSTALLED PLUGINS

-- # List plugins downloaded/installed via vim-plug

vim.call('plug#begin', plugs_install_path)

    -- # Update all language parsers
    -- # when the nvim-treesitter plugin is upgraded
    Plug('nvim-treesitter/nvim-treesitter', { ['do'] = ':TSUpdate' })
        -- # Indicate plugins depending on nvim-treesitter via indentation
        Plug('nvim-treesitter/nvim-treesitter-textobjects')

    -- # Update all managed registries
    -- # when the mason.nvim plugin is upgraded
    -- # Note: the `:MasonUpdate` action also ensures
    -- # that the core package registry is downloaded on first plugin use
    -- # Further note: the mason.nvim plugin allows the user to
    -- # easily manage external editor tooling such as LSP servers,
    -- # DAP servers, linters, and formatters through a single interface
    Plug('mason-org/mason.nvim', { ['do'] = ':MasonUpdate' })
        -- # Indicate plugins depending on mason.nvim via indentation
        Plug('neovim/nvim-lspconfig')
            -- # Indicate plugins depending on nvim-lspconfig via indentation
            Plug('mason-org/mason-lspconfig.nvim')

    Plug 'windwp/nvim-autopairs'

    Plug 'scottmckendry/cyberdream.nvim'

    -- # Target latest `1.x` release for `blink.cmp`
    Plug('saghen/blink.cmp', { ['tag'] = 'v1.*' })

vim.call('plug#end')

-- SETUP/ACTIVATED PLUGINS

-- # List plugins setup/activated

-- # Force use of git rather than cURL to download treesitter plugins
require("nvim-treesitter.install").prefer_git = true

-- # Configure the nvim-treesitter plugin
-- # to improve syntax highlighting, indentation, folding,
-- # management of text objects and enhance LSP capabilities
require('nvim-treesitter.configs').setup({
    -- # Enable syntax highlighting
    highlight = { enable = true },
    -- # Enable indentation
    indent = { enable = true },
    -- # Auto-install existing parsers for specific languages
    ensure_installed = {
        "arduino",
        "bash",
        "c",
        "cmake",
        "comment",
        "cpp",
        "css",
        "csv",
        "diff",
        "dockerfile",
        "doxygen",
        "git_config",
        "git_rebase",
        "gitattributes",
        "gitcommit",
        "gitignore",
        "gpg",
        "html",
        "http",
        "json",
        "lua",
        "luap",
        "make",
        "markdown",
        "markdown_inline",
        "matlab",
        "printf",
        "proto",
        "python",
        "pymanifest",
        "readline",
        "regex",
        "requirements",
        "sql",
        "ssh_config",
        "tmux",
        "toml",
        "vim",
        "vimdoc",
        "xml",
        "yaml",
    },
    -- # Enable incremental selection
    -- # to select nodes from the tree generated by treesitter
    -- # incrementally with "v" and decrementally with "backspace"
    -- # while in VISUAL mode
    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = false,
            node_incremental = "v",
            scope_incremental = false,
            node_decremental = "<BS>",
        },
    },
    -- # Enable the text-objects module
    textobjects = {
        select = {
            enable = true,
            keymaps = {
                -- # Outer part selection with "a = a-out"
                -- # Inner part selection with "i = in"
                -- # Ensuring that keymaps are not prone
                -- # to mistakes within the VISUAL mode

                -- # Block selection (within brackets)
                -- # already handled via incremental selection

                -- # Conditional selection ("i" like "if")
                ["ai"] = "@conditional.outer",
                ["ii"] = "@conditional.inner",
                -- # Loop selection
                ["al"] = "@loop.outer",
                ["il"] = "@loop.inner",
                -- # Function selection
                ["af"] = "@function.outer",
                ["if"] = "@function.inner",
                -- # Class selection
                ["ac"] = "@class.outer",
                ["ic"] = "@class.inner",
                -- # Comment selection
                ["a\""] = "@comment.outer",
                ["i\""] = "@comment.inner",
            },
        },
    },
})
-- # Specify similar parsers to file types not currently supported:
-- # * .launch files (used in ROS)
-- # * .sdf files (used in ROS)
-- # * .urdf files (used in ROS)
-- # * .xacro files (used in ROS)
-- # * .world files (used in Gazebo)
vim.treesitter.language.register('xml', 'launch')
vim.treesitter.language.register('xml', 'sdf')
vim.treesitter.language.register('xml', 'urdf')
vim.treesitter.language.register('xml', 'xacro')
vim.treesitter.language.register('xml', 'world')

-- # Adjust the configuration of mason plugin
-- # to be consistent with the other plugins
local mason_install_path = table.concat{
    vim.env.HOME,
    "/.config/",
    vim.g.custom_nvim_config_name,
    "/autoload/mason",
}
require("mason").setup({
    install_root_dir = mason_install_path,
})

-- # Install and configure (if possible) specific LSP servers
-- # Note: the list of available LSP servers can be found via nvim-lspconfig:
-- # https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md
require("mason-lspconfig").setup({
    ensure_installed = {
        "lua_ls",
    },
})

-- # Enable specific LSP servers with default config via nvim-lspconfig
-- # Note: this is automatically handled via mason-lspconfig
-- # unless the feature is turned off `automatic_enable = false`
-- # In this case, each LSP server must be enabled individually with
-- # `vim.lsp.enable('<lsp_server_name')`
-- # Optionally, a custom config can be set for specific LSP servers with
-- # `vim.lsp.config('<lsp_server_name>', {})`

-- # Load the autopair plugin
require("nvim-autopairs").setup({})

-- # Improve the cyberdream colorscheme experience
-- # by referring to the official setup config:
-- # https://github.com/scottmckendry/cyberdream.nvim?tab=readme-ov-file#%EF%B8%8F-configuring
require("cyberdream").setup({
    -- # Prevent use of colorscheme terminal colours
    -- # to not clash with custom terminal setup
    terminal_colors = false,
    -- # Update colors to tweak some relative contrasts
    colors = {
        -- # Modify colours for the dark mode only
        dark = {
            -- # Update background (black) to Very Dark Red
            bg = "#1F1D1D",
            -- # Update foreground (white) to Cornsilk
            fg = "#FFF8DC",
            -- # Update comments (grey) to Steel Grey
            grey = "#71797E",
            -- # Update blue to Cornflower Blue
            blue = "#6699FF",
            -- # Update green to Jade
            green = "#00A36C",
            -- # Update cyan to Vivid Cyan
            cyan = "#11F2A3",
            -- # Update magenta to Vivid Magenta
            magenta = "#FF2BF5",
            -- # Update pink to Darker Salmon
            pink = "#F07162",
            -- # Update orange to Shade of Brown
            orange = "#F2AB38",
            -- # Update purple to Amaranth Deep Purple
            purple = "#AD15AD",
        }
    },
})

-- # Improve the blink.cmp completion plugin experience
-- # by tweaking the defaults:
-- # * Download as little noise as possible
-- #   (i.e. no Rust, no NerdFonts)
-- # * Make sure that the plugin does not disturb
-- #   normal functionalities (like `<Tab>`)
-- # * Only show completion suggestions on `<Tab>` (under certain conditions),
-- #   or use the special mode `<Ctrl + space><Tab>`
-- # * Display ghost text only if the completion menu is visible
-- # * Use `Tab` or `Enter` to accept the suggestion
-- # * Use `Ctrl + c` to hide completion menu
require("blink.cmp").setup({
    -- # General settings
    fuzzy = {
        implementation = "lua",
        -- # Define sorting priority:
        -- # Primary sort: by fuzzy matching score
        -- # Secondary sort: by sortText field if scores are equal
        -- # Tertiary sort: by label if still tied
        sorts = {
            'score',
            'sort_text',
            'label',
        },
    },
    sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer', 'omni' },
        min_keyword_length = 1,
    },
    -- # Signature support (experimental)
    -- # Note: a function signature consists of the function prototype.
    -- # It specifies the general information about a function like the name,
    -- # scope and parameters.
    signature = { enabled = true },
    completion = {
        -- # Range 'prefix' does a fuzzy match on the text before the cursor
        -- # Range 'full' does a fuzzy match on the text
        -- # before _and_ after the cursor
        keyword = { range = 'prefix' },
        list = {
            max_items = 100,
            selection = { auto_insert = false, },
        },
        menu = {
            auto_show = false,
            min_width = 15,
            max_height = 10,
            scrolloff = 1,
            draw = {
                columns = {
                    { "label", "label_description", gap = 1 },
                    { "kind" },
                },
            },
        },
        ghost_text = {
            enabled = true,
            show_without_menu = false,
        },
        documentation = {
            auto_show = true,
            auto_show_delay_ms = 500,
        },
    },
    -- # INSERT mode settings
    keymap = {
        preset = 'super-tab',
        ["<Up>"] = { "select_prev", "fallback" },
        ["<Down>"] = { "select_next", "fallback" },
        ["<CR>"] = { "select_and_accept", "fallback" },
        ['<C-space>'] = {},
        -- # (Experimental) Only allow manual trigger of completion menu
        -- # with `<Tab>` if the character before the cursor in INSERT mode
        -- # is not:
        -- # * Null (char code = 0)
        -- # * Tab (char code = 9)
        -- # * Space (char code = 32)
        -- # Otherwise, you can use the special mode `<Ctrl + space><Tab>`
        -- # to manual trigger the completion menu
        -- # Note: if you really want a tab instead of the completion menu,
        -- # you can hit `<Shift + Tab>`,
        -- # or comment out the experimental feature
        ['<Tab>'] = {
            function(cmp)
                local col_before_cursor = vim.api.nvim_win_get_cursor(0)[2]
                local char_before_cursor = vim.api.nvim_get_current_line():sub(
                    col_before_cursor,
                    col_before_cursor
                )
                local char_code_before_cursor = vim.fn.char2nr(
                    char_before_cursor
                )
                if (char_code_before_cursor ~= 0
                        and char_code_before_cursor ~= 9
                        and char_code_before_cursor ~= 32) then
                    vim.cmd([[call feedkeys("\<BS>")]])
                    cmp.show()
                end
            end,
            "select_and_accept",
            "fallback",
        },
    },
    -- # CMD-LINE mode settings
    cmdline = {
        keymap = {
            preset = 'super-tab',
            ["<Up>"] = { "select_prev", "fallback" },
            ["<Down>"] = { "select_next", "fallback" },
            ["<CR>"] = { "select_and_accept", "fallback" },
            ['<C-space>'] = {},
            -- # Manually trigger completion menu with `<Tab>`
            -- # in CMD-LINE mode,
            -- # or you can use the special mode `<Ctrl + space><Tab>`
            ['<Tab>'] = { "show", "select_and_accept", "fallback" },
        },
        completion = {
            menu = {
                auto_show = false,
            },
            list = {
                selection = { auto_insert = false, },
            },
        },
    },
})
