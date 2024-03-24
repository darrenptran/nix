{ config, pkgs, lib, ... }:

{
imports =
[
./hardware-configuration.nix
];

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
allowedTCPPorts = [ 80 443 ];
allowedUDPPortRanges = [
{ from = 4000; to = 4007; }
{ from = 8000; to = 8010; }
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
services.xserver.displayManager.lightdm.enable = true;
services.xserver.desktopManager.pantheon.enable = true;
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

# packages
nixpkgs.config.allowUnfree = true;
nixpkgs.config.packageOverrides = pkgs: {
nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
inherit pkgs;
};
};
nixpkgs.config.permittedInsecurePackages = [
"electron-19.1.9"
"imagemagick-6.9.12-68"
];

users.users.darren = {
isNormalUser = true;
description = "Darren Tran";
extraGroups = [ "networkmanager" "wheel" ];
packages = with pkgs.nur.repos; [
vanilla.fastfetch
wolfangaukang.vdhcoapp
];
};

environment.systemPackages = with pkgs; [
microcodeIntel
iucode-tool
xf86-video-intel
intel-hybrid-driver
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
plank
nextcloud-client
xorg.xrandr
libreoffice
zoom-us
discord
zim
hplip
krita
media-downloader
];

services.xserver.excludePackages = with pkgs; [
xterm
];

system.stateVersion = "23.11";

}
