local M = {}

function M.setup()
  -- import comment plugin safely
  local setup, comment = pcall(require, 'Comment')
  if not setup then
    return
  end

  -- enable comment
  comment.setup {
    ignore = '^$', -- ignore empty lines during commentin
  }
end

return M
