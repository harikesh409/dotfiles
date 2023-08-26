local M = {}
local whichkey = require 'which-key'

local conf = {
  window = {
    border = 'single', -- none, single, double, shadow
    position = 'bottom', -- bottom, top
  },
}
whichkey.setup(conf)

local opts = {
  mode = 'n', -- Normal mode
  prefix = '<leader>',
  buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
  silent = true, -- use `silent` when creating keymaps
  noremap = true, -- use `noremap` when creating keymaps
  nowait = false, -- use `nowait` when creating keymaps
}

local v_opts = {
  mode = 'v', -- Visual mode
  prefix = '<leader>',
  buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
  silent = true, -- use `silent` when creating keymaps
  noremap = true, -- use `noremap` when creating keymaps
  nowait = false, -- use `nowait` when creating keymaps
}

local function normal_keymap()
  local keymap_f = nil -- File search
  local keymap_p = nil -- Project search
  local keymap_t = nil -- Tab Management

  keymap_f = {
    name = 'Find',
    f = { "<cmd>lua require('harikesh/utils/finder').find_files()<cr>", 'files within cwd' },
    b = { "<cmd>lua require('telescope.builtin').buffers()<cr>", 'Buffers' },
    h = { "<cmd>lua require('telescope.builtin').help_tags()<cr>", 'Help' },
    m = { "<cmd>lua require('telescope.builtin').marks()<cr>", 'Marks' },
    o = { "<cmd>lua require('telescope.builtin').oldfiles()<cr>", 'Old Files' },
    g = { "<cmd>lua require('telescope.builtin').live_grep()<cr>", 'string in cwd' },
    n = { "<cmd>lua require('telescope.builtin').commands()<cr>", 'Commands' },
    C = { "<cmd>lua require'telescope'.extensions.diff.diff_files({ hidden = true })<cr>", 'Compare 2 Files' },
    c = { "<cmd>lua require'telescope'.extensions.diff.diff_current({ hidden = true })<cr>", 'Compare with current file' },
    r = { "<cmd>lua require'telescope'.extensions.file_browser.file_browser()<cr>", 'File Browser' },
    w = { "<cmd>lua require('telescope.builtin').current_buffer_fuzzy_find()<cr>", 'Current Buffer' },
    e = { '<cmd>NvimTreeToggle<cr>', 'Explorer' },
    s = { "<cmd>lua require('telescope.builtin').grep_string()<cr>", 'grep string' },
  }

  keymap_p = {
    name = 'Project',
    -- c = {},
    p = { "<cmd>lua require'telescope'.extensions.project.project{display_type = 'full'}<cr>", 'List' },
    s = { "<cmd>lua require'telescope'.extensions.repo.list{}<cr>", 'Search' },
  }

  keymap_t = {
    name = 'Tab Management',
    o = { '<cmd>tabnew<CR>', 'Open New Tab' },
    x = { '<cmd>tabclose<CR>', 'Close current tab' },
    n = { '<cmd>tabn<CR>', 'go to next tab' },
    p = { '<cmd>tabp<CR>', 'go to previous tab' },
  }

  local keymap = {
    b = {
      name = 'Buffer',
      c = { '<Cmd>BDelete this<Cr>', 'Close Buffer' },
      f = { '<Cmd>bdelete!<Cr>', 'Force Close Buffer' },
      D = { '<Cmd>BWipeout other<Cr>', 'Delete All Buffers' },
      b = { '<Cmd>BufferLinePick<Cr>', 'Pick a Buffer' },
      p = { '<Cmd>BufferLinePickClose<Cr>', 'Pick & Close a Buffer' },
      m = { '<Cmd>JABSOpen<Cr>', 'Menu' },
    },
    c = {
      name = 'Code',
      g = { '<cmd>Neogen func<Cr>', 'Func Doc' },
      G = { '<cmd>Neogen class<Cr>', 'Class Doc' },
      d = { '<cmd>DogeGenerate<Cr>', 'Generate Doc' },
      o = { '<cmd>Telescope aerial<Cr>', 'Outline' },
      T = { '<cmd>TodoTelescope<Cr>', 'TODO' },
      x = {
        name = 'Swap Next',
        f = 'Function',
        p = 'Parameter',
        c = 'Class',
      },
      X = {
        name = 'Swap Previous',
        f = 'Function',
        p = 'Parameter',
        c = 'Class',
      },
      -- f = "Select Outer Function",
      -- F = "Select Outer Class",
    },

    d = {
      name = 'Debug',
    },

    f = keymap_f,

    g = {
      name = 'Git',
      -- c = { "<cmd>lua require('harikesh/utils/term').git_commit_toggle()<CR>", 'Conventional Commits' },
      p = { '<cmd>Git push<CR>', 'Push' },
      s = { "<cmd>lua require('neogit').open()<CR>", 'Status - Neogit' },
      S = { '<cmd>Git<CR>', 'Status - Fugitive' },
      -- y = {
      -- "<cmd>lua require'gitlinker'.get_buf_range_url('n', {action_callback = require'gitlinker.actions'.open_in_browser})<cr>",
      -- "Link",
      -- },
      g = { "<cmd>lua require('telescope').extensions.gh.gist()<CR>", 'Gist' },
      -- z = { "<cmd>lua require('utils.term').git_client_toggle()<CR>", 'Git TUI' },
      h = { name = 'Hunk' },
      t = { name = 'Toggle' },
      x = { "<cmd>lua require('telescope.builtin').git_branches()<cr>", 'Switch Branch' },
    },
    p = keymap_p,

    r = {
      name = 'Restart',
      s = { '<cmd>LspRestart<CR>', 'Restart LSP' },
    },

    t = keymap_t,
  }

  whichkey.register(keymap, opts)
end

local function visual_keymap()
  local keymap = {
    r = {
      name = 'Refactor',
      r = { [[<cmd>lua require('telescope').extensions.refactoring.refactors()<cr>]], 'Refactor' },
    },
  }
  whichkey.register(keymap, v_opts)
end

local function code_keymap()
  vim.api.nvim_create_autocmd('FileType', {
    pattern = '*',
    callback = function()
      vim.schedule(CodeRunner)
    end,
  })

  function CodeRunner()
    local bufnr = vim.api.nvim_get_current_buf()
    local ft = vim.api.nvim_buf_get_option(bufnr, 'filetype')
    local fname = vim.fn.expand '%:p:t'
    local keymap_c = {} -- normal key map
    local keymap_c_v = {} -- visual key map
    if ft == 'lua' then
      keymap_c = {
        name = 'Code',
        r = { '<cmd>luafile %<cr>', 'Run' },
      }
    elseif ft == 'typescript' or ft == 'typescriptreact' or ft == 'javascript' or ft == 'javascriptreact' then
      keymap_c = {
        name = 'Code',
        o = { '<cmd>TypescriptOrganizeImports<cr>', 'Organize Imports' },
        r = { '<cmd>TypescriptRenameFile<cr>', 'Rename File' },
        i = { '<cmd>TypescriptAddMissingImports<cr>', 'Import Missing' },
        F = { '<cmd>TypescriptFixAll<cr>', 'Fix All' },
        u = { '<cmd>TypescriptRemoveUnused<cr>', 'Remove Unused' },
        R = { "<cmd>lua require('config.test').javascript_runner()<cr>", 'Choose Test Runner' },
        s = { "<cmd>2TermExec cmd='yarn start'<cr>", 'Yarn Start' },
        t = { "<cmd>2TermExec cmd='yarn test'<cr>", 'Yarn Test' },
      }
    elseif ft == 'java' then
      keymap_c = {
        name = 'Code',
        c = { "<cmd>lua require('jdtls').compile('increment')<cr>", 'Compile' },
        f = { '<cmd>lua vim.lsp.buf.format()<CR>', 'Format' },
        o = { "<cmd>lua require('jdtls').organize_imports()<cr>", 'Organize Imports' },
        v = { "<cmd>lua require('jdtls').extract_variable()<cr>", 'Extract Variable' },
        e = { "<cmd>lua require('jdtls').extract_constant()<cr>", 'Extract Constant' },
        t = { "<cmd>lua require('jdtls').test_class()<cr>", 'Test Class' },
        n = { "<cmd>lua require('jdtls').test_nearest_method()<cr>", 'Test Nearest Method' },
      }
      keymap_c_v = {
        name = 'Code',
        v = { "<cmd>lua require('jdtls').extract_variable(true)<cr>", 'Extract Variable' },
        c = { "<cmd>lua require('jdtls').extract_constant(true)<cr>", 'Extract Constant' },
        m = { "<cmd>lua require('jdtls').extract_method(true)<cr>", 'Extract Method' },
      }
    end

    if next(keymap_c) ~= nil then
      whichkey.register({ c = keymap_c }, { mode = 'n', silent = true, noremap = true, buffer = bufnr, prefix = '<leader>', nowait = true })
    end

    if next(keymap_c_v) ~= nil then
      whichkey.register({ c = keymap_c_v }, { mode = 'v', silent = true, noremap = true, buffer = bufnr, prefix = '<leader>', nowait = true })
    end
  end
end

function M.setup()
  normal_keymap()
  visual_keymap()
  code_keymap()
end

return M
