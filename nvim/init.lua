-- Set <space> as the leader key
-- See `:help mapleader`
-- NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '

-- -- [[ SETTING OPTIONS ]]
-- See `:h vim.o`
-- NOTE: You can change these options as you wish!
-- For more options, you can see `:help option-list`
-- To see documentation for an option, you can use `:h 'optionname'`, for example `:h 'number'`
-- (Note the single quotes)

-- Print the line number in front of each line
vim.o.number = true

-- Use relative line numbers, so that it is easier to jump with j, k. This will affect the 'number'
-- option above, see `:h number_relativenumber`
vim.o.relativenumber = true

-- Sync clipboard between OS and Neovim. Schedule the setting after `UiEnter` because it can
-- increase startup-time. Remove this option if you want your OS clipboard to remain independent.
-- See `:help 'clipboard'`
vim.api.nvim_create_autocmd('UIEnter', {
  callback = function()
    vim.o.clipboard = 'unnamedplus'
  end,
})

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.o.ignorecase = true
vim.o.smartcase = true

-- Highlight the line where the cursor is on
vim.o.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.o.scrolloff = 20

-- Show <tab> and trailing spaces
vim.o.list = true
vim.opt.listchars = { tab = '  ', trail = '-', nbsp = '+' }

-- if performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
-- instead raise a dialog asking if you wish to save the current file(s) See `:help 'confirm'`
vim.o.confirm = true

-- -- [[ UI CONFIGURATION ]]
vim.o.winbar = '%f %m'                    -- put file path at top of buffer

-- -- [[ SET UP KEYMAPS ]]
-- See `:h vim.keymap.set()`, `:h mapping`, `:h keycodes`

-- Use <Esc> to exit terminal mode
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>')

-- Map <A-j>, <A-k>, <A-h>, <A-l> to navigate between windows in any modes
vim.keymap.set({ 't', 'i' }, '<A-h>', '<C-\\><C-n><C-w>h')
vim.keymap.set({ 't', 'i' }, '<A-j>', '<C-\\><C-n><C-w>j')
vim.keymap.set({ 't', 'i' }, '<A-k>', '<C-\\><C-n><C-w>k')
vim.keymap.set({ 't', 'i' }, '<A-l>', '<C-\\><C-n><C-w>l')
vim.keymap.set({ 'n' }, '<A-h>', '<C-w>h')
vim.keymap.set({ 'n' }, '<A-j>', '<C-w>j')
vim.keymap.set({ 'n' }, '<A-k>', '<C-w>k')
vim.keymap.set({ 'n' }, '<A-l>', '<C-w>l')

-- -- [[ CUSTOM KEY BINDINGS ]]
-- stylua: ignore start
vim.keymap.set('i', '<C-h>', '<C-g>u<C-w>')                       -- remap ctrl+backspace to delete word before cursor
vim.keymap.set('i', '<C-Del>', '<C-o>dw')                         -- remap ctrl+delete to delete word after cursor
vim.keymap.set('i', '<C-_>', '<C-o>gcc', { remap = true })        -- remap ctrl+/ to insert a comment in insert mode
vim.keymap.set('n', '<C-_>', 'gcc', { remap = true })             -- remap ctrl+/ to insert a comment in normal mode
vim.keymap.set('x', '<C-_>', 'gc', { remap = true })              -- remap ctrl+/ to insert a comment in visual mode

vim.keymap.set(
  'n',
  '<C-p>',
  '<Cmd>Pick files<CR>',
  { desc = 'Find files' }
)                                                                 -- remap ctrl+p to find files 
vim.keymap.set(
  'n',
  '<leader>ff',
  '<Cmd>Pick files<CR>',
  { desc = 'Find files' }
)                                                                 -- remap ' ff' to find files 
vim.keymap.set(
  'n',
  '<C-F>',
  '<Cmd>Pick grep_live<CR>',
  { desc = 'Search file contents' }
)                                                                 -- remap ctrl+shift+f to search all file contents
vim.keymap.set(
  'n',
  '<leader>fg',
  '<Cmd>Pick grep_live<CR>',
  { desc = 'Search file contents' }
)                                                                 -- remap ' fg' to search file contents
vim.keymap.set(
  'n',
  '<leader>fb',
  '<Cmd>Pick buffers<CR>',
  { desc = 'Open buffers' }
)                                                                 -- remap ' fb' to open buffers
-- stylua: ignore end

-- -- [[ BASIC AUTOCOMMANDS ]].
-- See `:h lua-guide-autocommands`, `:h autocmd`, `:h nvim_create_autocmd()`

-- Highlight when yanking (copying) text.
-- Try it with `yap` in normal mode. See `:h vim.hl.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  callback = function()
    vim.hl.on_yank()
  end,
})

-- -- [[ CREATE USER COMMANDS ]]
-- See `:h nvim_create_user_command()` and `:h user-commands`

-- Create a command `:GitBlameLine` that print the git blame for the current line
vim.api.nvim_create_user_command('GitBlameLine', function()
  local line_number = vim.fn.line('.') -- Get the current line number. See `:h line()`
  local filename = vim.api.nvim_buf_get_name(0)
  print(vim.fn.system({ 'git', 'blame', '-L', line_number .. ',+1', filename }))
end, { desc = 'Print the git blame for the current line' })

-- -- [[ ADD OPTIONAL PACKAGES ]]
-- Nvim comes bundled with a set of packages that are not enabled by
-- default. You can enable any of them by using the `:packadd` command.

-- For example, to add the "nohlsearch" package to automatically turn off search highlighting after
-- 'updatetime' and when going to insert mode
vim.cmd('packadd! nohlsearch')

-- -- [[ PERSONAL SETTING OPTIONS ]]
-- insert spaces when you press tab 
vim.opt.expandtab = true    -- insert spaces when you press tab
vim.opt.tabstop = 2         -- tab character uses 2 spaces
vim.opt.shiftwidth = 2      -- >>, <<, and auto-indent use 2 spaces
vim.opt.softtabstop = 2     -- tab/backspace move 2 spaces at a time

-- -- [[ PLUGIN CONFIGURATION ]]
-- Install plugins
vim.pack.add({
  "https://github.com/stevearc/conform.nvim",
  { src = "https://github.com/rose-pine/neovim", name = "rose-pine" },
  "https://github.com/nvim-mini/mini.pick",
  "https://github.com/neovim/nvim-lspconfig",
})

-- Configure format on save
require("conform").setup({
  formatters_by_ft = {
    lua = { "stylua" },
    javascript = { "prettier" },
    javascriptreact = { "prettier" },
    typescript = { "prettier" },
    typescriptreact = { "prettier" },
    css = { "prettier" },
    scss = { "prettier" },
    html = { "prettier" },
    json = { "prettier" },
    markdown = { "prettier" },
  },
  format_on_save = {
    timeout_ms = 2000,
    lsp_format = "fallback",
  },
})

-- Configure theme
require("rose-pine").setup({
  variant = "moon"
})

vim.cmd.colorscheme("rose-pine")

-- Configure fuzzy finder plugin
require("mini.pick").setup()

