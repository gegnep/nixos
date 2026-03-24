{ pkgs, ... }:

{
  dconf.enable = true;

  home.pointerCursor = {
    gtk.enable = true;
    package = pkgs.phinger-cursors;
    name = "phinger-cursors-light";
    size = 36;
  };

  qt = {
    enable = true;
    platformTheme.name = "kde";
    style.name = "kvantum";
  };

  catppuccin.kvantum = {
    enable = true;
    flavor = "mocha";
    accent = "lavender";
    assertStyle = true;
  };

  gtk = {
    enable = true;
    theme = {
      name = "adw-gtk3-dark";
      package = pkgs.adw-gtk3;
    };
    gtk4.theme = null;
    font = {
      name = "Hack Nerd Font";
      size = 12;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.catppuccin-papirus-folders.override {
        flavor = "mocha";
        accent = "lavender";
      };
    };
  };

  xdg.configFile."kdeglobals".text = ''
    [General]
    ColorScheme=CatppuccinMochaLavender
    Name=Catppuccin Mocha Lavender
    TerminalApplication=ghostty
    TerminalService=com.mitchellh.ghostty.desktop
    BrowserApplication=firefox.desktop
    fixed width font=JetBrainsMono Nerd Font,10,-1,5,400,0,0,0,0,0,0,0,0,0,0,1
    font=Hack Nerd Font,10,-1,5,400,0,0,0,0,0,0,0,0,0,0,170


    [Icons]
    Theme=Papirus-Dark

    [KDE]
    widgetStyle=kvantum
    SingleClick=false

    [Colors:View]
    BackgroundNormal=30,30,46
    BackgroundAlternate=36,36,54
    DecorationFocus=180,190,254
    DecorationHover=180,190,254
    ForegroundNormal=205,214,244
    ForegroundInactive=165,169,188
    ForegroundActive=180,190,254
    ForegroundLink=137,180,250
    ForegroundVisited=203,166,247
    ForegroundNegative=243,139,168
    ForegroundNeutral=249,226,175
    ForegroundPositive=166,227,161

    [Colors:Window]
    BackgroundNormal=24,24,37
    BackgroundAlternate=30,30,46
    DecorationFocus=180,190,254
    DecorationHover=180,190,254
    ForegroundNormal=205,214,244
    ForegroundInactive=165,169,188
    ForegroundActive=180,190,254
    ForegroundLink=137,180,250
    ForegroundVisited=203,166,247
    ForegroundNegative=243,139,168
    ForegroundNeutral=249,226,175
    ForegroundPositive=166,227,161

    [Colors:Button]
    BackgroundNormal=49,50,68
    BackgroundAlternate=59,60,78
    DecorationFocus=180,190,254
    DecorationHover=180,190,254
    ForegroundNormal=205,214,244
    ForegroundInactive=165,169,188
    ForegroundActive=180,190,254
    ForegroundLink=137,180,250
    ForegroundVisited=203,166,247
    ForegroundNegative=243,139,168
    ForegroundNeutral=249,226,175
    ForegroundPositive=166,227,161

    [Colors:Selection]
    BackgroundNormal=180,190,254
    BackgroundAlternate=170,180,244
    ForegroundNormal=30,30,46
    ForegroundInactive=30,30,46
    ForegroundActive=30,30,46
    ForegroundLink=30,30,46
    ForegroundVisited=30,30,46
    ForegroundNegative=243,139,168
    ForegroundNeutral=249,226,175
    ForegroundPositive=166,227,161
    DecorationFocus=180,190,254
    DecorationHover=180,190,254

    [Colors:Tooltip]
    BackgroundNormal=36,36,54
    BackgroundAlternate=30,30,46
    ForegroundNormal=205,214,244
    ForegroundInactive=165,169,188
    ForegroundActive=180,190,254
    ForegroundLink=137,180,250
    ForegroundVisited=203,166,247
    ForegroundNegative=243,139,168
    ForegroundNeutral=249,226,175
    ForegroundPositive=166,227,161
    DecorationFocus=180,190,254
    DecorationHover=180,190,254

    [Colors:Complementary]
    BackgroundNormal=24,24,37
    BackgroundAlternate=30,30,46
    ForegroundNormal=205,214,244
    ForegroundInactive=165,169,188
    ForegroundActive=180,190,254
    ForegroundLink=137,180,250
    ForegroundVisited=203,166,247
    ForegroundNegative=243,139,168
    ForegroundNeutral=249,226,175
    ForegroundPositive=166,227,161
    DecorationFocus=180,190,254
    DecorationHover=180,190,254

    [Colors:Header]
    BackgroundNormal=24,24,37
    BackgroundAlternate=30,30,46
    ForegroundNormal=205,214,244
    ForegroundInactive=165,169,188
    ForegroundActive=180,190,254
    ForegroundLink=137,180,250
    ForegroundVisited=203,166,247
    ForegroundNegative=243,139,168
    ForegroundNeutral=249,226,175
    ForegroundPositive=166,227,161
    DecorationFocus=180,190,254
    DecorationHover=180,190,254

    [WM]
    activeBackground=24,24,37
    activeForeground=205,214,244
    inactiveBackground=30,30,46
    inactiveForeground=165,169,188
  '';
}
