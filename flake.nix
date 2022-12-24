{
  description = "NixOS live image with DDE";

  inputs = {
    dde-nixos = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:linuxdeepin/dde-nixos";
    };
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";
    yes = {
      flake = false;
      url = "github:SamLukeYes/nix-custom-packages";
    };
  };

  outputs = { self, dde-nixos, nixpkgs, yes }: let
    system = "x86_64-linux";
    pkgs = import nixpkgs { inherit system; };
    commonModules = [
      dde-nixos.nixosModules.${system}
      "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-graphical-calamares.nix"
      ./iso.nix
      (with dde-nixos.packages.${system}; {
        environment = {
          deepin.excludePackages = [
            dde-calendar
            deepin-album
            deepin-calculator
          ];
        };
      })
    ];
  in {
    nixosConfigurations = {
      generic = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = commonModules;
      };
      cn = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = commonModules ++ [
          ./cn.nix
        ];
      };
    };
    legacyPackages.${system} = {
      generic = self.nixosConfigurations.generic.config.system.build.isoImage;
      cn = self.nixosConfigurations.cn.config.system.build.isoImage;
    };
    devShell.${system} = with pkgs; with (import yes { inherit pkgs; }); mkShell {
      buildInputs = [ archlinux.run-archiso ];
      shellHook = "exec $SHELL";
    };
  };
}
