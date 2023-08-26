local M = {}

function M.setup()
  local setup, neogit = pcall(require,'neogit')
  if not setup then
    return
  end
  neogit.setup {}
end

return M
