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
    local fd = assert(io.open(vim.g.color_cache, 'w+'))
    fd:write(vim.g.colors_name)
    fd:close()
    require('broker.util').ls('/run/user/1000/', function(path, name, type)
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
