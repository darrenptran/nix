# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  services.xserver.displayManager.sddm.enable = true;
  services.xserver.displayManager.autoLogin.enable = true;
  services.xserver.displayManager.autoLogin.user = "darren";
  services.xserver.displayManager.startx.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;

nix.settings.experimental-features = [ "nix-command" "flakes" ];


virtualisation.virtualbox.host.enable = true;
virtualisation.virtualbox.host.enableExtensionPack = true;
virtualisation.virtualbox.guest.enable = true;
virtualisation.virtualbox.guest.x11 = true;
users.extraGroups.vboxusers.members = [ "user-with-access-to-virtualbox" ];

boot.loader = {
efi = {
canTouchEfiVariables = true;
efiSysMountPoint = "/boot/efi"; # ← use the same mount point here.
};
grub = {
efiSupport = true;
device = "nodev";
useOSProber = true;
};
};

# kernel
boot.kernelPackages = pkgs.linuxPackages_xanmod_latest;

# networking
networking.hostName = "nixos";
networking.networkmanager.enable = true;
networking.firewall = {
enable = true;
allowedTCPPorts = [ 80 443 9100 ];
allowedUDPPortRanges = [
{ from = 4000; to = 4007; }
{ from = 8000; to = 8010; }
{ from = 1714; to = 1764; }
];
};

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
# services

services.flatpak.enable = true;
services.xserver.enable = true;
services.xserver = {
layout = "us";
xkbVariant = "";
};
services.printing.enable = true;
services.avahi = {
enable = true;
nssmdns = true;
openFirewall = true;
};
sound.enable = true;
hardware.pulseaudio.enable = false;
security.rtkit.enable = true;
services.pipewire = {
enable = true;
alsa.enable = true;
alsa.support32Bit = true;
pulse.enable = true;
jack.enable = true;
};
programs.dconf.enable = true;
programs.kdeconnect.enable = true;
programs.mtr.enable = true;
programs.gnupg.agent = {
enable = true;
enableSSHSupport = true;
};

# bluetooth
hardware.bluetooth.enable = true;
hardware.bluetooth.powerOnBoot = true;

# zsh
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
google-chrome
spotify
joplin-desktop
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
slack
teams-for-linux
plank
yakuake
kdeconnect
libsForQt5.kcalc
libsForQt5.kate
];

environment.plasma5.excludePackages = [ 
pkgs.libsForQt5.gwenview
pkgs.libsForQt5.elisa
];

services.xserver.excludePackages = with pkgs; [
xterm
];
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}
