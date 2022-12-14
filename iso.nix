{ pkgs, ... }:

{
  boot.supportedFilesystems = [ "bcachefs" ];

  # Fix calamares crash on startup
  environment.pathsToLink = [ "/share/calamares" ];

  fonts.fonts = with pkgs; [
    inconsolata-nerdfont
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
  ];

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

  services.xserver = {
    enable = true;
    displayManager = {
      lightdm.enable = true;
      autoLogin = {
        enable = true;
        user = "nixos";
      };
    };
    desktopManager.deepin = {
      enable = true;
    };
  };

  programs.fish.enable = true;
  users.defaultUserShell = pkgs.fish;
}