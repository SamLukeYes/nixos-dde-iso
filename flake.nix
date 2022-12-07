{
  description = "NixOS live image with DDE";

  inputs = {
    dde-nixos = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:SamLukeYes/dde-nixos/no-dde-introduction";
    };
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";
  };

  outputs = { self, dde-nixos, nixpkgs }: let
    system = "x86_64-linux";
    commonModules = [
      dde-nixos.nixosModules.${system}
      "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-graphical-base.nix"
      ./iso.nix
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
  };
}
