{
  config,
  pkgs,
  ...
}: {
  # Services to start
  services = {
    blueman.enable = true;
    flatpak.enable = true;
    fstrim.enable = true;
    gvfs.enable = true;
    joycond.enable = config.variables.gaming;
    libinput.enable = true;
    openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
        PermitRootLogin = "no";
      };
    };

    # wireguard mesh between hosts; `sudo tailscale up` once per machine
    tailscale = {
      enable = true;
      openFirewall = true;
    };
    resolved.enable = true;
    smartd = {
      enable = false;
      autodetect = true;
    };
    printing = {
      enable = true;
      drivers = [
        # pkgs.hplipWithPlugin
      ];
    };
    gnome.gnome-keyring.enable = true;
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
    ipp-usb.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
      wireplumber.enable = true;
      # Global low-latency defaults for native JACK clients
      extraConfig.pipewire."92-low-latency" = {
        "context.properties" = {
          "default.clock.rate" = 48000;  # Fixed rate avoids resampling latency
          "default.clock.quantum" = 128;      # ~5ms latency at 48kHz
          "default.clock.min-quantum" = 64;   # ~2.5ms latency at 48kHz
          "default.clock.max-quantum" = 512;
        };
      };

      # Crucial: Match low-latency for PulseAudio clients (browsers, Steam/Rocksmith)
      extraConfig.pipewire-pulse."92-low-latency" = {
        "pulse.properties" = {
          "pulse.min.req" = "64/48000";    # Start with 64, not 32, for stability
          "pulse.default.req" = "64/48000";
          "pulse.max.req" = "128/48000";
        };
      };
    };
    udev.extraRules = ''
      KERNEL=="i2c-[0-9]*", GROUP="i2c", MODE="0660"
    '';
  };

  # VST Dogshit
  environment.sessionVariables = let
    makePluginPath = format:
      (pkgs.lib.makeSearchPath format [
        "$HOME/.nix-profile/lib"
        "/run/current-system/sw/lib"
        "/etc/profiles/per-user/$USER/lib"
      ]) + ":$HOME/.${format}";
  in {
    LV2_PATH = makePluginPath "lv2";
    VST3_PATH = makePluginPath "vst3";
    CLAP_PATH = makePluginPath "clap";  # Modern plugin format, supported by LSP/Chow
  };

  systemd.services.flatpak-repo = {
    wantedBy = ["multi-user.target"];
    path = [pkgs.flatpak];
    script = ''
      flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    '';
  };
}
