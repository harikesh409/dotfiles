local jdtls_ok, jdtls = pcall(require, 'jdtls')
if not jdtls_ok then
  vim.notify 'JDTLS not found, install with `:LspInstall jdtls`'
  return
end

-- Installation location of jdtls by nvim-lsp-installer
local mason_packages = vim.fn.stdpath 'data' .. '/mason/packages'
local jdtls_dir = mason_packages .. '/jdtls'
local config_dir = jdtls_dir .. '/config_mac'
local plugins_dir = jdtls_dir .. '/plugins/'
local path_to_jar = plugins_dir .. 'org.eclipse.equinox.launcher_1.6.500.v20230622-2056.jar'
local path_to_lombok = jdtls_dir .. '/lombok.jar'

local root_markers = { '.git', 'mvnw', 'pom.xml' }
local root_dir = require('jdtls.setup').find_root(root_markers)
if root_dir == '' then
  return
end

local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
local workspace_dir = vim.fn.stdpath 'data' .. '/site/java/workspace-root/' .. project_name
os.execute('mkdir -p ' .. workspace_dir)

local extendedClientCapabilities = jdtls.extendedClientCapabilities
extendedClientCapabilities.resolveAdditionalTextEditsSupport = true

-- Debugging
local bundles = {
  vim.fn.glob(mason_packages .. '/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar', 1),
}
vim.list_extend(bundles, vim.split(vim.fn.glob(mason_packages .. '/java-test/extension/server/*.jar', 1), '\n'))

local on_attach = function(client, bufnr)
  -- Configure for jdtls
  -- if client.name == 'jdt.ls' then
  local _, _ = pcall(vim.lsp.codelens.refresh)
  jdtls.setup_dap { hotcodereplace = 'auto' }
  require('lvim.lsp').on_attach(client, bufnr)
  local status_ok, jdtls_dap = pcall(require, 'jdtls.dap')
  if status_ok then
    jdtls_dap.setup_dap_main_class_configs()
  end
  -- end
  require('lsp_signature').on_attach({
    bind = true, -- This is mandatory, otherwise border config won't get registered.
    floating_window_above_cur_line = false,
    padding = '',
    handler_opts = {
      border = 'rounded',
    },
  }, bufnr)
end

-- Main Config
local config = {
  -- The command that starts the language server
  -- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
  cmd = {
    'java',
    '-Declipse.application=org.eclipse.jdt.ls.core.id1',
    '-Dosgi.bundles.defaultStartLevel=4',
    '-Declipse.product=org.eclipse.jdt.ls.core.product',
    '-Djava.configuration.maven.defaultMojoExecutionAction=execute',
    '-Dlog.protocol=true',
    '-Dlog.level=ALL',
    '-javaagent:' .. path_to_lombok,
    '-Xmx1g',
    '--add-modules=ALL-SYSTEM',
    '--add-opens',
    'java.base/java.util=ALL-UNNAMED',
    '--add-opens',
    'java.base/java.lang=ALL-UNNAMED',

    '-jar',
    path_to_jar,
    '-configuration',
    config_dir,
    '-data',
    workspace_dir,
  },

  root_dir = root_dir,
  -- Here you can configure eclipse.jdt.ls specific settings
  -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
  -- for a list of options
  settings = {
    java = {
      eclipse = {
        downloadSources = true,
      },
      configuration = {
        updateBuildConfiguration = 'interactive',
      },
      maven = {
        downloadSources = true,
      },
      implementationsCodeLens = {
        enabled = true,
      },
      referencesCodeLens = {
        enabled = true,
      },
      references = {
        includeDecompiledSources = true,
      },
      format = {
        enabled = true,
        settings = {
          url = vim.fn.stdpath 'config' .. '/lang-servers/intellij-java-google-style.xml',
          profile = 'GoogleStyle',
        },
      },
    }, -- end java

    signatureHelp = { enabled = true },

    completion = {
      favoriteStaticMembers = {
        'org.hamcrest.MatcherAssert.assertThat',
        'org.hamcrest.Matchers.*',
        'org.hamcrest.CoreMatchers.*',
        'org.junit.jupiter.api.Assertions.*',
        'java.util.Objects.requireNonNull',
        'java.util.Objects.requireNonNullElse',
        'org.mockito.Mockito.*',
      },
      importOrder = {
        'java',
        'javax',
        'com',
        'org',
      },
    },

    contentProvider = { preferred = 'fernflower' },
    extendedClientCapabilities = extendedClientCapabilities,

    sources = {
      organizeImports = {
        starThreshold = 9999,
        staticStarThreshold = 9999,
      },
    },

    codeGeneration = {
      toString = {
        template = '${object.className}{${member.name()}=${member.value}, ${otherMembers}}',
      },
      useBlocks = true,
    },
  },

  flags = {
    allow_incremental_sync = true,
  },

  -- Language server `initializationOptions`
  -- You need to extend the `bundles` with paths to jar files
  -- if you want to use additional eclipse.jdt.ls plugins.
  --
  -- See https://github.com/mfussenegger/nvim-jdtls#java-debug-installation
  --
  -- If you don't plan on using the debugger or other eclipse.jdt.ls plugins you can remove this
  init_options = {
    bundles = bundles,
  },
  on_attach = on_attach,
}

require('jdtls').start_or_attach(config)

-- Add the commands
require('jdtls.setup').add_commands()
