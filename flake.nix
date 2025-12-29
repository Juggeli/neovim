{
  description = "A Nix-flake-based Neovim configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixCats.url = "github:BirdeeHub/nixCats-nvim";
  };

  outputs = { self, nixpkgs, nixCats }:
    let
      inherit (nixCats) utils;
      luaPath = "${./nvim}";
      forEachSystem = utils.eachSystem nixpkgs.lib.platforms.all;
      extra_pkg_config = {
        # allowUnfree = true;
      };
      dependencyOverlays = [ ];

      categoryDefinitions = { pkgs, settings, categories, name, ... }: {
        lspsAndRuntimeDeps = {
          general = with pkgs; [
            # Language servers  
            lua-language-server
            nil
            # Tools
            ripgrep
            stylua
            nixfmt-rfc-style
            fd
            ast-grep
            sqlite
          ];
        };

        startupPlugins = {
          general = with pkgs.vimPlugins; [
            # Core libraries
            plenary-nvim
            nvim-nio
            FixCursorHold-nvim
            nui-nvim
            
            # Treesitter
            nvim-treesitter.withAllGrammars
            
            # Completion
            blink-cmp
            luasnip
            friendly-snippets
            
            # Telescope
            telescope-nvim
            telescope-fzy-native-nvim
            smart-open-nvim
            sqlite-lua
            
            # UI
            catppuccin-nvim
            noice-nvim
            dressing-nvim
            lualine-nvim
            snacks-nvim
            which-key-nvim
            
            # Formatting
            conform-nvim
            
            # Mini
            mini-nvim
            
            # Other utilities
            stay-centered-nvim
            neotest
            neotest-dart
            auto-save-nvim
            flutter-tools-nvim
            dart-vim-plugin
            ultimate-autopair-nvim
            nvim-highlight-colors
            grug-far-nvim
            gitsigns-nvim
          ];
        };

        optionalPlugins = {
          general = with pkgs.vimPlugins; [
            # Empty for now
          ];
        };

        environmentVariables = {
          general = {
            LIBSQLITE = "${pkgs.sqlite.out}/lib/libsqlite3${if pkgs.stdenv.isLinux then ".so" else ".dylib"}";
            LIBSQLITE_CLIB_PATH = "${pkgs.sqlite.out}/lib/libsqlite3${if pkgs.stdenv.isLinux then ".so" else ".dylib"}";
          };
        };

        sharedLibraries = {
          general = with pkgs; [
            sqlite
          ];
        };
      };

      packageDefinitions = {
        nvim = { pkgs, ... }: {
          settings = {
            wrapRc = true;
            aliases = [ "vim" "vi" ];
          };
          categories = {
            general = true;
          };
        };
      };

      defaultPackageName = "nvim";
    in
    forEachSystem (system:
      let
        nixCatsBuilder = utils.baseBuilder luaPath {
          inherit nixpkgs system dependencyOverlays extra_pkg_config;
        } categoryDefinitions packageDefinitions;
        
        defaultPackage = nixCatsBuilder defaultPackageName;
        
        pkgs = import nixpkgs { inherit system; config = extra_pkg_config; };
      in
      {
        packages = utils.mkAllWithDefault defaultPackage;

        devShells = {
          default = pkgs.mkShell {
            name = "nvim-devShell";
            buildInputs = with pkgs; [
              lua-language-server
              nil
              stylua
              luajitPackages.luacheck
            ];
            shellHook = ''
              echo "Neovim development environment"
            '';
          };
        };
      }
    )
    //
    {
      nixosModules.default = utils.mkNixosModules {
        inherit categoryDefinitions packageDefinitions dependencyOverlays defaultPackageName luaPath extra_pkg_config;
      };
      homeModules.default = utils.mkHomeModules {
        inherit categoryDefinitions packageDefinitions dependencyOverlays defaultPackageName luaPath extra_pkg_config;
      };
    };
}