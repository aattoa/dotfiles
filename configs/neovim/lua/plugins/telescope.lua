---@return boolean
local function is_git_dir()
    return vim.fn.finddir(".git", ".;") ~= ""
end

---@param builtin string
---@param options table|nil
---@return function
local function telescope(builtin, options)
    return function ()
        require("telescope.builtin")[builtin](options)
    end
end

return {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
        { "<Leader>f", function ()
            local builtin = is_git_dir() and "git_files" or "find_files"
            telescope(builtin, { show_untracked = true })()
        end },
        { "<Leader>m",  telescope("man_pages", { sections = { "ALL" } }) },
        { "<Leader>`",  telescope("find_files", { cwd = "$HOME" })       },
        { "<Leader>/",  telescope("find_files")                          },
        { "<Leader>o",  telescope("oldfiles")                            },
        { "<Leader>r",  telescope("live_grep")                           },
        { "<Leader>lf", telescope("lsp_references")                      },
        { "<Leader>ls", telescope("lsp_document_symbols")                },
        { "?",          telescope("help_tags")                           },
    },
}
