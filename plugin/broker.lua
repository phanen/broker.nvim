local group = vim.api.nvim_create_augroup('Broker', { clear = true })

local au = function(ev, opts)
  opts.group = group
  vim.api.nvim_create_autocmd(ev, opts)
end

au({ 'VimEnter', 'FocusGained' }, { command = [[let g:is_broker = v:true]] })

au('FocusLost', { command = [[let g:is_broker = v:false]] })

au('ColorScheme', { command = [[lua require('broker').set_color()]] })
