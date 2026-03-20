{ ... }:

{
  programs.ghostty = {
    enable = true;
    settings = {
      background-opacity = 0.8;
      window-decoration = false;
      font-family = "Hack Nerd Font";
      font-size = 12;
      copy-on-select = "clipboard";
      mouse-hide-while-typing = true;
      scrollback-limit = 10000;
      gtk-single-instance = true;
      window-theme = "ghostty";

      cursor-style = "block";
      cursor-style-blink = false;
      selection-invert-fg-bg = true;

      # disable tabs cuz hyprland
      keybind = "super+shift+enter=unbind";
      window-padding-x = 4;
      window-padding-y = 4;
    };
  };

  catppuccin.ghostty.enable = true;
}
