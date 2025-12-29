# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

A nixCats-based Neovim configuration combining Nix for reproducible plugin/tool management with portable Lua configuration files.

## Commands

```bash
nix run                    # Test drive the configuration
nix build                  # Build the package
./result/bin/nvim          # Run built neovim
nix flake update           # Update dependencies
nix develop                # Enter dev shell (lua-language-server, nil, stylua, luacheck)
```

## Architecture

```
flake.nix              # Plugin/LSP/tool definitions (ALL dependencies configured here)
nvim/
├── init.lua           # Core vim options (leader=space, tabs=2 spaces, etc.)
├── plugin/            # Plugin configs (auto-loaded, use load-guard pattern)
├── ftplugin/          # Language-specific LSP setup (lua, nix, dart)
└── lua/user/          # Shared modules (lsp.lua for capabilities)
```

**Configuration flow:** `flake.nix` (dependencies) → `init.lua` (vim options) → `plugin/*.lua` (plugin setup) → `ftplugin/*.lua` (per-language LSP)

## Key Patterns

**Plugin load-guard** - Every plugin file must start with:
```lua
if vim.g.did_load_[name]_plugin then
  return
end
vim.g.did_load_[name]_plugin = true
```

**LSP capabilities** - All LSP configs must use shared capabilities:
```lua
local capabilities = require('user.lsp').make_client_capabilities()
```

**Keymaps** - Always include description for which-key:
```lua
vim.keymap.set(mode, key, action, { desc = 'Description' })
```

## Adding Components

**Plugin:** Add to `categoryDefinitions.startupPlugins.general` in flake.nix, create `nvim/plugin/[name].lua`

**LSP:** Add package to `lspsAndRuntimeDeps.general` in flake.nix, create `nvim/ftplugin/[filetype].lua`

## Code Style

- Lua: 2-space indent, single quotes preferred (stylua configured)
- Nix: Format with nixfmt-rfc-style
- Run `stylua nvim/` before committing Lua changes
