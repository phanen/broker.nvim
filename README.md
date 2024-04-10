# broker.nvim
[![CI](https://github.com/phanen/broker.nvim/actions/workflows/ci.yml/badge.svg?branch=master)](https://github.com/phanen/broker.nvim/actions/workflows/ci.yml)

Broadcast config for running nvim instances via rpc socket.

[mp4: showcase](https://github.com/phanen/broker.nvim/assets/91544758/10bfd5f4-0511-4590-b0cb-77719ce99930)

## install
Use `lazy.nvim`:
```lua
{
  'phanen/broker.nvim',
  event = 'ColorScheme',
  init = function() require('broker.entry').init() end,
},
```

## TODO
* [x] Persistant/Broadcast colorscheme.
* [ ] Provide a command to broadcast any command (seems useless)
* [ ] Get all session files
