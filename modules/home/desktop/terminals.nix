{ ... }:

{
  programs.ghostty = {
    enable = true;
    enableZshIntegration = true;
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
      confirm-close-surface = false;
      scroll-sensitivity = 3;
      quit-after-last-window-closed = true;

      cursor-style = "block";
      cursor-style-blink = false;
      selection-invert-fg-bg = true;
    };
  };
  catppuccin.ghostty.enable = true;

  programs.kitty = {
    enable = true;
    font.name = "Hack Nerd Font";
    shellIntegration.enableZshIntegration = true;
  };
  catppuccin.kitty.enable = true;
}
