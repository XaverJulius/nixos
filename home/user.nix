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

  xdg.configFile."hypr/hyprland.conf".text = ''
    monitor=,preferred,auto,1

    exec-once = waybar
    exec-once = dunst

    input {
      kb_layout = de
    }

    bind = SUPER, RETURN, exec, kitty
    bind = SUPER, D, exec, rofi -show drun
    bind = SUPER, Q, killactive
    bind = SUPER, M, exit
  '';
}
