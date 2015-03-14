#!/bin/bash
#
# Install script for 4deck addon to "The Deck"
# This script will install udev rules which will turn a USB hub
# into a magic hub.  Every block device connected to the magic hub
# will be automatically mounted under the /media directory as read only.
# While this was designed to work with "The Deck" it will most likely
# work with most modern Linux distros.  This software is provided as is
# without warranty of any kind, express or implied.  Use at your own
# risk.  The author is not responsible for anything that happens as 
# a result of using this software.
#
# Initial version created August 2012 by Dr. Phil Polstra, Sr.
# Version 1.1 created March 2015
#     new versions adds support for a second PID which is required
#     when using USB 3.0 hubs as they actually present as two hubs
# 
#
# Author may be contacted at @ppolstra or DrPhil@polstra.org
# Author's site that may have updates http://philpolstra.com
#
# Enough blabbing - let's get on with it!

unset VID
unset PID
unset PID2

function usage {
  echo "usage: sudo $(basename $0) --vid 05e3 --pid 0608 [--pid2 0610]"
  cat <<EOF
  
Bugs email: "DrPhil at polstra.org"

Required Parameters:
--vid <Vendor ID of USB hub>
--pid <Product ID of USB hub>

Optional Parameters:
--pid2 <Second Product ID of USB 3.0 hub>
EOF
exit
}

function createRule {
  cat > /etc/udev/rules.d/10-protectedmount.rules <<-__EOF__
  ACTION=="add", SUBSYSTEM=="block", KERNEL=="sd?[1-9]", ATTRS{idVendor}=="${VID}", ATTRS{idProduct}=="${PID}", ENV{PHIL_MOUNT}="1", ENV{PHIL_DEV}="%k", RUN+="/etc/udev/scripts/protmount.sh %k %n"
  ACTION=="remove", SUBSYSTEM=="block", KERNEL=="sd?[1-9]", ATTRS{idVendor}=="${VID}", ATTRS{idProduct}=="${PID}", ENV{PHIL_UNMOUNT}="1", RUN+="/etc/udev/scripts/protmount3.sh %k %n"

  ENV{PHIL_MOUNT}=="1", ENV{UDISKS_PRESENTATION_HIDE}="1", ENV{UDISKS_AUTOMOUNT_HINT}="never", RUN+="/etc/udev/scripts/protmount2-%n.sh"
  ENV{PHIL_MOUNT}!="1", ENV{UDISKS_PRESENTATION_HIDE}="0", ENV{UDISKS_AUTOMOUNT_HINT}="always"

  ENV{PHIL_UNMOUNT}=="1", RUN+="/etc/udev/scripts/protmount4-%n.sh"

__EOF__

if [ ! "$PID2" = "" ] ; then
  cat >> /etc/udev/rules.d/10-protectedmount.rules <<-__EOF__
  ACTION=="add", SUBSYSTEM=="block", KERNEL=="sd?[1-9]", ATTRS{idVendor}=="${VID}", ATTRS{idProduct}=="${PID2}", ENV{PHIL_MOUNT}="1", ENV{PHIL_DEV}="%k", RUN+="/etc/udev/scripts/protmount.sh %k %n"
  ACTION=="remove", SUBSYSTEM=="block", KERNEL=="sd?[1-9]", ATTRS{idVendor}=="${VID}", ATTRS{idProduct}=="${PID2}", ENV{PHIL_UNMOUNT}="1", RUN+="/etc/udev/scripts/protmount3.sh %k %n"

  ENV{PHIL_MOUNT}=="1", ENV{UDISKS_PRESENTATION_HIDE}="1", ENV{UDISKS_AUTOMOUNT_HINT}="never", RUN+="/etc/udev/scripts/protmount2-%n.sh"
  ENV{PHIL_MOUNT}!="1", ENV{UDISKS_PRESENTATION_HIDE}="0", ENV{UDISKS_AUTOMOUNT_HINT}="always"

  ENV{PHIL_UNMOUNT}=="1", RUN+="/etc/udev/scripts/protmount4-%n.sh"

__EOF__
fi

}

function copyScripts {
  if [ ! -d "/etc/udev/scripts" ] ; then
    mkdir /etc/udev/scripts
  fi
  cp ./protmount*.sh /etc/udev/scripts/. 
}

# parse commandline options
while [ ! -z "$1" ]; do
  case $1 in
    -h|--help)
      usage
      ;;
    --vid)
      VID="$2"
      ;;
    --pid)
      PID="$2"
      ;;
    --pid2)
      PID2="$2"
      ;;
   esac
   shift
done

# now actually do something
createRule
copyScripts
