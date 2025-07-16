#!/bin/bash
# Basically for live boot distributions when I want to use a program that is not installed by default


echo -n "Type the language to use (es, en, jp): "
read LANGUAGE

case $LANGUAGE in

  es) # Spanish Layout, es_ES.UTF-8
    setxkbmap -layout es
    sudo service keyboard-setup restart
    ;;

  en) # English Layout, en_US.UTF-8
    setxkbmap -layout us
    sudo service keyboard-setup restart
    ;;

  jp) # Japanese Layout, ja_JP.UTF-8
    setxkbmap -layout jp
    sudo service keyboard-setup restart
    ;;

  *)
    echo -n -e "Language not supported in the script\n"
    ;;
esac
  
### Dev Stuff
echo -n "Do you want to install dev tools? (y/n)"
read answer
if [ $answer = "y" ] ; then

  echo -n "Do you want to add spanish to latex? (y/n)"
  read answer
  case $answer in
     y)
       sudo apt-get update
       sudo apt-get install texlive-lang-spanish
       echo -n "Hasta la vista."
       exit 0
       ;;
     *)
       echo -n -e "LaTex not updated.\n"
       ;;
  esac  
  
  echo -n "Do you want to configure GCM? (y/n)"
  read answer
  case $answer in
     y)
       echo -n -e "Updating credentials with GCM.\n"
       # wget
       # sudo dpkg -i <path> git-credential-manager configure
       echo -n "Hasta la vista."
       exit 0
       ;;
     *)
       echo -n -e "GCM credentials not updated.\n"
       ;;
  esac

  ### https://github.com/tmux/tmux/wiki
#  echo -n "Do you want to install tmux? (y/n)"
#  read answer
#  case $answer in
#     y)
#      sudo apt-get install tmux
#      ;;
#     *)
#      echo -n -e "Tmux not installed.\n"
#      ;;
#  esac
     
  #### https://lynx.browser.org/
  echo -n "Do you want to install Lynx? (y/n): "
  read lynx
  case $lynx in
     y)
      sudo apt-get update
      sudo apt-get -y install lynx
      ;;
     *)
      echo -n -e "Lynx not installed.\n"
      ;;
  esac
  
  #### https://lisp-lang.org/
  echo -n "Do you want to install Lisp? (y/n): "
  read lisp
  case $lisp in
     y)
      sudo apt-get update 
      sudo apt-get -y install sbcl
      ;;
     *)
      echo -n -e "Lisp not installed.\n"
      ;;
  esac  
  
  ### https://www.libsdl.org/
  ### https://lazyfoo.net/SDL_tutorials/index.php
  ### https://trenki2.github.io/blog/2017/06/02/using-sdl2-with-cmake/
  echo -n "Do you want to install SDL2? (y/n): "
  read answer
  case $answer in
     y)
       sudo apt-get update
       sudo apt-cache search libsdl2
       sudo apt-get install libsdl2-dev
       sudo apt-get install libsdl2-image-dev
       # usr/bin/sdl2-config
      ;;
     *)
       echo -n -e "SDL2 not installed.\n"
      ;;
  esac
  
   ### https://docs.blender.org/manual/en/latest/getting_started/about/index.html
#  echo -n "Do you want to install Blender? (y/n): "
#  read answer
#  case $answer in
#     y)
#       sudo apt install snapd
#       systemctl start snapd.service
#       systemctl enable --now snapd.apparmor
#       sudo snap install blender --classic
#      ;;
#     *)
#       echo -n -e "Blender not installed.\n"
#      ;;
#  esac
fi

### Optional stuff
echo -n "Do you want to install miscelanea? (y/n): "
read "answer"
if [ $answer = "y" ] ; then

    #### https://snapcraft.io/install/vlc/ubuntu
    echo -n "Do you want to install VLC? (y/n): "
    read VLC

    case $VLC in

      y)
        sudo apt-get update
        sudo apt install snapd
        sudo snap install vlc
        ;;
    
      *)
        echo -n -e "VLC not installed.\n"
        ;;
    esac

    #### https://calibre-ebook.com/es/download_linux
    echo -n "Do you want to install calibre? (y/n): "
    read calibre

    case $calibre in

      y)
        sudo  -v && wget -nv -O- https://download.calibre-ebook.com/linux-installer.sh | sudo sh /dev/stdin
        ;;
    
      *)
        echo -n -e "Calibre not installed.\n"
        ;;
    esac

fi

echo "OK, bye!"
