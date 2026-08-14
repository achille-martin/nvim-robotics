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
    "rust",
    "sql",
    "ssh_config",
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
    "diagnosticls",
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

local mason_dap_servers = {
    "python",
}

local custom_dap_config = {
    "python",
}

local installation_timeout_ms = 90000

local winresizer_width_step_resize = 5
local winresizer_height_step_resize = 2

local toggleterm_float_width_percentage = 0.85
local toggleterm_float_height_percentage = 0.85

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

    -- # Provide an API (similar to an adapter) to interface existing debuggers
    -- # via the Debug Adapter Protocol (DAP)
    Plug 'mfussenegger/nvim-dap'
        -- # Indicate plugins depending on nvim-dap
        -- # and used for visualisation purposes
        Plug 'nvim-neotest/nvim-nio'
        Plug 'rcarriga/nvim-dap-ui'
        -- # Indicate plugins depending on nvim-dap
        -- # and also on mason.nvim to download DAP servers easily
        Plug 'jay-babu/mason-nvim-dap.nvim'
        -- # Indicate plugins depending on nvim-dap
        -- # to provide extra server capabilities
        Plug 'mfussenegger/nvim-dap-python'

    Plug 'windwp/nvim-autopairs'

    -- # This plugin complements the autopairs plugin
    -- # so that tags are included in the "pairs"
    -- # Requires treesitter parsers to work
    Plug 'windwp/nvim-ts-autotag'

    Plug 'scottmckendry/cyberdream.nvim'

    -- # Target latest `1.x` release for `blink.cmp`
    Plug('saghen/blink.cmp', { ['tag'] = 'v1.*' })
        -- # Provide optional snippets for the snippet source
        Plug 'rafamadriz/friendly-snippets'
        -- # Provide optional dictionary sources
        Plug 'archie-judd/blink-cmp-words'

    Plug 'ibhagwan/fzf-lua'

    -- # Extend vim's `%` motion
    -- # to find matching elements (parentheses, keywords,...)
    Plug 'andymass/vim-matchup'

    -- # Browser previewer for Markdown
    Plug('iamcco/markdown-preview.nvim',
        {
            ['do'] = function()
                vim.fn['mkdp#util#install']()
            end,
            ['for'] = { 'markdown', 'vim-plug' },
        }
    )

    -- # Improved tabline (for tabs and not for buffers)
    Plug 'nanozuki/tabby.nvim'

    -- # Disable memory-heavy features when handling big files
    Plug 'LunarVim/bigfile.nvim'

    -- # Improved quickfix window and functionalities
    Plug 'stevearc/quicker.nvim'

    -- # Resize splits easily
    Plug 'simeji/winresizer'

    -- # Manage persistent terminals better
    Plug ('akinsho/toggleterm.nvim', { ['tag'] = '*' })

    -- # Show indent lines
    Plug 'lukas-reineke/indent-blankline.nvim'

    -- # Improved diff view
    Plug 'sindrets/diffview.nvim'

    -- # Enable PlantUml syntax highlighting
    -- # By default, create PlantUml files with `.puml` extension
    Plug 'achille-martin/plantuml-syntax'

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
-- # NOTE: wait 1min max to install all parsers and queries the first time
require('nvim-treesitter').install(tree_sitter_parsers):wait(installation_timeout_ms)

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

-- # Install and load DAP servers
require("mason-nvim-dap").setup({
    -- # Handlers required for automatic installation
    handlers = {},
    -- # Exclude servers if configured by external plugins
    automatic_installation = {
        exclude = custom_dap_config,
    },
    -- # Call Mason to check whether the DAP servers are installed
    ensure_installed = mason_dap_servers,
})

-- # Initialise custom DAP configuration for specific filetypes
require("dap-python").setup("python3")

-- # Initialise DAP UI on startup
-- # and trigger it automatically on specific events
local dap, dap_ui = require("dap"), require("dapui")
dap_ui.setup({})
dap.listeners.before.attach.dapui_config = function()
	dap_ui.open()
end
dap.listeners.before.launch.dapui_config = function()
	dap_ui.open()
end
dap.listeners.before.event_terminated.dapui_config = function()
	dap_ui.close()
end
dap.listeners.before.event_exited.dapui_config = function()
	dap_ui.close()
end

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
-- # by tweaking the default settings:
-- # * Download as little noise as possible
-- #   (i.e. prefer Rust if available otherwise Lua, no NerdFonts)
-- # * Make sure that the plugin does not disturb
-- #   normal functionalities (like `<Tab>`)
-- # * Only show completion suggestions on `<Tab>` (under certain conditions)
-- # * Display ghost text only if the completion menu is visible
-- # * Use `Tab` or `Enter` to accept the suggestion
-- # * Use `Ctrl + c` to hide completion menu
require("blink.cmp").setup({
    -- # General settings
    fuzzy = {
        -- # Rust implementation is significantly faster and better
        -- # but for some users it is not available
        -- # therefore, prefer Rust implementation but fallback on Lua
        implementation = "prefer_rust_with_warning",
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
        providers = {
            -- Use the thesaurus source
            thesaurus = {
                name = "blink-cmp-words",
                module = "blink-cmp-words.thesaurus",
                -- All available options
                opts = {
                    -- A score offset applied to returned items.
                    -- By default the highest score is 0 (item 1 has a score of -1, item 2 of -2 etc..).
                    score_offset = 0,
                    -- Default pointers define the lexical relations listed under each definition,
                    -- see Pointer Symbols below.
                    -- Default is as below ("antonyms", "similar to" and "also see").
                    definition_pointers = { "!", "&", "^" },
                    -- The pointers that are considered similar words when using the thesaurus,
                    -- see Pointer Symbols below.
                    -- Default is as below ("similar to", "also see" }
                    similarity_pointers = { "&", "^" },
                    -- The depth of similar words to recurse when collecting synonyms. 1 is similar words,
                    -- 2 is similar words of similar words, etc. Increasing this may slow results.
                    similarity_depth = 2,
                },
            },
            -- Use the dictionary source
            dictionary = {
                name = "blink-cmp-words",
                module = "blink-cmp-words.dictionary",
                -- All available options
                opts = {
                    -- The number of characters required to trigger completion.
                    -- Set this higher if completion is slow, 3 is default.
                    dictionary_search_threshold = 3,
                    -- See above
                    score_offset = 0,
                    -- See above
                    definition_pointers = { "!", "&", "^" },
                },
            },
        },
        -- Setup completion by filetype
        per_filetype = {
            text = { "dictionary" },
            markdown = { "thesaurus" },
        },
    },
    -- # Signature support (experimental)
    -- # Note: a function signature consists of the function prototype.
    -- # It specifies the general information about a function like the name,
    -- # scope and parameters.
    signature = {
        enabled = true,
        window = {
            border = "rounded",
        },
    },
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
            border = "rounded",
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
            window = {
                border = "rounded",
            },
        },
    },
    -- # INSERT mode settings
    keymap = {
        preset = 'super-tab',
        ["<Up>"] = { "select_prev", "fallback" },
        ["<Down>"] = { "select_next", "fallback" },
        ["<S-Tab>"] = { "select_next", "fallback" },
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
            ["<S-Tab>"] = { "select_next", "fallback" },
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
            vertical = "down:60%",
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

-- # Enhance Markdown Preview configuration

-- # Display preview page URL in command line when opening preview page
vim.g.mkdp_echo_preview_url = 1

-- # Set preview page title to file name
vim.g.mkdp_page_title = '「${name}」'

-- # Define configuration for `tabby` plugin
local theme = {
    fill = 'TabLine',
    head = 'TabLine',
    current_tab = { fg='#000000', bg='#FFFDD0' },
    tab = 'TabLine',
    win = 'TabLine',
    tail = 'TabLine',
}
require('tabby').setup({
    -- # Only show tabs and not the files inside the tabs
    line = function(line)
    return {
      line.tabs().foreach(function(tab)
        local hl = tab.is_current() and theme.current_tab or theme.tab
        return {
          line.sep('║', hl, theme.fill),
          tab.is_current(),
          tab.name(),
          tab.close_btn('x'),
          line.sep('║', hl, theme.fill),
          hl = hl,
          margin = ' ',
        }
      end),
      hl = theme.fill,
    }
  end,
})

-- # Define configuration for `bigfile` plugin
require('bigfile').setup({
    -- # Size of the file in MiB
    filesize = 2,
    -- # Autocmd pattern or function
    -- # Refer to https://github.com/LunarVim/bigfile.nvim
    -- # for more information
    pattern = { "*" },
    -- # Features to disable
    features = {
        "indent_blankline",
        "illuminate",
        "lsp",
        "treesitter",
        "syntax",
        "matchparen",
        "vimopts",
        "filetype",
    },
})
-- # NOTE: there is a deprecated warning in `checkhealth` for `bigfile`
-- # and targeted at Nvim 1.0
-- # Refer to https://github.com/LunarVim/bigfile.nvim/issues/30
-- # for more information
-- # Define configuration for `quicker` plugin
vim.api.nvim_set_hl(0, 'BrighterLineNr', { fg = '#A9A9A9' })
require('quicker').setup({
    opts = {
        winhighlight = "QuickFixLineNr:BrighterLineNr",
    },
    type_icons = {
        E = "E",
        W = "W",
        I = "I",
        N = "H",
        H = "H",
    },
})

-- # Define configuration for `winresizer` plugin
-- # NOTE: this plugin does not use the `setup` paradigm
-- #
-- # By default:
-- # * The plugin can be started with `Ctrl + e`
-- # * Switch modes (resize, move, focus) with `e`
-- # * The resizing operation needs to be accepted with `Enter`
-- # * Equalise all window sizes with `=`

-- ## Resize windows using arrow keys
vim.g.winresizer_keycode_up = vim.g.UP_ARROW_CHAR_CODE
vim.g.winresizer_keycode_down = vim.g.DOWN_ARROW_CHAR_CODE
vim.g.winresizer_keycode_left = vim.g.LEFT_ARROW_CHAR_CODE
vim.g.winresizer_keycode_right = vim.g.RIGHT_ARROW_CHAR_CODE

-- ## Define the step length during resize
vim.g.winresizer_vert_resize = winresizer_width_step_resize
vim.g.winresizer_horiz_resize = winresizer_height_step_resize

-- ## Maximise current window width with `Ctrl + arrow right`
-- ## Maximise current window height with `Ctrl + arrow up`
vim.g.winresizer_keycode_hfull = vim.g.CTRL_UP_ARROW_CHAR_CODE
vim.g.winresizer_keycode_vfull = vim.g.CTRL_RIGHT_ARROW_CHAR_CODE

-- # Cancel resize using `Ctrl + c` (ASCII code 3)
vim.g.winresizer_keycode_cancel = 3

-- # Define configuration for `toggleterm` plugin
-- # to have a persistent floating terminal
-- # (to run commands when needed)
require("toggleterm").setup({
    direction = 'float',
    float_opts = {
        border = "rounded",
        width = function()
            return math.floor(vim.o.columns * toggleterm_float_width_percentage)
        end,
        height = function()
            return math.floor(vim.o.lines * toggleterm_float_height_percentage)
        end,
    },
    shade_terminals = false,
    highlights = {
        NormalFloat = {
            guibg = "#070D0B",
        },
        FloatBorder = {
            guifg = "#00A36C",
        },
    },
    hide_numbers = false,
    autochdir = true,
    close_on_exit = true,
    auto_scroll = true,
    on_open = function(term)
        -- # Force enter into proper terminal mode
        vim.schedule(function()
            if vim.api.nvim_win_is_valid(term.window) then
                vim.cmd("startinsert")
            end
        end)
        -- # Set title of floating window
        vim.api.nvim_win_set_config(term.window, {
            title = " Persistent Floating Terminal ",
            title_pos = "center",
        })
        -- # Display custom statusline, outside of the floating window
        vim.wo[term.window].statusline = "%!v:lua.Statusline.active()"
        vim.opt.laststatus = 3
        -- # Hide winbar
        vim.wo[term.window].winbar = ""
    end,
    on_close = function()
        -- # Reset statusline display option
        vim.opt.laststatus = 2
    end,
})

-- # Define configuration for indent-blankline
require("ibl").setup({
    scope = {
        -- # Disable scope because distracting
        enabled = false,
    }
})

-- # Define configuration for diffview plugin
require("diffview").setup({
    use_icons = false,
    show_help_hints = false,
    file_panel = {
        listing_styles = "tree",
        win_config = {
            position = "bottom",
            height = 5,
            win_opts = {},
        },
    },
})
-- # Set fill characters for diff view
vim.opt.fillchars:append { diff = " " }
