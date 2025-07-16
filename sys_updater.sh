#!/bin/bash


if [ $USER != root ]; then
  echo "Error: must be root"
  exit 0
fi

# go to root directory
cd ~

echo "Updating"
sudo apt-get update
sudo apt-get upgrade

echo "Removing old packages"
sudo apt-get autoremove

echo "Cleaning apt cache..."
sudo apt-get clean

echo "Removing old files..."
sudo apt-get purge

echo "Emptying every trashes..."
rm -rf /home/*/.local/share/Trash/*/** &> /dev/null
rm -rf /root/.local/share/Trash/*/** &> /dev/null

echo "Removing file \".bash_history\" ..."
rm .bash_history

echo -n "Do you want to upgrade your distribution? (y/n): "
  read dist
  case $dist in
     y)
      sudo apt dist-upgrade 
      sudo do-release-upgrade
      ;;
     *)
      echo -n -e "Distribution not upgraded.\n"
      ;;
  esac  

echo "Script finished"

