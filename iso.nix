{ pkgs, ... }:

{
  # Fix calamares crash on startup
  environment.pathsToLink = [ "/share/calamares" ];

  fonts.fonts = with pkgs; [
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    ubuntu_font_family    # for onboard
  ];

  isoImage = {
    isoBaseName = "nixos-dde";
    # squashfsCompression = "zstd";
  };

  nix.settings = {
    auto-optimise-store = true;
    experimental-features = [
      "flakes" "nix-command"
    ];
    fallback = true;
  };

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