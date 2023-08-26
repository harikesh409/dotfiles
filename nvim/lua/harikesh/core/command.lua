-- Automatically close tab/vim when nvim-tree is the last window in the tab
vim.cmd "autocmd BufEnter * ++nested if winnr('$') == 1 && bufname() == 'NvimTree_' . tabpagenr() | quit | endif"

vim.api.nvim_create_autocmd({ 'TextYankPost' }, {
  callback = function()
    vim.highlight.on_yank { higroup = 'Visual', timeout = 200 }
  end,
})
