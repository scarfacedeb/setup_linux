#!/usr/bin/env bash

. functions.sh

setup_apt(){
  should_setup="N"
  user ' - Do you want to setup apt? (y/N)'
  read -e should_setup

  if [[ $should_setup = 'y' ]]
  then
    echo "Setup apt..."

    local sources_list="sources.$OS.list"
    local keys_list="apt_keys.$OS.sh"

    if [ -f $sources_list ]; then
      echo  "Replacing sources.list"
      cp $sources_list /etc/apt/sources.list
    fi

    if [ -f $keys_list ]; then
      echo "Importing keys"
      . $keys_list >> /tmp/setup_linux.log
    fi

    echo "Updating and upgrading"
    apt-get update

    # Import all missing gpg keys
    apt-get -y install launchpad-getkeys aptitude
    launchpad-getkeys

    aptitude upgrade
  fi
}

install_apt(){
  user ' - Do you want to install packages? (Y/n)'
  read -e should_install

  if [[ "${should_install:-y}" = 'y' ]]
  then
    user '- Do you want to edit packages? (y/N)'
    read -e should_edit_packages

    # manually edit list of packages to install
    if [[ "${should_edit_packages:-n}" = 'y' ]]
    then
      printf -- '%s\n' "${packages[@]}"  > ./tmp_packages
      (vi ./tmp_packages) && mapfile -t  packages < ./tmp_packages
      rm ./tmp_packages
    fi

    echo "Installing apt packages: ${packages[*]}"
    aptitude install ${packages[*]}
  fi
}

remove_apt(){
  should_remove="N"
  user ' - Do you want to remove garbage packages? (y/N)'
  read -e should_remove

  if [[ $should_remove = 'y' ]]
  then
    echo "Removing garbage packages: ${garbage[*]}"
    aptitude purge ${garbage[@]}
  fi
}

OS=$(lsb_release -si | tr '[:upper:]' '[:lower:]')

# Apt packages to install
packages=()

# Libs
#  libqtwebkit-dev: dependency of capybara-webkit gem
packages+=(build-essential libc6-dbg linux-headers-generic dkms automake imagemagick ttf-mscorefonts-installer libqtwebkit-dev python-pip)

# Utils
# - foremost: recover lost files
# - pigz: parallel gzip
# - pv: pipe viewer for monitoring the progress of data through a pipeline.
# - tree: output directory tree
# - bleachbit: clean up
packages+=(htop foremost lynx pigz pv tree dconf-editor bleachbit tcpdump ngrep nmap iptables net-tools telnet coreutils locate unzip p7zip p7zip-rar unetbootin whois curl wget screenfetch)

# Misc programs
# - sunflower: totalcommander-like file manager
# - xchat: IRC client
# - transmission: torrent client
packages+=(dropbox sunflower thunar xchat transmission gimp geeqie pavucontrol flac lame mpg123 rdesktop  zsh mc)

# Openbox
# - obmenu: edit openbox menu
# - obapps: app-specific configs for openbox
# - obconf: configure openbox
# - lxappearance: configure themes and icons
# - tint2: panel
# - nitrogen: manage the wallpapers
# - clipit: clipboard manager
# - xfce4-appfinder: snappier synapse launcer
# - gmrun: simple launcher
packages+=(openbox obmenu obconf obapps lxappearance tint2 nitrogen clipit xfce4-appfinder gmrun xfce4-screenshooter)

# Misc packages
# - suckless-tools: simple minimalistic commands
packages+=(pulseaudio openssh-client openssh-server mkvtoolnix-gui suckless-tools gnome-keyring)

# Eye-candy
packages+=(gtk2-engines-equinox equinox-theme faenza-icon-theme)

# Browsers
packages+=(google-chrome-stable google-chrome-unstable firefox opera-next)

# Media
packages+=(deadbeef vlc smplayer)

# Work tools
# - trimage: optimize images
packages+=(terminator guake tmux sublime-text-installer vim gcolor2 trimage mercurial cvs)

# Git
packages+=(git git-cola giggle gitk gitg)

# Dev tools
# - postfix: email server
packages+=(postgresql postgresql-contrib pgadmin3 sqlite3 sqlitebrowser nodejs npm webp pngcrush exif jhead jpegoptim postfix perl python3)

# Games
packages+=(freeciv-client-gtk)



# Apt packages to remove (e.g. apport on ubuntu)
garbage=(apport apport-gtk xfburn xpad gnome-mplayer simple-scan gpicview lxterminal bluez ghostscript wvdial)
# remove by a regex
garbage+=("~n^cups" "~n^audacious" "~n^geany")
# remove xserver useless drivers
garbage+=(xserver-xorg-input-vmmouse xserver-xorg-input-wacom xserver-xorg-input-synaptics xserver-xorg-video-glamoregl xserver-xorg-video-modesetting xserver-xorg-video-qxl xserver-xorg-video-savage xserver-xorg-video-tdfx xserver-xorg-video-ati xserver-xorg-video-intel xserver-xorg-video-neomagic xserver-xorg-video-r128 xserver-xorg-video-siliconmotion xserver-xorg-video-trident xserver-xorg-video-cirrus xserver-xorg-video-mach64  xserver-xorg-video-radeon xserver-xorg-video-sis xserver-xorg-video-fbdev xserver-xorg-video-mga xserver-xorg-video-openchrome xserver-xorg-video-s3 xserver-xorg-video-sisusb xserver-xorg-video-vmware)


remove_apt
setup_apt
install_apt
