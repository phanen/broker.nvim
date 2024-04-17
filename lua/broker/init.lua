local M = {}

M.set_color = function(args)
  -- workaround to avoid a nested nvim broker
  -- TODO: figure out a way to tell apart nested/non-nested case
  -- we need to select out one broker only
  if not vim.g.is_broker or vim.env.NVIM then return end

  -- entry will be loaded first, so why not just cache opts there
  local colors_name_path = package.loaded['broker.entry'].colors_name_path
  local u = require('broker.util')

  local colors_name = args.match
  u.write_str(colors_name_path, colors_name)

  local tasks = {}

  local rpc_cmd = ('<cmd>colorscheme %s<cr>'):format(colors_name)

  -- refer to `server_address_new`
  -- the default servername is $XDG_RUNTIME_DIR/<name>.<pid>.<counter>
  local address_dir = vim.fn.stdpath('run')
  u.ls(address_dir, function(path, name, type)
    if path ~= vim.v.servername and name:match('nvim') and type == 'socket' then
      tasks[#tasks + 1] =
        vim.system { 'nvim', '-u', 'NONE', '--server', path, '--remote-send', rpc_cmd }
    end
  end)
  vim.iter(tasks):each(function(task) task:wait() end)
end

return M
