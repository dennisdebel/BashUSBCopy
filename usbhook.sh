#!/bin/bash
#########################################################
#							#
# Automatic copy contents from usb drive when plugged ! #
#                      	    Célestin PREAULT		#
#		            Mod by Dennis de Bel	#
#########################################################

# Please add that command in /etc/udev/rules.d/99-usbhook.rules to run script when a usb drive is plugged in
#
#	ACTION=="add",KERNEL=="sd*", SUBSYSTEMS=="usb", ATTRS{product}=="*", RUN+="/home/USERNAME/usbhook.sh %k"
#
#	(Change run command according to the location of that script)
#
#	run that command to update udev rules :  sudo udevadm control --reload-rules
#
################################################################################################################

# CONFIGURATION
LOG_FILE=/var/log/usbhook
exec > >(tee -a ${LOG_FILE} )
exec 2> >(tee -a ${LOG_FILE} >&2)

# CONFIGURATION: Source folder
#SRC="/var/www/usb_source"

# CONFIGURATION: Destination folder (this copies contents from usb drive to your public www folder)
DEST="/var/www/html"

DEVICE="$1" # the device name

NUMBER="${DEVICE: -1}"


if [ "$NUMBER" = "1" ]
then
	exit 0
fi

mkdir /tmp/"$DEVICE"

# Mount fat usb drive
mount -t vfat /dev/"$DEVICE"1 /tmp/"$DEVICE"  -o rw,umask=0000

# Copy file TO usb
#cp -R "$SRC"/* /tmp/"$DEVICE"

# Copy files FROM usb
cp -R /tmp/"$DEVICE"/* "$DEST"
chmod 777 -R /tmp/"$DEVICE"

umount /tmp/"$DEVICE"
rm -r /tmp/"$DEVICE"

echo "Copy to $DEVICE  >> Done !"

export DISPLAY=:0
#sudo -u USERNAME notify-send "Copy to $DEVICE >> Done !" -t 5000

exit 0
