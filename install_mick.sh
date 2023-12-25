#!/bin/bash
echo  ________________________________________________
echo  Mise en places des sources et ppa
echo ________________________________________________
sudo add-apt-repository -y ppa:otto-kesselgulasch/gimp 
sudo add-apt-repository -y ppa:yannubuntu/boot-repair
sudo add-apt-repository -y ppa:nilarimogard/webupd8
sudo apt-add-repository -y 'deb http://liveusb.info/multisystem/depot all main'
sudo add-apt-repository ppa:ubuntu-wine/ppa -y
echo  "deb http://download.virtualbox.org/virtualbox/debian `lsb_release -sc` contrib" | sudo tee -a /etc/apt/sources.list.d/virtualbox.list
sudo add-apt-repository ppa:peterlevi/ppa -y
echo ________________________________________________
echo  Mise en place des clef gpg
echo ________________________________________________
wget -q http://download.virtualbox.org/virtualbox/debian/oracle_vbox.asc -O- | sudo apt-key add - 
wget -q http://liveusb.info/multisystem/depot/multisystem.asc -O- | sudo apt-key add -
echo ________________________________________________
echo supression de logiciels
echo ________________________________________________
sudo apt-get remove -y thunderbird gnumeric xchat abiword ristretto gthumb mousepad
echo ________________________________________________
echo ________________________________________________
echo update et upgrade
echo ________________________________________________
sudo apt-get update 
sudo apt-get upgrade -y
echo ________________________________________________
echo install virtualbox
echo ________________________________________________
sudo apt-get -y install virtualbox-5.0
sudo usermod -G vboxusers -a $USER
sudo usermod -G disk -a $USER
cp uca.xml ~/.config/Thunar/
echo ________________________________________________
echo Installation des logiciels
echo ________________________________________________
sudo apt-get install -y  variety gparted gftp gnome-search-tool lftp baobab hpijs-ppds audacity gimp wine gedit blender gimp-data-extras a2ps ttf-mscorefonts-installer gedit-plugins   multisystem  kdenlive  libreoffice-pdfimport pdfmod youtube-dl openssh-server libreoffice-calc libreoffice-impress libreoffice-writer libreoffice-draw libreoffice-l10n-fr libreoffice-help-fr hyphen-fr libreoffice-gtk thunar-archive-plugin thunar-media-tags-plugin thunar-volman gwenview kipi-plugins vlc mplayer2 smplayer xubuntu-restricted-extras gstreamer0.10-plugins-ugly regionset libdvdnav4 chromium-browser openjdk-8-jre x264 ffmpeg2theora oggvideotools lightspark transmageddon mppenc faac flac vorbis-tools lame gparted flashplugin-downloader grisbi ipython multisystem boot-repair furiusisomount geany geany-plugin* curlftpfs poppler-utils owncloud-client tomboy mkvtoolnix mkvtoolnix-gui browser-plugin-lightspark gnome-disk-utility
echo ________________________________________________
sudo apt-add -y ppa:webupd8team/nemo
sudo apt-get install -y nemo nemo-audio-tab nemo-compare nemo-data nemo-emblems nemo-filename-repairer nemo-fileroller nemo-image-converter nemo-keyboard nemo-media-columns nemo-pastebin nemo-share nemo-terminal
xdg-mime default nemo.desktop inode/directory application/x-gnome-saved-search

xdg-mime default nemo.desktop inode/directory application/x-gnome-saved-search
gsettings set org.gnome.desktop.background show-desktop-icons false
gsettings set org.nemo.desktop show-desktop-icons true



