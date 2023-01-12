{ lib, pkgs, ... }:

{
  fonts.fontconfig.defaultFonts = {
    sansSerif = [
      "Noto Sans"
      "Noto Sans CJK SC"
    ];
    serif = [
      "Noto Serif"
      "Noto Serif CJK SC"
    ];
    monospace = [
      "Noto Sans Mono"
      "Noto Sans Mono CJK SC"
    ];
  };

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

  time.timeZone = "Asia/Shanghai";
}