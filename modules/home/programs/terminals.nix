{ ... }:

{
  programs.ghostty = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      background-opacity = 0.8;
      window-decoration = true;
      font-family = "Hack Nerd Font";
      font-size = 12;
      gtk-single-instance = true;
      gtk-tabs-location = "bottom";
      window-show-tab-bar = "auto";
      gtk-wide-tabs = false;
      cursor-style = "block";
      cursor-style-blink = false;
      selection-invert-fg-bg = true;
      copy-on-select = "clipboard";
      mouse-hide-while-typing = true;
      scrollback-limit = 10000;
      window-theme = "ghostty";
      confirm-close-surface = false;
      quit-after-last-window-closed = true;

      keybind = [
        # unbind super-prefixed defaults (collide with niri Mod binds)
        "super+ctrl+shift+arrow_up=unbind"
        "super+ctrl+shift+arrow_down=unbind"
        "super+ctrl+shift+arrow_left=unbind"
        "super+ctrl+shift+arrow_right=unbind"
        "super+ctrl+shift+j=unbind"
        "super+ctrl+[=unbind"
        "super+ctrl+]=unbind"

        # rebind onto ctrl+alt (alongside existing goto_split nav)
        "ctrl+alt+shift+arrow_up=resize_split:up,10"
        "ctrl+alt+shift+arrow_down=resize_split:down,10"
        "ctrl+alt+shift+arrow_left=resize_split:left,10"
        "ctrl+alt+shift+arrow_right=resize_split:right,10"
        "ctrl+alt+[=goto_split:previous"
        "ctrl+alt+]=goto_split:next"
        "ctrl+alt+j=write_screen_file:copy,plain"
      ];
    };
  };

  programs.alacritty = {
    enable = true;
    settings = {
      window = {
        opacity = 0.8;
        blur = false;
      };
    };
  };

}
