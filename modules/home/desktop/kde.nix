{ pkgs, ... }:

{
  home.packages = with pkgs; [
    kdePackages.plasma-integration
    kdePackages.qqc2-desktop-style
    kdePackages.kdegraphics-thumbnailers
    kdePackages.ffmpegthumbs
  ];

   xdg.configFile."dolphinrc".text = ''
    MenuBar=Disabled

    [General]
    OpenExternallyCalledFolderInNewTab=true
    OpenNewTabAfterLastTab=true
    RememberOpenedTabs=false
    ShowFullPathInTitlebar=true

    [IconsMode]
    PreviewSize=48
    IconSize=32

    [DetailsMode]
    PreviewSize=22
  '';

  xdg.configFile."baloofilerc".text = ''
    [Basic Settings]
    Indexing-Enabled=false
  '';

  xdg.configFile."KDE/UserFeedback.conf".text = ''
    [UserFeedback]
    Enabled=false
  '';

  xdg.configFile."kwalletrc".text = ''
    [Wallet]
    Enabled=false
    First Use=false
  '';

  xdg.configFile."ksmserverrc".text = ''
    [General]
    loginMode=emptySession
  '';
}