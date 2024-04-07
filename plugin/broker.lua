local group = vim.api.nvim_create_augroup('Broker', { clear = true })
local au = function(ev, opts)
  opts = opts or {}
  opts.group = opts.group or group
  vim.api.nvim_create_autocmd(ev, opts)
end

au({ 'VimEnter', 'FocusGained' }, {
  callback = function()
    vim.g.focuesd = true
  end,
})

au('FocusLost', {
  callback = function()
    vim.g.focuesd = false
  end,
})

au('ColorScheme', {
  callback = function()
    if not vim.g.focuesd then
      return
    end

    local u = require('broker.util')
    local color_cache = vim.g.color_cache or vim.fs.joinpath(u.stdpath['cache'], 'color_name')
    u.write_str(color_cache, vim.g.colors_name)

    u.ls('/run/user/1000/', function(path, name, type)
      if path ~= vim.v.servername and name:match('nvim') and type == 'socket' then
        vim.system {
          'nvim',
          '-u',
          'NONE',
          '--server',
          path,
          '--remote-send',
          ('<cmd>colorscheme %s<cr>'):format(vim.g.colors_name),
        }
      end
    end)
  end,
})
