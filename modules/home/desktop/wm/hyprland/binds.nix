{ hostOptions, lib, ... }:

let
  monitorNames = map (m: m.name) hostOptions.desktop.monitors;
  swapBind =
    if (builtins.length monitorNames) >= 2 then
      [
        "$shiftMod, S, swapactiveworkspaces, ${builtins.elemAt monitorNames 0} ${builtins.elemAt monitorNames 1}"
      ]
    else
      [ ];
in
{
  wayland.windowManager.hyprland.settings = {
    # Mod Vars
    "$mainMod" = "SUPER";
    "$shiftMod" = "$mainMod SHIFT";
    "$altMod" = "$mainMod ALT";
    "$ctrlMod" = "$mainMod CTRL";

    bind = [
      "$shiftMod, M, exec, noctalia-shell ipc call sessionMenu toggle"
      "$shiftMod, C, killactive"
      "$mainMod, V, togglefloating"
      "$mainMod, F, fullscreen, 1"
      "$shiftMod, F, fullscreen, 0"
      "$mainMod, J, togglesplit"
      "$mainMod, P, pseudo"
      "$shiftMod, P, pin"

      # Focus movement
      "$mainMod, left, movefocus, l"
      "$mainMod, right, movefocus, r"
      "$mainMod, up, movefocus, u"
      "$mainMod, down, movefocus, d"

      # Window movement
      "$shiftMod, left, movewindow, l"
      "$shiftMod, right, movewindow, r"
      "$shiftMod, up, movewindow, u"
      "$shiftMod, down, movewindow, d"

      # Workspaces
      "$mainMod, 1, workspace, 1"
      "$mainMod, 2, workspace, 2"
      "$mainMod, 3, workspace, 3"
      "$mainMod, 4, workspace, 4"
      "$mainMod, 5, workspace, 5"
      "$mainMod, 6, workspace, 6"
      "$mainMod, 7, workspace, 7"
      "$mainMod, 8, workspace, 8"
      "$mainMod, 9, workspace, 9"
      "$mainMod, 0, workspace, 10"

      # Move to workspace
      "$shiftMod, 1, movetoworkspace, 1"
      "$shiftMod, 2, movetoworkspace, 2"
      "$shiftMod, 3, movetoworkspace, 3"
      "$shiftMod, 4, movetoworkspace, 4"
      "$shiftMod, 5, movetoworkspace, 5"
      "$shiftMod, 6, movetoworkspace, 6"
      "$shiftMod, 7, movetoworkspace, 7"
      "$shiftMod, 8, movetoworkspace, 8"
      "$shiftMod, 9, movetoworkspace, 9"
      "$shiftMod, 0, movetoworkspace, 10"

      # Silent move to workspace
      "$altMod, 1, movetoworkspacesilent, 1"
      "$altMod, 2, movetoworkspacesilent, 2"
      "$altMod, 3, movetoworkspacesilent, 3"
      "$altMod, 4, movetoworkspacesilent, 4"
      "$altMod, 5, movetoworkspacesilent, 5"
      "$altMod, 6, movetoworkspacesilent, 6"
      "$altMod, 7, movetoworkspacesilent, 7"
      "$altMod, 8, movetoworkspacesilent, 8"
      "$altMod, 9, movetoworkspacesilent, 9"
      "$altMod, 0, movetoworkspacesilent, 10"

      # Scroll workspaces
      "$mainMod, mouse_down, workspace, e+1"
      "$mainMod, mouse_up, workspace, e-1"

      # Applications
      "$mainMod, E, exec, dolphin"
      "$mainMod, Q, exec, ghostty"
      "$mainMod, R, exec, noctalia-shell ipc call launcher toggle"
      "$mainMod, B, exec, firefox"

      # Media keys
      ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
      ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
      ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
      "SHIFT, XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
      ", XF86AudioNext, exec, noctalia-shell ipc call media next"
      ", XF86AudioPrev, exec, noctalia-shell ipc call media previous"
      ", XF86AudioPlay, exec, noctalia-shell ipc call media playPause"

      # Brightness
      ", XF86MonBrightnessDown, exec, brightnessctl set 5%-"
      ", XF86MonBrightnessUp, exec, brightnessctl set 5%+"

      # Screenshots
      ", PRINT, exec, hyprshot -z -m region"
      "$mainMod, PRINT, exec, hyprshot -z -m output"
      "$shiftMod, PRINT, exec, hyprshot -z -m window"

      # Lock
      "$mainMod, L, exec, noctalia-shell ipc call lockScreen lock"
    ]
    ++ swapBind;

    bindm = [
      "$mainMod, mouse:272, movewindow"
      "$mainMod, mouse:273, resizewindow"
    ];
  };
}
