{
  description = "NixOS live image with DDE";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";
    dde-nixos = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:linuxdeepin/dde-nixos";
    };
    sigprof = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:sigprof/nur-packages";
    };
  };

  outputs = { self, dde-nixos, sigprof, nixpkgs }: let
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
          {
            nixpkgs.overlays = [(
              final: prev: {
                firefox = prev.firefox.override {
                  nixExtensions = [ sigprof.packages.${system}.firefox-langpack-zh-CN ];
                };
              }
            )];
          }
        ];
      };
    };
    legacyPackages.${system} = {
      generic = self.nixosConfigurations.generic.config.system.build.isoImage;
      cn = self.nixosConfigurations.cn.config.system.build.isoImage;
    };
  };
}
