# lazydocs.nvim 

Neovim plugin that generates doxygen comments based on treesitter info. (Currently, only C++ is supported)
When you put your cursor on a C++ function declaration or definition, you

## Dependencies

- [none-ls.nvim](https://github.com/nvimtools/none-ls.nvim)
- [LuaSnip](https://github.com/L3MON4D3/LuaSnip)
- [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter)

## Installation

### Using lazy.nvim

```lua
{
  "jla2000/lazydocs.nvim",
  event = "VeryLazy",
  dependencies = {
    "L3MON4D3/LuaSnip",
    "nvimtools/none-ls.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  opts = {},
}
```

### Manually

```lua
require("lazydocs").setup()
```

## Demo

![Demo](https://github.com/jla2000/lazydocs.nvim?branch=gif/demo.gif)
