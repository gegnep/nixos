{ ... }:

{
  programs.git = {
    enable = true;
    settings.user = {
      name = "pengeg";
      email = "noreply@pengeg.com";
    };
  };
}
