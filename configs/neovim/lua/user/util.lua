local M = {}

---@param name string
---@param commands table<string, function>
M.create_user_command = function (name, commands)
    vim.api.nvim_create_user_command(name, function (args)
        if commands[args.args] then
            commands[args.args]()
        else
            vim.notify(name .. ': Invalid subcommand: ' .. args.args, vim.log.levels.ERROR)
        end
    end, {
        nargs = '?',
        complete = function (prefix)
            return vim.tbl_filter(function (command)
                return command:sub(1, #prefix):lower() == prefix:lower()
            end, vim.tbl_keys(commands))
        end,
    })
end

return M
