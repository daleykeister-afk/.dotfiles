{
  # Git Configuration ( For Pulling Software Repos )
  gitUsername = "daleykeister-afk";
  gitEmail = "232945931+daleykeister-afk@users.noreply.github.com";

  # Hyprland Settings
  extraMonitorSettings = "
    monitor = DP-3, 2560x1440@240, 0x400, auto
    monitor = DP-2, 2560x1440@144, 2560x0, auto, transform, 1
    monitor = HDMI-A-1, 2560x1440@144, -1440x0, auto, transform, 3
  ";
  extraHardwareSettings = "
  ";
  defaultWallpaper = "hollow-knight.png";

  theme = "catppuccin-mocha";

  fontSizes = {
    applications = 12;
    terminal = 15;
    desktop = 11;
    popups = 12;
  };

  # Waybar Settings
  clock24h = true;

  # variables which toggle packages
  gamedev = true;
  gaming = true;
  texlive = false;
  silly = true;
  music = true;

  # Program Options
  browser = "zen"; # Set Default Browser (google-chrome-stable for google-chrome)
  terminal = "kitty"; # Set Default System Terminal
  keyboardLayout = "";
  consoleKeyMap = "us";

  editor = "nvim";
  EDITOR = "nvim";
  VISUAL = "nvim";

  # For Nvidia Prime support
  intelID = "PCI:1:0:0";
  nvidiaID = "PCI:0:2:0";

  # Enable NFS
  enableNFS = true;
}
