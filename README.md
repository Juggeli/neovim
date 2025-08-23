# Neovim Configuration

A Neovim configuration using [nixCats](https://github.com/BirdeeHub/nixCats-nvim).

## Usage

```console
# Test drive
nix run

# Update
nix flake update
```

## Structure

- `flake.nix` - nixCats configuration with plugin categories
- `nvim/` - Lua configuration files (portable)

## Features

- 34+ plugins from nixpkgs unstable
- blink-cmp completion
- Telescope, AI tools, Flutter/Dart support
- Development shell with LSPs and formatters
- Home Manager & NixOS modules included

## Adding Plugins

Edit `categoryDefinitions.startupPlugins.general` in `flake.nix` and add config files to `nvim/plugin/`.