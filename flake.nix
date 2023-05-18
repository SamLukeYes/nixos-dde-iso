{
  description = "NixOS live image with DDE";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    calamares-deepin = {
      flake = false;
      url = "github:wineee/calamares-nixos-extensions/deepin";
    };
  };

  outputs = { self,  nixpkgs, ... }: let
    system = "x86_64-linux";
    commonModules = [
      "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-graphical-calamares.nix"
      ./iso.nix
    ];
  in {
    overlays.default = final: prev: {
      calamares-nixos-extensions = prev.calamares-nixos-extensions.overrideAttrs (old: {
        src = self.inputs.calamares-deepin;
      });
      firefox = final.epiphany;
    };
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
  };
}
