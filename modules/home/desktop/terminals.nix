{ ... }:

{
  programs.alacritty = {
    enable = true;
    settings = {
      window = {
        opacity = 0.8;
        blur = true;
      };
    };
  };
  catppuccin.alacritty.enable = true;
}
