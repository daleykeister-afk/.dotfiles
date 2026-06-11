{
  pkgs,
  config,
  ...
}: {
  boot = {
    kernelPackages = pkgs.linuxPackages_zen;
    kernelParams = [ 
      "threadirqs"
      "preempt=full"              # Optional: add if experiencing Xruns
      "amd_pstate=passive"        # Zen 4/5: passive + performance governor = stable freq
      # For Intel or older AMD: remove amd_pstate or use "intel_pstate=active"
      "usbcore.autosuspend=-1"    # Prevent USB audio interface sleep
    ];
    kernelModules = ["v4l2loopback" "i2c-dev"];
    extraModulePackages = [config.boot.kernelPackages.v4l2loopback];
    kernel.sysctl = {"vm.max_map_count" = 2147483642;};

    # loader.systemd-boot.enable = true;
    # loader.efi.canTouchEfiVariables = true;
    loader = {
      efi.canTouchEfiVariables = true;
      grub = {
        enable = true;
        device = "nodev";
        efiSupport = true;
        useOSProber = true;
        gfxmodeEfi = "2560x1440";
        # stylix manages grub theme
        # theme = pkgs.catppuccin-grub;
      };
    };

    # Appimage Support
    binfmt.registrations.appimage = {
      wrapInterpreterInShell = false;
      interpreter = "${pkgs.appimage-run}/bin/appimage-run";
      recognitionType = "magic";
      offset = 0;
      mask = ''\xff\xff\xff\xff\x00\x00\x00\x00\xff\xff\xff'';
      magicOrExtension = ''\x7fELF....AI\x02'';
    };
    plymouth.enable = true;
  };

  powerManagement.cpuFreqGovernor = "performance";
}
