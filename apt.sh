#!/usr/bin/env bash

setup_apt(){
  info "Setup apt..."

  local sources_list="sources.$OS.list"
  local keys_list="apt_keys.$OS.sh"

  if [ -f $sources_list ]; then
    info "Replacing sources.list"
    cp $sources_list /etc/apt/sources.list
  fi

  if [ -f $keys_list ]; then
    info "Importing keys"
    . $keys_list >> /tmp/setup_linux.log
  fi

  info "Updating and upgrading"
  apt-get update

  # Import all missing gpg keys
  apt-get -y install launchpad-getkeys aptitude
  launchpad-getkeys

  aptitude -y upgrade
}

install_apt(){
  echo "Installing apt packages: $packages"
  aptitude -y install $packages
}

OS=$(lsb_release -si | tr '[:upper:]' '[:lower:]')

# Apt packages to install
packages=()

# Libs
packages+=(imagemagick build-essentials libc6-dbg linux-headers-amd64 dkms automake ttf-mscorefonts-installer)

# Utils
# - foremost: recover lost files
# - pigz: parallel gzip
# - pv: pipe viewer for monitoring the progress of data through a pipeline.
# - tree: output directory tree
# - obmenu: edit openbox menu
# - obapps: app-specific configs for openbox
# - obconf: configure openbox
# - lxappearance: configure themes and icons
# - bleachbit: clean up
packages+=(htop foremost lynx pigz pv tree obmenu obconf obapps dconf-editor lxappearance bleachbit tcpdump ngrep nmap iptables net-tools telnet coreutils locate unzip p7zip p7zip-rar unetbootin screenfetch)

# Misc programs
# - sunflower: totalcommander-like file manager
# - xchat: IRC client
# - transmission: torrent client
packages+=(dropbox sunflower thunar xchat transmission gimp geeqie pavucontrol flac lame mpg123 rdesktop)

# Misc packages
# - suckless-tools: simple minimalistic commands
packages+=(faenza-icon-theme equinox-theme pulseaudio openssh-client openssh-server mkvtoolnix-gui suckless-tools)

# Browsers
packages+=(google-chrome-stable google-chrome-unstable firefox opera-next)

# Media
packages+=(deadbeef vlc smplayer)

# Essentials
packages+=(zsh curl wget gnome-keyring git)

# Work tools
# - trimage: optimize images
packages+=(git-cola giggle gitk gitg mercurial cvs terminator guake sublime-text-installer vim gcolor2 trimage)

# Dev tools
# - postfix: email server
packages+=(postgresql postgresql-contrib pgadmin3 sqlite3 sqlitebrowser nodejs webp pngcrush exif jhead jpegoptim postfix perl python3)

# Games
packages+=(freeciv)

setup_apt
install_apt
