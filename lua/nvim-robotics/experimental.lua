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
