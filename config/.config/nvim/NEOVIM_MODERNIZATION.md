# Neovim Configuration - Native LSP (0.11+)

This configuration uses Neovim 0.11's native LSP API (`vim.lsp.config()` and `vim.lsp.enable()`).

## Structure

```
~/.config/nvim/
├── init.lua                 # Entry point
├── lsp/                     # Native LSP server configs (Neovim 0.11+)
│   ├── ty.lua              # Python type checker (primary)
│   ├── ruff.lua            # Python linting/formatting
│   ├── gopls.lua           # Go
│   ├── lua_ls.lua          # Lua
│   ├── clangd.lua          # C/C++
│   ├── bashls.lua          # Bash
│   ├── jsonls.lua          # JSON
│   ├── yamlls.lua          # YAML
│   ├── terraformls.lua     # Terraform
│   └── tflint.lua          # Terraform linting
├── lua/core/
│   ├── lsp/
│   │   ├── init.lua        # LSP keymaps & vim.lsp.enable()
│   │   └── mason.lua       # Mason tool installer
│   ├── cmp.lua             # Completion
│   ├── keymaps.lua         # General keymaps
│   ├── lazy.lua            # Plugin management
│   └── vim_options.lua     # Vim options
└── after/plugin/           # Plugin-specific configs
```

## Python LSP Stack

- **ty**: Primary type checker (Astral's fast type checker)
- **ruff**: Linting and formatting

## Adding New LSP Servers

1. Create `lsp/<server>.lua`:

```lua
return {
  cmd = { "server-command" },
  filetypes = { "filetype" },
  root_markers = { ".git" },
  settings = {},
}
```

2. Add to `lua/core/lsp/init.lua` servers list:

```lua
{ name = "server", cmd = "server-command" },
```

3. Add to `lua/core/lsp/mason.lua` tools list:

```lua
"server-package-name",
```

## LSP Keymaps

- `<leader>rn` - Rename symbol
- `<leader>ca` - Code action
- `gd` - Go to definition
- `gr` - Go to references
- `gI` - Go to implementation
- `<leader>D` - Type definition
- `K` - Hover documentation
- `<C-k>` - Signature help
- `<leader>f` - Format file

## Commands

- `:LspInfo` - Show active LSP clients
- `:LspRestart` - Restart LSP clients
- `:LspPython` - Show Python LSP clients
- `:Mason` - Manage LSP servers

## Doom Emacs-Style Keybindings

### Project (`<leader>p`)
- `<leader>pp` - Find project files
- `<leader>pf` - Find file
- `<leader>ps` - Search project

### Files (`<leader>f`)
- `<leader>ff` - Find file
- `<leader>fr` - Recent files
- `<leader>fg` - Find by grep

### Buffers (`<leader>b`)
- `<leader>bb` - Buffer list
- `<leader>bd` - Delete buffer

### Windows (`<leader>w`)
- `<leader>wv` - Split vertical
- `<leader>ws` - Split horizontal
- `<leader>wd` - Close window

### Git (`<leader>g`)
- `<leader>gg` - Git status
- `<leader>gb` - Git blame
- `<leader>gl` - Git log

### Other
- `<leader>op` - Toggle file explorer
- `<leader>qq` - Quit all
