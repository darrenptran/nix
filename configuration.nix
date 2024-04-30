{ config, pkgs, lib, ... }:

{
imports =
[
./hardware-configuration.nix
];

  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot/efi";
    };
    grub = {
      efiSupport = true;
      device = "nodev";
      useOSProber = true;
    };
  };

  boot.kernelPackages = pkgs.linuxPackages_xanmod_latest;
  nixpkgs.localSystem = {
    gcc.arch = "znver3";
    gcc.tune = "znver3";
    system = "x86_64-linux";
  };

networking.hostName = "nixos"; # Define your hostname.
networking.networkmanager.enable = true;
time.timeZone = "America/Los_Angeles";

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

services.printing.enable = true;
services.flatpak.enable = true;
services.xserver.enable = true;
services.xserver.displayManager.sddm.enable = true;
services.xserver.desktopManager.plasma5.enable = true;
services.xserver = {
layout = "us";
xkbVariant = "";
};
services.pipewire = {
enable = true;
alsa.enable = true;
alsa.support32Bit = true;
pulse.enable = true;
jack.enable = true;
};
services.xserver.excludePackages = with pkgs; [
xterm
];


sound.enable = true;
hardware.pulseaudio.enable = false;
security.rtkit.enable = true;

programs.zsh = {
enable = true;
histSize = 0;
};
users.defaultUserShell = pkgs.zsh;

nixpkgs.config.allowUnfree = true;
nixpkgs.config.permittedInsecurePackages = [
"electron-19.1.9"
"imagemagick-6.9.12-68"
];

users.users.darren = {
isNormalUser = true;
description = "Darren Tran";
extraGroups = [ "networkmanager" "wheel" ];
};

environment.systemPackages = with pkgs; [
fastfetch
firefox
thunderbird
chromium
spotify
joplin-desktop
ktorrent
vscode-with-extensions
ccache
preload
haveged
github-desktop
nomacs
vlc
fzf
autojump
cups
zsh
sudo
nano
gitFull
gitui
curlFull
wget
ntfs3g
dosfstools
btrfs-progs
xfsprogs
xorg.xfs
xfsdump
etcher
intel-one-mono
league-spartan
nextcloud-client
xorg.xrandr
libreoffice
zoom-us
discord
zim
hplip
media-downloader
teams-for-linux
plank
yakuake
kdeconnect
appimage-run
flatpak
os-prober
libsForQt5.kcalc
libsForQt5.kate
];

environment.plasma5.excludePackages = [
pkgs.libsForQt5.gwenview
pkgs.libsForQt5.elisa
];

system.stateVersion = "23.11";
}
