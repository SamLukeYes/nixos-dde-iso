{ pkgs, ... }:

{
  isoImage = {
    isoBaseName = "nixos-dde";
    squashfsCompression = "zstd";
  };

  nix.settings = {
    auto-optimise-store = true;
    experimental-features = [
      "flakes" "nix-command"
    ];
    fallback = true;
  };

  # Use alternative browser
  nixpkgs.overlays = [(
    final: prev: {
      firefox = final.epiphany;
    }
  )];

  services = {
    tzupdate.enable = true;
    xserver = {
      enable = true;
      displayManager = {
        lightdm.enable = true;
      };
      desktopManager.deepin = {
        enable = true;
      };
    };
  };

  programs.fish.enable = true;
  users.defaultUserShell = pkgs.fish;
}