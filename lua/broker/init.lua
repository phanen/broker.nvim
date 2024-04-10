local M = {}

M.set_color = function()
  if not vim.g.is_broker then return end

  -- entry will be loaded first, so why not just cache opts there
  local colors_name_path = package.loaded['broker.entry'].colors_name_path
  local u = require('broker.util')

  local colors_name = vim.g.colors_name
  u.write_str(colors_name_path, vim.g.colors_name)

  local tasks = {}

  local rpc_cmd = ('<cmd>colorscheme %s<cr>'):format(colors_name)

  u.ls('/run/user/1000/', function(path, name, type)
    if path ~= vim.v.servername and name:match('nvim') and type == 'socket' then
      tasks[#tasks + 1] =
        vim.system { 'nvim', '-u', 'NONE', '--server', path, '--remote-send', rpc_cmd }
    end
  end)
  vim.iter(tasks):each(function(task) task:wait() end)
end

return M
