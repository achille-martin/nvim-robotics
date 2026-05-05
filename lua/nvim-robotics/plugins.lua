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

local tree_sitter_parsers = {
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
}

local mason_install_path = table.concat{
    vim.env.HOME,
    "/.config/",
    vim.g.custom_nvim_config_name,
    "/autoload/mason",
}

local mason_lsp_servers = {
    "arduino_language_server",
    "bashls",
    "clangd",
    "cmake",
    "cssls",
    "docker_language_server",
    "html",
    "jsonls",
    "lemminx",
    "lua_ls",
    "marksman",
    "matlab_ls",
    "pyright",
    "vimls",
    "yamlls",
}

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
        -- # and specify branch `main` where relevant
        Plug('nvim-treesitter/nvim-treesitter-textobjects', { ['branch'] = 'main' })
        Plug('nvim-treesitter/nvim-treesitter-context')

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

    -- # This plugin complements the autopairs plugin
    -- # so that tags are included in the "pairs"
    -- # Requires treesitter parsers to work
    Plug 'windwp/nvim-ts-autotag'

    Plug 'scottmckendry/cyberdream.nvim'

    -- # Target latest `1.x` release for `blink.cmp`
    Plug('saghen/blink.cmp', { ['tag'] = 'v1.*' })

    Plug 'ibhagwan/fzf-lua'

vim.call('plug#end')

-- SETUP/ACTIVATED PLUGINS

-- # List plugins setup/activated

-- # Force use of git rather than cURL to download treesitter plugins
-- # NOTE: function seems discontinued in the `main` branch of nvim-treesitter
-- require("nvim-treesitter.install").prefer_git = true

-- # Configure the nvim-treesitter plugin
-- # to improve syntax highlighting, indentation, folding,
-- # management of text objects and enhance LSP capabilities
-- #
-- # NOTE: for nvim-treesitter commands, refer to
-- # `:h nvim-treesitter-commands`
require('nvim-treesitter').setup({})

-- # Install tree-sitter parsers and queries
require('nvim-treesitter').install(tree_sitter_parsers)

-- # Specify similar parsers to file types not currently supported:
-- # * .launch files (used in ROS)
-- # * .sdf files (used in ROS)
-- # * .urdf files (used in ROS)
-- # * .xacro files (used in ROS)
-- # * .world files (used in Gazebo)
vim.filetype.add({
    extension = {
        launch = "xml",
        sdf = "xml",
        urdf = "xml",
        xacro = "xml",
        world = "xml",
    }
})

-- # Define key mappings for tree-sitter navigation
-- # By default, Neovim (>= min recommended version) provides the following keymaps:
-- # * Previous node: `[n`
-- # * Next node: `]n`
-- # * Parent node: `an`
-- # * Child node: `in`
-- #
-- # The updated commands are, in VISUAL mode (also applicable in OPERATOR-PENDING mode):
-- # * Parent node: `v`
-- # * Child node: `<backspace>`
vim.api.nvim_set_keymap(
    "x",
    "v",
    "an",
    { noremap=false, silent=true }
)
vim.api.nvim_set_keymap(
    "o",
    "v",
    "an",
    { noremap=false, silent=true }
)
vim.api.nvim_set_keymap(
    "x",
    "<BS>",
    "in",
    { noremap=false, silent=true }
)
vim.api.nvim_set_keymap(
    "o",
    "<BS>",
    "in",
    { noremap=false, silent=true }
)

-- # Configure tree-sitter text objects
require("nvim-treesitter-textobjects").setup({
    select = {
        -- Automatically jump forward to textobject
        lookahead = true,
    },
})

-- # Define key mappings for tree sitter textobjects
-- #
-- # Outer part selection with "a = a-out"
-- # Inner part selection with "i = in"
-- # Ensuring that keymaps are not prone
-- # to mistakes within the VISUAL and OPERATOR-PENDING modes
-- #
-- # NOTE: Block selection (within brackets or entities)
-- # is handled via incremental selection
-- # and with "a<bracket>" and "i<bracket>"

-- # Conditional selection ("i" like "if")
vim.keymap.set({ "x", "o" }, "ai",
    function()
        require "nvim-treesitter-textobjects.select".select_textobject("@conditional.outer", "textobjects")
    end
)
vim.keymap.set({ "x", "o" }, "ii",
    function()
        require "nvim-treesitter-textobjects.select".select_textobject("@conditional.inner", "textobjects")
    end
)
-- # Loop selection (like while and for)
vim.keymap.set({ "x", "o" }, "al",
    function()
        require "nvim-treesitter-textobjects.select".select_textobject("@loop.outer", "textobjects")
    end
)
vim.keymap.set({ "x", "o" }, "il",
    function()
        require "nvim-treesitter-textobjects.select".select_textobject("@loop.inner", "textobjects")
    end
)
-- # Function selection
vim.keymap.set({ "x", "o" }, "af",
    function()
        require "nvim-treesitter-textobjects.select".select_textobject("@function.outer", "textobjects")
    end
)
vim.keymap.set({ "x", "o" }, "if",
    function()
        require "nvim-treesitter-textobjects.select".select_textobject("@function.inner", "textobjects")
    end
)
-- # Class selection
vim.keymap.set({ "x", "o" }, "ac",
    function()
        require "nvim-treesitter-textobjects.select".select_textobject("@class.outer", "textobjects")
    end
)
vim.keymap.set({ "x", "o" }, "ic",
    function()
        require "nvim-treesitter-textobjects.select".select_textobject("@class.inner", "textobjects")
    end
)
-- # Comment selection (similar keymap as commenting out action)
vim.keymap.set({ "x", "o" }, "a\"",
    function()
        require "nvim-treesitter-textobjects.select".select_textobject("@comment.outer", "textobjects")
    end
)
vim.keymap.set({ "x", "o" }, "i\"",
    function()
        require "nvim-treesitter-textobjects.select".select_textobject("@comment.inner", "textobjects")
    end
)

-- # Ensure that nvim-treesitter is configured properly
-- # for highlighting and indenting
-- # via the FileType autocommand
-- # NOTE: folding is commented out because hard to manipulate
vim.api.nvim_create_autocmd('FileType', {
    pattern = tree_sitter_parsers,
    callback = function()
        -- vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
        -- vim.wo[0][0].foldmethod = 'expr'
        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        vim.treesitter.start()
    end,
})

-- # Adjust the configuration of nvim-treesitter-context plugin
-- # to make the windows readable
require("treesitter-context").setup({
    max_lines = 5,
    min_window_height = 1,
    trim_scope = 'inner',
})
vim.cmd(
    [[
        hi TreesitterContextBottom gui=underline guisp=Grey
    ]]
)

-- # Adjust the configuration of mason plugin
-- # to be consistent with the other plugins
require("mason").setup({
    install_root_dir = mason_install_path,
})

-- # Install and configure (if possible) specific LSP servers
-- # Note: the list of available LSP servers can be found via nvim-lspconfig:
-- # https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md
require("mason-lspconfig").setup({
    ensure_installed = mason_lsp_servers,
})

-- # Enable specific LSP servers with default config via nvim-lspconfig
-- # Note: this is automatically handled via mason-lspconfig
-- # unless the feature is turned off `automatic_enable = false`
-- # In this case, each LSP server must be enabled individually with
-- # `vim.lsp.enable('<lsp_server_name')`
-- # Optionally, a custom config can be set for specific LSP servers with
-- # `vim.lsp.config('<lsp_server_name>', {})`

-- # Add `vim` variable to globals in Lua
-- # so that it does not trigger a warning in the LSP
vim.lsp.config["lua_ls"] = {
    settings = {
        Lua = {
            diagnostics = {
                globals = {
                    "vim"
                }
            }
        }
    }
}
-- # Add filetype to specific LSP
vim.lsp.config["lemminx"] = {
    filetypes = {
        'xml',
    },
}

-- # Define the border style for diagnostics floating windows
vim.diagnostic.config{
    float = {
        border = "rounded",
    }
}

-- # Load the autopair plugin
require("nvim-autopairs").setup({})

-- # Load the autotag plugin
require("nvim-ts-autotag").setup({
    opts = {
        enable_close = true, -- Auto close tags
        enable_rename = true, -- Auto rename pairs of tags
        enable_close_on_slash = false -- Auto close on trailing </
    },
})

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

require("fzf-lua").setup({
    winopts = {
        preview = {
            layout = "vertical",
        },
    },
    keymap = {
        -- # Improving navigation in preview window when using fzf-lua
        -- # `Shift + Up/Down` to move line by line
        -- # `Ctrl + Up/Down` to move half a page by half a page
        builtin = {
            ["<S-down>"] = "preview-down",
            ["<S-up>"] = "preview-up",
            ["<C-down>"] = "preview-half-page-down",
            ["<C-up>"] = "preview-half-page-up",
        },
        fzf = {
            ["shift-down"] = "preview-down",
            ["shift-up"] = "preview-up",
            ["ctrl-down"] = "preview-half-page-down",
            ["ctrl-up"] = "preview-half-page-up",
        },
    },
})
