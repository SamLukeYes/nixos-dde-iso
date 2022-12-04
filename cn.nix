{ lib, pkgs, ... }:

{
  fonts.fonts = with pkgs; [
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
  ];

  i18n = {
    defaultLocale = "zh_CN.UTF-8";
    inputMethod = {
      enabled = "fcitx5";
      fcitx5.addons = with pkgs; [
        fcitx5-chinese-addons
      ];
    };
  };

  isoImage.isoBaseName = lib.mkForce "nixos-dde-cn";

  nix.settings.substituters = [
    "https://mirrors.bfsu.edu.cn/nix-channels/store"
    "https://mirror.sjtu.edu.cn/nix-channels/store"
  ];
}