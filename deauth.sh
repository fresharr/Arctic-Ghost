#!/bin/bash

#Script for Drone40
#Created by Matt Arrison
#echo "kronos3220" | sudo -S ./deauth.sh
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
fi

cd ..sudo airmon-ng start wlan0
#check if switch == 1
if [ $switch == 1 ]
then
	echo "Abort mission..."
else
	timeout $time sudo airodump-ng -w bigData --output-format csv wlan0

fi

#***Figure out how to STOP SCAN once within range of target***

