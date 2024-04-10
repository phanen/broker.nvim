local M = {}

local colors_name_path = vim.fn.stdpath('cache') .. '/color_name'

M.init = function()
  if not vim.uv.fs_stat(colors_name_path) then io.open(colors_name_path, 'w') end
  local fd = assert(io.open(colors_name_path, 'r'))
  vim.g.colors_name = fd:read() or 'vim'
  fd:close()
  M.colors_name_path = colors_name_path
end

return M
