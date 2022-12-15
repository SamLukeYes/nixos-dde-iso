# NixOS live image with DDE

**Warning: This repo is still a work in progress. The applications and features in the live images may be subject to change.**

### Build

- generic build
    
    ```command
    $ nix build 'github:SamLukeYes/nixos-dde-iso#generic'
    ```

- with localization and other tweaks for Mainland China

    ```command
    $ nix build 'github:SamLukeYes/nixos-dde-iso#cn'
    ```

Optionally, if you don't want to compile [dde-nixos](https://github.com/linuxdeepin/dde-nixos) packages from source when building the live image, you can use the binary cache provided by [garnix](https://garnix.io/docs/caching).