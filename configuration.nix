{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Los_Angeles";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

 nixpkgs.config.permittedInsecurePackages = [
     "python-2.7.18.8"
  ];

  # Enable Flatpak
  services.flatpak.enable = true;
  services.haveged.enable = true;
  hardware.cpu.intel.updateMicrocode = true;
    # Install and configure Docker
  virtualisation.docker = {
    enable = true;
    # Run docker system prune -f periodically
    autoPrune.enable = true;
    autoPrune.dates = "weekly";
    # Don't start the service at boot, use systemd socket activation
    enableOnBoot = false;
  };
  # Install LXD
  virtualisation.lxd.enable = true;
  # Install VB
  virtualisation.virtualbox.host.enable = true;
  # Libvirtd (Qemu)
  virtualisation.libvirtd.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  users.users.dtran = {
    isNormalUser = true;
    description = "Darren Tran";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
    ];
  };

  # Enable automatic login for the user.
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "dtran";

  # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

   # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    ghostty
    gearlever
    zsh
    flatpak
    autojump
    fzf
    fastfetch
    nomacs
    google-chrome
    gnome-calendar
    libreoffice-fresh
    vlc
    ntfs3g
    xfsprogs
    btrfs-progs
    exfat
    lm_sensors
    usbutils
    pciutils
    lshw
    dmidecode
    hdparm
    smartmontools
    p7zip
     # Compiler and debugger
    gcc gdb
    # Build tools
    automake
    gnumake
    pkg-config
    clang-tools
    git
    curl
    wget
    gtk3
    gnome-extension-manager
    gnome-tweaks
    zoom-us
    teams-for-linux
    python2
    python314
    vscode
    cmake
    nodejs
    pavucontrol # PulseAudio Volume Control, GUI
    # Nix tools
    nix-du #https://github.com/symphorien/nix-du
    common-updater-scripts
   ];

  environment.gnome.excludePackages = with pkgs; [
    eog
    gnome-tour
    geary
    cheese
    totem
    gnome-maps
    gnome-logs
    gnome-clocks
    gnome-contacts
    gnome-characters
    gnome-console
    gnome-music
    epiphany
    xterm
  ];

  services.openssh.enable = true;

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 22 80 ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  system.stateVersion = "24.11"; # Did you read the comment?

}
