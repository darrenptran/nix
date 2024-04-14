GNU nano 7.2                                       /etc/nixos/configuration.nix
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
