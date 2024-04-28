-- https://github.com/folke/lazy.nvim

---@type string
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

---@diagnostic disable-next-line: undefined-field
if not vim.uv.fs_stat(lazypath) then
    -- Clone the plugin manager when it is not present.
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- Latest stable release.
        lazypath,
    })
end
vim.opt.runtimepath:prepend(lazypath)

-- No need for a patched font.
local icons = {
    cmd     = "[CMD]",
    config  = "[CONF]",
    event   = "[EV]",
    ft      = "[FT]",
    init    = "[INIT]",
    keys    = "[KB]",
    plugin  = "[PLUG]",
    runtime = "[RT]",
    require = "[REQ]",
    source  = "[SRC]",
    start   = "[START]",
    task    = "[TASK]",
    lazy    = "[LAZY]",
}

require("lazy").setup("plugins", {
    ui               = { border  = "rounded", icons = icons },
    defaults         = { lazy    = true },
    change_detection = { enabled = false },
})

vim.keymap.set("n", "<Leader>p", vim.cmd.Lazy)
