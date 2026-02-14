{ pkgs, ... }:

let
  profilePath = "~/.nix-profile";
  homePath = "/home/pengeg";
in
{
  # Plugin paths for DAWs
  systemd.user.sessionVariables = {
    LV2_PATH = "${profilePath}/lib/lv2";
    VST_PATH = "${profilePath}/lib/vst:${homePath}/.vst:${homePath}/.vst/yabridge";
    LXVST_PATH = "${profilePath}/lib/vst:${homePath}/.vst:${homePath}/.vst/yabridge";
    VST3_PATH = "${profilePath}/lib/vst3";
    LADSPA_PATH = "${profilePath}/lib/ladspa";
  };

  home.packages = with pkgs; [
    # DAWs
    bitwig-studio
    tenacity
    musescore

    # Utilities
    klick
    qpwgraph
    alsa-scarlett-gui
    pavucontrol

    # Plugins (LV2, VST2, VST3, LADSPA)
    calf
    lsp-plugins
    x42-plugins
    x42-gmsynth
    dragonfly-reverb
    guitarix
    fil-plugins
    geonkick

    # Windows VST support
    # TODO: yabridge broken on unstable
    #yabridge
    #yabridgectl
    wineWow64Packages.stable
    winetricks
  ];

  # Yabridge configuration
  home.file.".config/yabridgectl/config.toml".text = ''
    plugin_dirs = ['/home/pengeg/.win-vst']
    vst2_location = 'centralized'
    no_verify = false
    blacklist = []
  '';
}
