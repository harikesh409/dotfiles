-- import mason plugin safely
local mason_status, mason = pcall(require, 'mason')
if not mason_status then
  return
end

-- import mason-lspconfig plugin safely
local mason_lspconfig_status, mason_lspconfig = pcall(require, 'mason-lspconfig')
if not mason_lspconfig_status then
  return
end

-- import mason-null-ls plugin safely
-- local mason_null_ls_status, mason_null_ls = pcall(require, 'mason-null-ls')
-- if not mason_null_ls_status then
--   return
-- end

local mason_tool_installer_status, mason_tool_installer = pcall(require, 'mason-tool-installer')
if not mason_tool_installer_status then
  return
end

-- enable mason
mason.setup({
    ui = {
        icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗"
        }
    }
})

mason_lspconfig.setup {
  -- list of servers for mason to install
  ensure_installed = {
    'ts_ls',
    'html',
    'cssls',
    'lua_ls',
    'emmet_ls',
    'spectral',
    'yamlls',
    'jdtls',
  },
  -- auto-install configured servers (with lspconfig)
  automatic_installation = true, -- not the same as ensure_installed
}

mason_tool_installer.setup {
  ensure_installed = {
        'lua-language-server',
        'prettier', -- prettier formatter
        'stylua', -- lua formatter
        'eslint_d',
        'luacheck',
        'misspell',
        'checkstyle',
        'google-java-format'
      },
}

-- mason_null_ls.setup {
--   -- list of formatters & linters for mason to install
--   ensure_installed = {
--     'prettier', -- ts/js formatter
--     'stylua', -- lua formatter
--     'eslint_d', -- ts/js linter
--     'spell',
--     'checkstyle',
--     'pmd',
--     'google_java_format',
--   },
--   -- auto-install configured formatters & linters (with null-ls)
--   automatic_installation = true,
-- }
