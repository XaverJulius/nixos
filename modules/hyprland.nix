{ pkgs, inputs, ... }:

{
  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
  };

  services.greetd = {
    enable = true;
    settings.default_session = {
      command =
        "${pkgs.greetd.tuigreet}/bin/tuigreet --cmd Hyprland";
      user = "greeter";
    };
  };

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
  };

  environment.systemPackages = with pkgs; [
    kitty
    waybar
    rofi-wayland
    dunst

    wl-clipboard
    grim
    slurp
  ];
}
