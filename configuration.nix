{ config, pkgs, ... }:
let
home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/master.tar.gz";
in
{
imports =
[
./hardware-configuration.nix
(import "${home-manager}/nixos")
];

# Omit the previous configuration...

# Enable Flakes and the new command-line tool
nix.settings.experimental-features = [ "nix-command" "flakes" ];
#  nativeBuildInputs = [ ...  autoreconfHook ];
# Bootloader.
boot.loader.systemd-boot.enable = true;
boot.loader.efi.canTouchEfiVariables = true;
boot.kernelPackages = pkgs.linuxPackages_xanmod_latest;
nixpkgs.system = {
gcc.arch = "znver3";
gcc.tune = "znver3";
system = "x86_64-linux";
};


nixpkgs.config.permittedInsecurePackages = [
"electron-19.1.9"
];

hardware.bluetooth.enable = true; # enables support for Bluetooth
#  hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot
services.blueman.enable = true;

networking.hostName = "nixos"; # Define your hostname.
# networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

# Configure network proxy if necessary
# networking.proxy.default = "http://user:password@proxy:port/";
# networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

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
services.flatpak.enable = true;

# Enable the KDE Plasma Desktop Environment.
services.xserver.displayManager.sddm.enable = true;
services.xserver.desktopManager.plasma5.enable = true;

# Configure keymap in X11
services.xserver = {
layout = "us";
xkbVariant = "";
};

# Enable CUPS to print documents.
services.printing.enable = true;

# Enable sound with pipewire.
sound.enable = true;
hardware.pulseaudio.enable = false;
security.rtkit.enable = true;
services.pipewire = {
enable = true;
alsa.enable = true;
alsa.support32Bit = true;
pulse.enable = true;
# If you want to use JACK applications, uncomment this
jack.enable = true;
};

# Enable touchpad support (enabled default in most desktopManager).
# services.xserver.libinput.enable = true;

# Define a user account. Don't forget to set a password with ‘passwd’.
users.users.darren = {
isNormalUser = true;
description = "Darren Tran";
extraGroups = [ "networkmanager" "wheel" ];
packages = with pkgs; [
firefox
thunderbird
google-chrome
spotify
joplin-desktop
vscode-with-extensions
libsForQt5.dolphin
libsForQt5.ffmpegthumbs
libsForQt5.ark
libsForQt5.kcalc
libsForQt5.spectacle
libsForQt5.okular
libsForQt5.yakuake
featherpad
openshot-qt
ccache
preload
haveged
github-desktop
nomacs
vlc
fzf
autojump
cups
hplipWithPlugin
freshfetch
zsh
sudo
nano
cmakeWithGui
cmake
automake
autobuild
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
hermit
plank
];
};

# Allow unfree packages
nixpkgs.config.allowUnfree = true;
#  nixpkgs.config.allowInsecure = true;

# List packages installed in system profile. To search, run:
# $ nix search wget
environment.systemPackages = with pkgs; [
amd-blis
amdgpu_top
amd-libflame
microcodeAmd
radeon-profile
nvtop-amd
];

environment.plasma5.excludePackages = with pkgs.libsForQt5; [
gwenview
elisa
];


# Some programs need SUID wrappers, can be configured further or are
# started in user sessions.
programs.mtr.enable = true;
programs.dconf.enable = true;
programs.gnupg.agent = {
enable = true;
enableSSHSupport = true;
};
programs.zsh = {
enable = true;
shellAliases = {
ll = "ls -l";
update = "sudo nixos-rebuild switch";
};
histSize = 10000;
};
users.defaultUserShell = pkgs.zsh;
# List services that you want to enable:

# Enable the OpenSSH daemon.
# services.openssh.enable = true;

# Open ports in the firewall.
# networking.firewall.allowedTCPPorts = [ ... ];
# networking.firewall.allowedUDPPorts = [ ... ];
# Or disable the firewall altogether.
networking.firewall.enable = false;


system.stateVersion = "23.11";
}
