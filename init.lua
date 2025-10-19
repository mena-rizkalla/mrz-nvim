-- File: ~/.config/nvim/init.lua
-- This is your complete starting configuration for Neovim.

-----------------------------------------------------------------------------
-- 1. BOOTSTRAP LAZY.NVIM (PLUGIN MANAGER)
-----------------------------------------------------------------------------

local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim',
    '--branch=stable', -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-----------------------------------------------------------------------------
-- 2. BASIC NEOVIM SETTINGS
-----------------------------------------------------------------------------

-- Set leader key to space
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Set options for a better editing experience
vim.opt.number = true          -- Show line numbers
vim.opt.mouse = 'a'            -- Enable mouse support
vim.opt.clipboard = 'unnamedplus' -- Use system clipboard
vim.opt.undofile = true        -- Persist undo history
vim.opt.ignorecase = true      -- Case-insensitive searching
vim.opt.smartcase = true       -- ...unless it contains a capital letter
vim.opt.signcolumn = 'yes'     -- Always show the sign column

-- Tab settings
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.termguicolors = true

-----------------------------------------------------------------------------
-- 3. KEYMAPS
-----------------------------------------------------------------------------

local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Keymap to toggle NvimTree
keymap('n', '<leader>e', ':NvimTreeToggle<CR>', opts)
keymap('n', '<leader>gg', ':Lazygit<CR>', opts)
keymap('n', '<leader>w', ':w<CR>', { desc = 'Save file' })

-----------------------------------------------------------------------------
-- 4. CONFIGURE PLUGINS WITH LAZY.NVIM
-----------------------------------------------------------------------------

require('lazy').setup({

  -- Your plugins go here, specified in a table
  
  -- Colorscheme Plugin (tokyonight)
  {
    'folke/tokyonight.nvim',
    lazy = false, -- make sure we load this during startup
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      -- This function runs after the plugin is loaded
      -- Load the colorscheme here
      vim.cmd.colorscheme 'tokyonight'
    end,
  },

  -- File Explorer
  {
    'nvim-tree/nvim-tree.lua',
    dependencies = { 'nvim-tree/nvim-web-devicons' }, -- Optional: for icons
    config = function()
      require('nvim-tree').setup {}
    end,
  },
  
  -- Fuzzy Finder
  {
    'nvim-telescope/telescope.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local builtin = require('telescope.builtin')
      keymap('n', '<leader>ff', builtin.find_files, { desc = 'Find files' })
      keymap('n', '<leader>fg', builtin.live_grep, { desc = 'Grep text' })
    end,
  },

  -- Syntax Highlighting
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = function()
      require('nvim-treesitter.configs').setup({
        ensure_installed = { 'lua', 'bash', 'kotlin', 'java', 'xml', 'groovy' },
        highlight = { enable = true },
      })
    end,
  },

  -- Status Line
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('lualine').setup({
        options = {
          theme = 'tokyonight',
          icons_enabled = true,
          component_separators = { left = '', right = '' },
          section_separators = { left = '', right = '' },
        },
        sections = {
          lualine_c = { { function() return "MRZ  MRZ MRZ" end } },
        },
      })
    end,
  },

  -- Dashboard
  {
    'goolord/alpha-nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      local alpha = require('alpha')
      local dashboard = require('alpha.themes.dashboard')

      -- MRZ ASCII Art Header
      dashboard.section.header.val = {
        [[                   __  __   ____   ______  ]],
        [[                  |  \/  | |  _ \ |___  /  ]],
        [[                  | \  / | | |_) |   / /   ]],
        [[                  | |\/| | |  _ <   / /    ]],
        [[                  | |  | | | | \ \ / /__   ]],
        [[                  |_|  |_| |_|  \_\_____|  ]],
      }
      dashboard.section.buttons.val = {
          dashboard.button("f", " " .. "Find File", ":Telescope find_files <CR>"),
          dashboard.button("n", " " .. "New File", ":enew <CR>"),
          dashboard.button("q", " " .. "Quit", ":qa <CR>"),
      }
      alpha.setup(dashboard.opts)
    end,
  },

  -- Quality of Life Helpers
  { 'lewis6991/gitsigns.nvim', config = true },
  { 'kdheepak/lazygit.nvim' },
  { 'numToStr/Comment.nvim', config = true },
  { 'windwp/nvim-autopairs', config = true },

-- LSP & AUTOCOMPLETION PLUGINS --

  -- LSP Configuration
  { 'neovim/nvim-lspconfig' },

  -- Language Server Installer
  {
    'williamboman/mason.nvim',
    config = function()
      require('mason').setup()
    end,
  },

  -- Bridge for Mason and lspconfig
  {
    'williamboman/mason-lspconfig.nvim',
    dependencies = { 'williamboman/mason.nvim', 'neovim/nvim-lspconfig' },
    config = function()
      local on_attach = function(client, bufnr)
        -- This function runs when an LSP attaches to a buffer.
        -- It's the perfect place to set keymaps that only work with LSP.
        local bufopts = { noremap = true, silent = true, buffer = bufnr }
        keymap('n', 'gd', vim.lsp.buf.definition, bufopts)
        keymap('n', 'K', vim.lsp.buf.hover, bufopts)
        keymap('n', '<leader>ca', vim.lsp.buf.code_action, bufopts)
        keymap('n', '<leader>f', function() vim.lsp.buf.format({ async = true }) end, bufopts)
      end
        
      require('mason-lspconfig').setup({
        ensure_installed = { 'kotlin_language_server', 'jdtls' , 'bashls' }, -- Servers for Kotlin & Java
        handlers = {
          function(server_name)
            require('lspconfig')[server_name].setup({
                on_attach = on_attach,
            })
          end,
        },
      })
    end,
  },

  -- Autocompletion Engine
  {
    'hrsh7th/nvim-cmp',
    dependencies = { 
        'hrsh7th/cmp-nvim-lsp', 
        'hrsh7th/cmp-buffer', 
        'hrsh7th/cmp-path',
        'L3MON4D3/LuaSnip',
        'saadparwaiz1/cmp_luasnip',
    },
    config = function()
      local cmp = require('cmp')
      local luasnip = require('luasnip')
      cmp.setup({
          snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'buffer' },
          { name = 'path' },
        }),
        mapping = {
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
          ['<C-n>'] = cmp.mapping.select_next_item(),
          ['<C-p>'] = cmp.mapping.select_prev_item(),
          ['<Tab>'] = cmp.mapping(function(fallback)
            if luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { 'i', 's' }),
          ['<S-Tab>'] = cmp.mapping(function(fallback)
            if luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { 'i', 's' }),
        },
      })
    end,
  },
{
    'L3MON4D3/LuaSnip',
    dependencies = { 'rafamadriz/friendly-snippets' },
    config = function()
      -- This is the line that was missing
      require("luasnip.loaders.from_vscode").lazy_load()
    end,
  },

  -- ADD YOUR OTHER PLUGINS BELOW THIS LINE
  -- Example:
  -- { 'nvim-tree/nvim-tree.lua' },
  -- { 'nvim-telescope/telescope.nvim' },

})

-- The setup is complete.
