local util = {}

util.stdpath = setmetatable({}, {
  __index = function(t, k)
    local path = vim.fn.stdpath(k)
    if type(path) == 'table' then
      path = path[1]
    end
    assert(path)
    vim.fn.mkdir(path, 'p')
    t[k] = path
    return path
  end,
})

util.ls = function(path, fn)
  local handle = vim.uv.fs_scandir(path)
  while handle do
    local name, t = vim.uv.fs_scandir_next(handle)
    if not name then
      break
    end
    local fname = vim.fs.joinpath(path, name)
    if fn(fname, name, t or vim.uv.fs_stat(fname).type) == false then
      break
    end
  end
end

return util
