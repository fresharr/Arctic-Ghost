#!/bin/bash

#Script for Drone40
#Created by Matt Arrison
#echo "kalipass" | sudo -S ./deauth-0.sh
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
sleep 20 #can change values based on how long it will it take to get into place
echo "ATTACK!!"
sleep 10

switch="0"

time=20
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

cd #back to home directory
sudo airmon-ng start wlan0 #scan networks

#check if switch == 1
if [ $switch == 1 ]
then
	echo "Abort mission..."
else

	timeout $time sudo airodump-ng -w bigData --output-format csv wlan0
	echo "Your data file has been created in the ~ directory"
	echo "Select the Wi-Fi to you wish to attack..."
fi

# There are 2 options for this attack:

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
