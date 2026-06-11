{ pkgs, ... }:
{
  hardware = {
    sane = {
      enable = true;
      extraBackends = [ pkgs.sane-airscan ];
      disabledDefaultBackends = [ "escl" ];
    };
    logitech.wireless.enable = false;
    logitech.wireless.enableGraphical = false;
    graphics.enable = true;
    enableRedistributableFirmware = true;
    keyboard.qmk.enable = true;
    bluetooth.enable = true;
    bluetooth.powerOnBoot = true;
  };
  local.hardware-clock.enable = false;

  fileSystems."/run/media/Games" =
    { device = "/dev/disk/by-uuid/a6a51055-35f1-4e78-b46b-f927c30955ba";
      fsType = "ext4";
      options = [ "rw" "users" "exec" "noatime" "nofail" ];
    };

  fileSystems."/run/media/Files" =
    { device = "/dev/disk/by-uuid/b0ddac53-f669-42e5-9c15-7d5d6d9600eb";
      fsType = "ext4";
      options = [ "users" "nofail" ];
    };
}
