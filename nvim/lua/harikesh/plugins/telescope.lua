-- import telescope plugin safely
local telescope_setup, telescope = pcall(require, 'telescope')
if not telescope_setup then
  return
end

-- import telescope actions safely
local actions_setup, actions = pcall(require, 'telescope.actions')
if not actions_setup then
  return
end

local setup, actions_layout = pcall(require, 'telescope.actions.layout')
if not setup then
  return
end

local trouble = require 'trouble.providers.telescope'

-- Custom actions
local transform_mod = require('telescope.actions.mt').transform_mod
local nvb_actions = transform_mod {
  file_path = function(prompt_bufnr)
    -- Get selected entry and the file full path
    local content = require('telescope.actions.state').get_selected_entry()
    local full_path = content.cwd .. require('plenary.path').path.sep .. content.value

    -- Yank the path to unnamed and clipboard registers
    vim.fn.setreg('"', full_path)
    vim.fn.setreg('+', full_path)

    -- Close the popup
    require('utils').info 'File path is yanked '
    require('telescope.actions').close(prompt_bufnr)
  end,
}

-- configure telescope
telescope.setup {
  -- configure custom mappings
  defaults = {
    mappings = {
      i = {
        ['<C-k>'] = actions.move_selection_previous, -- move to prev result
        ['<C-j>'] = actions.move_selection_next, -- move to next result
        ['<C-q>'] = actions.send_selected_to_qflist + actions.open_qflist, -- send selected to quickfixlist
        ['<C-n>'] = actions.cycle_history_next,
        ['<C-p>'] = actions.cycle_history_prev,
        ['<c-z>'] = trouble.open_with_trouble,
        ['?'] = actions_layout.toggle_preview,
      },
    },
    border = {},
    borderchars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },
    color_devicons = true,
  },
  pickers = {
    find_files = {
      theme = 'ivy',
      previewer = false,
      mappings = {
        n = {
          ['y'] = nvb_actions.file_path,
          ['s'] = nvb_actions.visidata,
        },
        i = {
          ['<C-y>'] = nvb_actions.file_path,
          ['<C-s>'] = nvb_actions.visidata,
        },
      },
      hidden = true,
      find_command = { 'rg', '--files', '--hidden', '-g', '!.git' },
    },
    git_files = {
      theme = 'dropdown',
      previewer = false,
      mappings = {
        n = {
          ['y'] = nvb_actions.file_path,
          ['s'] = nvb_actions.visidata,
        },
        i = {
          ['<C-y>'] = nvb_actions.file_path,
          ['<C-s>'] = nvb_actions.visidata,
        },
      },
    },
    buffers = {
      theme = 'dropdown',
      previewer = false,
      mappings = {
        n = {
          ['y'] = nvb_actions.file_path,
          ['s'] = nvb_actions.visidata,
        },
        i = {
          ['<C-y>'] = nvb_actions.file_path,
          ['<C-s>'] = nvb_actions.visidata,
        },
      },
    },
  },
  extensions = {
    repo = {
      list = {
        fd_opts = {
          '--no-ignore-vcs',
        },
        search_dirs = {
          '~/Volumes/Data/EWBP',
        },
      },
    },
    project = {
      hidden_files = false,
      theme = 'dropdown',
      base_dirs = {
        '/Volumes/Data/EWBP',
      },
      sync_with_nvim_tree = true,
    },
    fzf = {
      fuzzy = true, -- false will only do exact matching
      case_mode = 'smart_case', -- or "ignore_case" or "respect_case"
    },
  },
}

-- To get fzf loaded and working with telescope, you need to call
-- load_extension
telescope.load_extension 'fzf'
telescope.load_extension 'project'
telescope.load_extension 'repo'
telescope.load_extension 'file_browser'
telescope.load_extension 'dap'
telescope.load_extension 'smart_history'
telescope.load_extension 'diff'
