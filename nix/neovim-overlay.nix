# This overlay, when applied to nixpkgs, adds the final neovim derivation to nixpkgs.
{ inputs }:
final: prev:
with final.pkgs.lib;
let
  pkgs = final;

  # Use this to create a plugin from a flake input
  mkNvimPlugin =
    src: pname:
    pkgs.vimUtils.buildVimPlugin {
      inherit pname src;
      version = src.lastModifiedDate;
    };

  # Make sure we use the pinned nixpkgs instance for wrapNeovimUnstable,
  # otherwise it could have an incompatible signature when applying this overlay.
  pkgs-wrapNeovim = inputs.nixpkgs.legacyPackages.${pkgs.system};

  # This is the helper function that builds the Neovim derivation.
  mkNeovim = pkgs.callPackage ./mkNeovim.nix { inherit pkgs-wrapNeovim; };

  # A plugin can either be a package or an attrset, such as
  # { plugin = <plugin>; # the package, e.g. pkgs.vimPlugins.nvim-cmp
  #   config = <config>; # String; a config that will be loaded with the plugin
  #   # Boolean; Whether to automatically load the plugin as a 'start' plugin,
  #   # or as an 'opt' plugin, that can be loaded with `:packadd!`
  #   optional = <true|false>; # Default: false
  #   ...
  # }
  all-plugins = with pkgs.vimPlugins; [
    # plugins from nixpkgs go in here.
    # https://search.nixos.org/packages?channel=unstable&from=0&size=50&sort=relevance&type=packages&query=vimPlugins
    nvim-treesitter.withAllGrammars

    # completion with blink.cmp
    inputs.blink.packages.${pkgs.system}.default
    luasnip # snippets | https://github.com/l3mon4d3/luasnip/
    friendly-snippets

    # telescope and extensions
    telescope-nvim # https://github.com/nvim-telescope/telescope.nvim/
    telescope-fzy-native-nvim # https://github.com/nvim-telescope/telescope-fzy-native.nvim
    smart-open-nvim
    sqlite-lua # For smart-open-nvim

    # libraries that other plugins depend on
    plenary-nvim
    nvim-nio # for neotest
    FixCursorHold-nvim # for neotest
    nui-nvim # for avante
    # ^ libraries that other plugins depend on
    which-key-nvim

    # Theme
    catppuccin-nvim

    # Snacks
    snacks-nvim

    # Fancy UI
    noice-nvim
    dressing-nvim

    # Autoformat
    conform-nvim

    # bleeding-edge plugins from flake inputs
    # (mkNvimPlugin inputs.snacks "snacks.nvim")
    # ^ bleeding-edge plugins from flake inputs

    # Mini
    mini-nvim

    # Stay centered
    stay-centered-nvim

    # Neotest
    neotest
    neotest-dart

    # Autosave
    auto-save-nvim

    # Avante (copilot)
    avante-nvim
    copilot-lua
    img-clip-nvim
    render-markdown-nvim

    # Flutter
    flutter-tools-nvim

    # Autopairs
    ultimate-autopair-nvim

    # Dart
    dart-vim-plugin

    # Lualine
    lualine-nvim

    # Inline colors support
    nvim-highlight-colors

    # Search and replace
    grug-far-nvim

    # Git
    gitsigns-nvim

    snacks-nvim
  ];

  extraPackages = with pkgs; [
    # language servers, etc.
    lua-language-server
    nil # nix LSP
    ripgrep # for telescope live_grep
    stylua # lua formatting
    nixfmt-rfc-style # nix formatting
    fd # for telescope
    ast-grep # for grug-far
  ];
in
{
  # This is the neovim derivation
  # returned by the overlay
  nvim-pkg = mkNeovim {
    plugins = all-plugins;
    inherit extraPackages;
  };

  # This can be symlinked in the devShell's shellHook
  nvim-luarc-json = final.mk-luarc-json { plugins = all-plugins; };

  # You can add as many derivations as you like.
  # Use `ignoreConfigRegexes` to filter out config
  # files you would not like to include.
  #
  # For example:
  #
  # nvim-pkg-no-telescope = mkNeovim {
  #   plugins = [];
  #   ignoreConfigRegexes = [
  #     "^plugin/telescope.lua"
  #     "^ftplugin/.*.lua"
  #   ];
  #   inherit extraPackages;
  # };
}
