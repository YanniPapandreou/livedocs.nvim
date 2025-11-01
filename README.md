# livedocs.nvim

A Neovim plugin that displays live LSP hover documentation in a persistent split window as you move your cursor. No more manually triggering `K` - documentation updates automatically as you navigate your code.

## Features

- **Live Updates**: Documentation automatically updates as you move your cursor (with a configurable debounce)
- **Flexible Positioning**: Open the documentation window in any direction (above, below, left, right)
- **LSP Integration**: Uses Neovim's built-in LSP to fetch hover information
- **Markdown Rendering**: Documentation is displayed with markdown syntax highlighting
- **Customizable**: Configure window position, size, and buffer options

## Requirements

- Neovim >= 0.8.0
- An active LSP server attached to your buffer

## Installation/Setup

### [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
    "YanniPapandreou/livedocs.nvim",
    opts = {
        -- Your configuration here (or leave empty to use defaults)
    }
    keys = {
        {
            -- customize to your preferred keybinding
            "<localleader>d",
            function()
                require("livedocs").toggle()
            end,
            desc = "Toggle livedocs",
        }
    },
}
```

#### Version Pinning

You can pin to a specific version to ensure stability:

```lua
-- Pin to a specific version
{
    "YanniPapandreou/livedocs.nvim",
    version = "0.1.0",
    opts = { }
}

-- Use any 0.x version (auto-updates to 0.2.0, 0.3.0, etc.)
{
    "YanniPapandreou/livedocs.nvim",
    version = "^0.1",
    opts = { }
}

-- Always use the latest version (default behavior)
{
    "YanniPapandreou/livedocs.nvim",
    opts = { }
}
```


## Usage

### Commands

- `:ToggleDocs` - Toggle the documentation window (uses default position from configuration)
- `:ToggleDocs left` - Toggle the documentation window on the left side
- `:ToggleDocs right` - Toggle the documentation window on the right side
- `:ToggleDocs above` - Toggle the documentation window above the current window
- `:ToggleDocs below` - Toggle the documentation window below the current window

## Configuration

Here are the default settings:

```lua
require("livedocs").setup({
  ui = {
    -- Default position: "left", "right", "above", or "below"
    position = "below",
    -- Size of the window (nil for automatic sizing)
    -- For horizontal splits (above/below): number of lines
    -- For vertical splits (left/right): number of columns
    size = nil,  -- defaults to 15 for horizontal, 60 for vertical
  },
  win = {
    -- Window-specific options
    number = false,
    relativenumber = false,
  },
  buf = {
    -- Buffer-specific options
    modifiable = true,
    buftype = "nofile",
    filetype = "markdown",
  },
})
```

## How It Works

1. When you toggle the documentation window, livedocs.nvim creates a split window
2. As you move your cursor, the plugin waits 200ms (debounce) for the cursor to settle
3. Once settled, it requests hover information from the LSP server
4. The documentation is displayed in the split window with markdown highlighting
5. The window stays open until you toggle it again

## Health Check

Run `:checkhealth livedocs` to verify your setup (see `lua/livedocs/health.lua:1`).

## Troubleshooting

### No documentation appears

- Ensure you have an LSP server attached to your buffer (`:LspInfo`)
- Check that your LSP server supports hover (most do)
- Verify the cursor is positioned over a symbol that has documentation

### Documentation window doesn't open

- Check for errors with `:messages`
- Ensure the plugin is properly installed and loaded
- Run `:checkhealth livedocs` to diagnose issues

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.
