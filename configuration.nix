{ ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./modules/core.nix
    ./modules/hyprland.nix
    ./modules/steam.nix
    ./modules/dev-go.nix
  ];
}
