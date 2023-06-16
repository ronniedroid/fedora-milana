#!/bin/bash

# remove the default firefox (from fedora) in favor of the flatpak,
# remove rofi and dunst to be replaced by wofi and mako
rpm-ostree override remove firefox firefox-langpacks dunst rofi-wayland rofi-themes virtualbox-guest-additions 
echo "-- Installing RPMs defined in recipe.yml --"
rpm_packages=$(yq '.rpms[]' </usr/etc/ublue-recipe.yml)
for pkg in $(echo -e "$rpm_packages"); do
	echo "Installing: ${pkg}" &&
		rpm-ostree install $pkg
done
echo "---"

# install yafti to install flatpaks on first boot, https://github.com/ublue-os/yafti
pip install --prefix=/usr yafti
