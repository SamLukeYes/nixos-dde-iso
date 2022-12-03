{
  description = "NixOS live image with DDE";

  inputs = {
    dde-nixos = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:linuxdeepin/dde-nixos";
    };
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";
  };

  outputs = { self, dde-nixos, nixpkgs }: let
    system = "x86_64-linux";
    commonModules = [
      dde-nixos.nixosModules.${system}
      "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-graphical-calamares.nix"
      ./iso.nix
    ];
  in {
    nixosConfigurations = {
      cn = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = commonModules ++ [
          ./cn.nix
        ];
      };
      generic = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = commonModules;
      };
    };
    packages.${system} = {
      default = self.nixosConfigurations.live.config.system.build.isoImage;
      cn = self.nixosConfigurations.cn.config.system.build.isoImage;
    };
  };
}
