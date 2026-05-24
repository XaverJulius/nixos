{ pkgs, inputs, ... }:

{
  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
  };

  services.greetd = {
    enable = true;
    settings.default_session = {
      command =
        "${pkgs.tuigreet}/bin/tuigreet --cmd Hyprland";
      user = "greeter";
    };
  };

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk pkgs.xdg-desktop-portal-hyprland ];
    configPackages = [ pkgs.hyprland ];
  };

  programs.foot.enable = true;

  environment.systemPackages = with pkgs; [
    kitty
    waybar
    rofi
    dunst

    wl-clipboard
    grim
    slurp

    hypridle
    hyprlock
    hyprsunset
    xdg-desktop-portal-hyprland
  ];
}
