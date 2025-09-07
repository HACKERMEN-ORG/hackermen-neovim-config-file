-- Hint:
-- :PlugInstall :PlugUpdate :PlugUpgrade :PlugClean
local vim = vim
local opt = vim.opt
local g = vim.g
local api = vim.api

local Plug = vim.fn["plug#"]

-- Auto-install vim-plug if not present
local plug_path = vim.fn.expand('~/.config/nvim/autoload/plug.vim')
if not vim.fn.filereadable(plug_path) then
    print("Downloading junegunn/vim-plug to manage plugins...")
    vim.fn.system('mkdir -p ~/.config/nvim/autoload/')
    vim.fn.system('curl "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim" > ~/.config/nvim/autoload/plug.vim')
    vim.cmd('autocmd VimEnter * PlugInstall')
end

vim.call("plug#begin", "~/.config/nvim/plugged")

    -- Plug("stevearc/oil.nvim")
    Plug("nvim-treesitter/nvim-treesitter", {["do"] = ":TSUpdate"})
    Plug("hrsh7th/nvim-cmp")
    Plug("hrsh7th/cmp-buffer")
    Plug("hrsh7th/cmp-path")
    Plug("hrsh7th/cmp-nvim-lsp")
    Plug("quangnguyen30192/cmp-nvim-tags")
    Plug("EinfachToll/DidYouMean")
    Plug("junegunn/fzf.vim")
    Plug("junegunn/goyo.vim")
    Plug("julienvincent/nvim-paredit")
    Plug("bling/vim-airline")
    Plug("folke/which-key.nvim")
    Plug("altercation/vim-colors-solarized")
    Plug("tpope/vim-commentary")
    Plug("farmergreg/vim-lastplace")
    Plug("tpope/vim-surround")

vim.call("plug#end")

local wk = require("which-key")
wk.add({
  -- spellcheck/shellcheck
  { "<leader>s", group = "Check buffer"},
  { "<leader>ss", group = "Spellcheck"},
  { "<leader>sse", ":setlocal spell! spelllang=en<CR>", desc = "EN Spellcheck",   mode = "n" },
  { "<leader>ssp", ":setlocal spell! spelllang=pt<CR>", desc = "PT Spellcheck",   mode = "n" },
  { "<leader>ssr", ":setlocal spell! spelllang=ru<CR>", desc = "RU Spellcheck",   mode = "n" },
  { "<leader>sss", ":setlocal spell! spelllang=es<CR>", desc = "ES Spellcheck",   mode = "n" },
  { "<leader>sso", ":setlocal spell! spelllang=eo<CR>", desc = "EO Spellcheck",   mode = "n" },
  { "<leader>sh", ":setlocal !clear && shellcheck %<CR>",     desc = "SHellcheck (sh)", mode = "n" },
})

-- Minimal completion
local cmp = require('cmp')
cmp.setup({
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-j>'] = cmp.mapping.select_next_item(),
    ['<C-k>'] = cmp.mapping.select_prev_item(),
    ['<Tab>'] = cmp.mapping.confirm({ select = true }),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'tags' },
    { name = 'buffer' },
    { name = 'path' },
  })
})
cmp.setup.cmdline({ "/", "?" }, {
	mapping = cmp.mapping.preset.cmdline(),
	sources = {
		{ name = "buffer" },
	},
})

cmp.setup.cmdline(":", {
	mapping = cmp.mapping.preset.cmdline(),
	sources = cmp.config.sources({
		{ name = "path" },
	}, {
		{ name = "cmdline" },
	}),
})


-- Turns off highlighting on the bits of code that are changed, so the
-- line that is changed is highlighted but the actual text that has changed
-- stands out on the line and is readable.
if vim.o.diff then
    vim.cmd('highlight! link DiffText MatchParen')
end

-- Global variables
vim.g.dym_use_fzf = 1

-- Syntax and filetype settings
vim.cmd('syntax enable')
vim.cmd('filetype plugin indent on')

-- Leader keys
vim.g.mapleader = " "
vim.g.maplocalleader = ","

-- Uniform n/N when searching
vim.keymap.set('n', 'n', function() return vim.v.searchforward == 1 and 'n' or 'N' end, { expr = true })
vim.keymap.set('x', 'n', function() return vim.v.searchforward == 1 and 'n' or 'N' end, { expr = true })
vim.keymap.set('o', 'n', function() return vim.v.searchforward == 1 and 'n' or 'N' end, { expr = true })
vim.keymap.set('n', 'N', function() return vim.v.searchforward == 1 and 'N' or 'n' end, { expr = true })
vim.keymap.set('x', 'N', function() return vim.v.searchforward == 1 and 'N' or 'n' end, { expr = true })
vim.keymap.set('o', 'N', function() return vim.v.searchforward == 1 and 'N' or 'n' end, { expr = true })

vim.cmd('silent! solarized')
-- Switch solarized colors command
vim.call("togglebg#map", "<F5>")

-- Template and Goyo mappings
vim.keymap.set('n', '<leader><Space>', '/<++><CR>dt>a<BS>', { desc = "Template shortcut" })
vim.keymap.set('n', '<leader>g', ':Goyo | set linebreak<CR>', { desc = "Nicer for writing prose" })

-- Vim settings
-- Enable autocompletion:
vim.o.wildmode = 'longest,list,full'
vim.o.background = 'dark'
vim.o.mouse = 'a'
vim.o.clipboard = 'unnamedplus'
vim.o.expandtab = true
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.number = true
-- Splits open at the bottom and right, which is non-retarded, unlike vim defaults.
vim.o.splitbelow = true
vim.o.splitright = true
opt.scrolloff = 3 -- Reduced to allow zt/zb to work properly
opt.sidescrolloff = 8 -- Enhanced horizontal scroll buffer
-- M4 Pro Max Performance Optimizations
opt.updatetime = 150 -- Much more responsive than Pi (was 1000)
opt.timeoutlen = 300 -- Faster mapped sequence timeout
opt.ttyfast = true -- Keep for terminal compatibility
opt.synmaxcol = 3000 -- Full line highlighting (was 240)
opt.maxmempattern = 20000 -- 10x memory increase for complex patterns
-- Additional terminal fixes for scroll desync
opt.lazyredraw = false -- Ensure screen updates are immediate
opt.redrawtime = 2000 -- Increase redraw timeout for complex operations
opt.scroll = 0 -- Use default scroll calculation to prevent buffer pollution
g.loaded_perl_provider = 0 -- Keep disabled (rarely used)

local function ugroup(name)
	return api.nvim_create_augroup("user_" .. name, { clear = true })
end
-- Enable Goyo by default for mutt writing
vim.api.nvim_create_autocmd({'BufRead', 'BufNewFile'}, {
  pattern = '/tmp/*neomutt*',
  callback = function()
    vim.g.goyo_width = 80
    vim.cmd('Goyo | set linebreak')
    -- hack
    vim.keymap.set('n', 'ZZ', ':x!<CR>', { buffer = true })
    vim.keymap.set('n', 'ZQ', ':q!<CR>', { buffer = true })
  end
})

-- whitespace deletion. Each is applied in order, so you have to undo work sometimes.
-- disabled this one because of markdown's incompatibility. It has a double-space for soft line-ending thing.
--autocmd BufWritePre * %s/\s\+$//e " trailing space
vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = '*',
  command = '%s/\\n\\+\\%$//e' -- trailing newline
})

vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = '*.[ch]',
  command = '%s/\\%$/\\r/e' -- add trailing newline for C programs
})

-- But don't do it for email buffers thanks to the dash-dash-space signature separator
vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = '*neomutt*',
  command = '%s/^--$/-- /e'
})

-- Treesitter with highlighting disabled
require('nvim-treesitter.configs').setup {
  highlight = {
    enable = false,
  },
  indent = {
    enable = true
  },
  auto_install = true,
}

-- Set completeopt for automatic menu
vim.opt.completeopt = {'menu', 'menuone', 'noselect'}

-- Highlight on yank
api.nvim_create_autocmd("TextYankPost", {
	group = ugroup("highlight_yank"),
	callback = function()
		vim.highlight.on_yank({ timeout = 200 })
	end,
	desc = "Highlight yanked text",
})

-- optional SLOP
vim.cmd("source ~/.config/nvim/slop/treesitter.lua")
vim.cmd("source ~/.config/nvim/slop/lsp.lua")
vim.cmd("source ~/.config/nvim/slop/lsp/pylsp.lua")
vim.cmd("source ~/.config/nvim/slop/lsp/clangd.lua")
vim.cmd("source ~/.config/nvim/slop/lsp/cl_lsp.lua")
