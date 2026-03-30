{ config, pkgs, ... }:

{
  home.username = "yourusername";
  home.homeDirectory = "/home/yourusername";

  home.stateVersion = "24.11";

  programs.home-manager.enable = true;

  programs.bash.enable = true;

  programs.git = {
    enable = true;
    userName = "Xaver Krudewig";
    userEmail = "xaver-krudewig@outlook.com";
  };

  xdg.configFile."hypr/hyprland.conf".text = ''
    monitor=,preferred,auto,1

    exec-once = waybar
    exec-once = dunst

    input {
      kb_layout = us
    }

    bind = SUPER, RETURN, exec, kitty
    bind = SUPER, D, exec, rofi -show drun
    bind = SUPER, Q, killactive
    bind = SUPER, M, exit
  '';
}