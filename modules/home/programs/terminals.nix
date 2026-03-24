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
      quit-after-last-window-closed = true;

      cursor-style = "block";
      cursor-style-blink = false;
      selection-invert-fg-bg = true;
    };
  };
  catppuccin.ghostty.enable = true;

  programs.kitty = {
    enable = true;
    font = {
      name = "Hack Nerd Font";
      size = 12;
    };
    settings = {
      confirm_os_window_close = 0;
      copy_on_select = "clipboard";
      scrollback_lines = 10000;
      cursor_shape = "block";
      window_padding_width = 4;
    };
  };
  catppuccin.kitty.enable = true;
}
