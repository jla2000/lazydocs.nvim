# lazydocs.nvim

Neovim plugin that generates doxygen formats. (Currently, only C++ is supported)

## Dependencies

- [none-ls.nvim](https://github.com/nvimtools/none-ls.nvim)
- [LuaSnip](https://github.com/L3MON4D3/LuaSnip)

## Installation

### Using lazy.nvim

```lua
{
  "jla2000/lazydocs.nvim",
  event = "VeryLazy",
  dependencies = {
    "L3MON4D3/LuaSnip",
    "nvimtools/none-ls.nvim",
  },
  opts = {},
}
```

### Manually

```lua
require("lazydocs").setup()
```

## Demo

TODO
