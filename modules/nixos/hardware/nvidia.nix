{ config, lib, ... }:

lib.mkIf (config.mySystem.hardware.gpu == "nvidia") {
  # TODO: nvidia stuff and things
}
