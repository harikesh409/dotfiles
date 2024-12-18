-- auto install packer if not installed
local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system { 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path }
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end
local packer_bootstrap = ensure_packer() -- true if packer was just installed

-- autocommand that reloads neovim and installs/updates/removes plugins
-- when file is saved
vim.cmd [[ 
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins-setup.lua source <afile> | PackerSync
  augroup end
]]

-- import packer safely
local status, packer = pcall(require, 'packer')
if not status then
  return
end

-- add list of plugins to install
return packer.startup(function(use)
  -- packer can manage itself
  use 'wbthomason/packer.nvim'

  use 'nvim-lua/plenary.nvim' -- lua functions that many plugins use

  use 'bluz71/vim-nightfly-guicolors' -- preferred colorscheme
  -- use("navarasu/onedark.nvim")
  use 'christoomey/vim-tmux-navigator' -- tmux & split window navigation

  use 'szw/vim-maximizer' -- maximizes and restores current window

  -- essential plugins
  use { 'tpope/vim-surround', event = 'BufReadPre' } -- add, delete, change surroundings (it's awesome)
  use 'inkarkat/vim-ReplaceWithRegister' -- replace with register contents using motion (gr + motion)

  -- commenting with gc
  use {
    'numToStr/Comment.nvim',
    keys = { 'gc', 'gcc', 'gbc' },
    config = function()
      require('harikesh/plugins/comment').setup()
    end,
  }

  -- file explorer
  use 'nvim-tree/nvim-tree.lua'

  -- vs-code like icons
  use 'nvim-tree/nvim-web-devicons'

  -- statusline
  use 'nvim-lualine/lualine.nvim'

  -- fuzzy finding w/ telescope
  use {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    event = { 'VimEnter' },
    requires = {
      {
        'nvim-telescope/telescope-fzf-native.nvim', -- dependency for better sorting performance
        run = 'make',
      },
      { 'nvim-telescope/telescope-project.nvim' },
      { 'cljoly/telescope-repo.nvim' },
      { 'nvim-telescope/telescope-file-browser.nvim' },
      { 'nvim-telescope/telescope-dap.nvim' },
      { 'nvim-telescope/telescope-smart-history.nvim' },
      { 'nvim-lua/plenary.nvim' },
      { 'jemag/telescope-diff.nvim' },
    },
  } -- fuzzy finder

  -- autocompletion
  use 'hrsh7th/nvim-cmp' -- completion plugin
  use 'hrsh7th/cmp-buffer' -- source for text in buffer
  use 'hrsh7th/cmp-path' -- source for file system paths

  -- snippets
  use 'L3MON4D3/LuaSnip' -- snippet engine
  use 'saadparwaiz1/cmp_luasnip' -- for autocompletion
  use 'rafamadriz/friendly-snippets' -- useful snippets

  -- managing & installing lsp servers, linters & formatters
  use 'williamboman/mason.nvim' -- in charge of managing lsp servers, linters & formatters
  use 'williamboman/mason-lspconfig.nvim' -- bridges gap b/w mason & lspconfig
  use 'WhoIsSethDaniel/mason-tool-installer.nvim'

  -- configuring lsp servers
  use 'neovim/nvim-lspconfig' -- easily configure language servers
  use 'hrsh7th/cmp-nvim-lsp' -- for autocompletion
  use {
    'glepnir/lspsaga.nvim',
    branch = 'main',
    requires = {
      { 'nvim-tree/nvim-web-devicons' },
      { 'nvim-treesitter/nvim-treesitter' },
    },
  }
  -- enhanced lsp uis
  use 'onsails/lspkind.nvim' -- vs-code like icons for autocompletion

  -- formatting & linting
  -- use 'jose-elias-alvarez/null-ls.nvim' -- configure formatters & linters
  -- use 'jayp0521/mason-null-ls.nvim' -- bridges gap b/w mason & null-ls

  -- treesitter configuration
  use {
    'nvim-treesitter/nvim-treesitter',
    run = function()
      local ts_update = require('nvim-treesitter.install').update { with_sync = true }
      ts_update()
    end,
  }

  -- auto closing
  use 'windwp/nvim-autopairs' -- autoclose parens, brackets, quotes, etc...
  use { 'windwp/nvim-ts-autotag', after = 'nvim-treesitter' } -- autoclose tags

  -- git integration
  use {
    'lewis6991/gitsigns.nvim',
    event = 'BufReadPre',
    requires = { 'nvim-lua/plenary.nvim' },
    config = function()
      require('harikesh/plugins/gitsigns').setup()
    end,
  } -- show line modifications on left hand side
  use {
    'NeogitOrg/neogit',
    cmd = 'Neogit',
    module = { 'neogit' },
    config = function()
      require('harikesh/plugins/neogit').setup()
    end,
  }

  -- which key helper to show keymappins
  use {
    'folke/which-key.nvim',
    config = function()
      require('harikesh/plugins/whichkey').setup()
    end,
  }

  -- java language server
  use { 'mfussenegger/nvim-jdtls', ft = { 'java' } }

  -- Debugging
  use {
    'mfussenegger/nvim-dap',
    opt = true,
    module = { 'dap' },
    requires = {
      { 'theHamsta/nvim-dap-virtual-text', module = { 'nvim-dap-virtual-text' } },
      { 'rcarriga/nvim-dap-ui', module = { 'dapui' } },
      'nvim-telescope/telescope-dap.nvim',
      { 'jbyuki/one-small-step-for-vimkind', module = 'osv' },
    },
    config = function()
      require('harikesh/config/dap').setup()
    end,
  }

  -- visual tabs
  use {
    'akinsho/bufferline.nvim',
    event = 'BufReadPre',
    config = function()
      require('harikesh/plugins/bufferline').setup()
    end,
    requires = 'nvim-tree/nvim-web-devicons',
  }

  -- IndentLine
  use {
    'lukas-reineke/indent-blankline.nvim',
    event = 'BufReadPre',
    config = function()
      require('harikesh/plugins/indentblankline').setup()
    end,
  }

  if packer_bootstrap then
    require('packer').sync()
  end
end)
