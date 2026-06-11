{
  config,
  pkgs,
  ...
}: {
  programs = {
    dconf.enable = true;
    seahorse.enable = true;
    fuse.userAllowOther = true;
    virt-manager.enable = true;
    mtr.enable = true;

    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };

    thunar = {
      enable = true;
      plugins = with pkgs; [
        thunar-archive-plugin
        thunar-volman
      ];
    };
  };

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs;
    [
      # kingler has some serious bugs
      # e.g. because names are changed, pokemon with different forms are just... not printable to the terminal
      # so `kingler name shaymin` doesn't work, and neither does `kingler name shaymin`
      # customPkgs.kingler
      # customPkgs.datacorn

      (agda.withPackages [
        agdaPackages._1lab
        agdaPackages.agda-categories
        agdaPackages.cubical
        agdaPackages.standard-library
      ])
      # fails to build 2025-11-15
      # ardour
      brightnessctl
      ddcutil
      claude-code # unfortunately needed for work
      clock-rs
      dust
      # marked unsafe
      # element-desktop
      edopro # YGO simulator
      eza
      ffmpeg
      file-roller
      fzf
      # fails to build 2026-01-01
      # gemini-cli
      gimp
      tuigreet
      hyprpicker
      imv
      killall
      krabby
      libnotify
      libvirt
      lm_sensors
      lmms
      lxqt.lxqt-policykit
      mask
      masklint
      mpv
      mullvad-vpn
      nicotine-plus
      obs-studio
      pavucontrol
      pciutils
      picard
      playerctl
      prusa-slicer
      qbittorrent-enhanced
      quickemu
      ripgrep
      socat
      unrar
      unzip
      usbutils
      v4l-utils
      vlc
      wget
      zoxide
    ]
    ++ lib.optionals config.variables.gaming [
      # TODO: move retroarch to ../home, add config
      cemu # wii u emu
      dolphin-emu # wii/gcn emu
      joycond
      joycond-cemuhook
      lumafly # HK mod manager
      melonDS #nds emu
      osu-lazer-bin
      prismlauncher # minecraft launcher
      # # fails to build 2026-01-01
      # retroarch-free # generic emu
    ]
    ++ lib.optionals config.variables.gamedev [
      # broken 2026-01-01
      # aseprite
      godot
    ]
    ++ lib.optionals config.variables.music [
      # --- Utilities & Routing ---
      qpwgraph            # Visual patchbay for PipeWire
      pavucontrol         # Profile selection (Pro Audio mode)
      # cpupower            # CPU frequency scaling controls
      alsa-scarlett-gui   # Hardware mixer for Focusrite Scarlett (may require firmware)

      # --- DAWs ---
      ardour
      reaper

      # --- Plugin Hosts ---
      carla               # Modular plugin host / pedalboard, supports Windows VST via yabridge

      # --- Standalone Guitar Processors ---
      guitarix

      # --- Plugins (LV2/CLAP) ---
      neural-amp-modeler-lv2  # NAM: loads .nam files from https://tonehunt.org
      lsp-plugins             # Includes latency meter, compressors, IR loader
      calf
      dragonfly-reverb
      gxplugins-lv2
      kapitonov-plugins-pack  # Profile-based amp models (KPP)
      chow-centaur            # Klon Centaur emulation
      chow-phaser

      # --- Practice & Learning ---
      tuxguitar
      hydrogen

      # --- Windows VST Compatibility ---
      yabridge
      yabridgectl
      wineWow64Packages.stable  # Use wineWow64Packages, as wineWowPackages is deprecated
    ]
    ++ lib.optionals config.variables.silly [
      cmatrix
      cowsay
      fortune-kind
      pipes-rs
    ];
}
