local util = {}

util.write_str = function(filename, str)
  local fd = assert(io.open(filename, 'w+'))
  fd:write(str)
  fd:close()
end

util.ls = function(path, fn)
  local handle = vim.uv.fs_scandir(path)
  while handle do
    local name, t = vim.uv.fs_scandir_next(handle)
    if not name then break end
    local fname = vim.fs.joinpath(path, name)
    if fn(fname, name, t or vim.uv.fs_stat(fname).type) == false then break end
  end
end

return util
