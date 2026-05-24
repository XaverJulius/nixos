{ config, pkgs, userSettings, ... }:

{
  home.username = userSettings.username;
  home.homeDirectory = "/home/${userSettings.username}";

  home.stateVersion = "24.11";

  programs.home-manager.enable = true;

  programs.bash.enable = true;

  programs.git = {
    enable = true;
    settings = {
      user.name = userSettings.name;
      user.email = userSettings.email;
    };
    signing.format = null;
  };

  xdg.configFile."hypr/hyprland.lua".source = ./hypr/hyprland.lua;
  xdg.configFile."hypr/hypridle.conf".source = ./hypr/hypridle.conf;
  xdg.configFile."hypr/hyprlock.conf".source = ./hypr/hyprlock.conf;
  xdg.configFile."hypr/hyprsunset.conf".source = ./hypr/hyprsunset.conf;
  xdg.configFile."hypr/xdph.conf".source = ./hypr/xdph.conf;
}
