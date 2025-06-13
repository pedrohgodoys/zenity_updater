#! /bin/bash

# https://askubuntu.com/questions/314395/proper-way-to-let-user-enter-password-for-a-bash-script-using-only-the-gui-with
# https://unix.stackexchange.com/questions/80981/how-to-make-my-bash-script-look-100-like-a-gui-app-so-user-never-sees-terminal?noredirect=1#comment119643_80981

# sudo dnf update -y &&  && sudo dnf clean dbcache -y && sudo dnf autoremove -y

PASSWD="$(zenity --password --title=Authentication)"

(
echo "20" ; sleep 1
echo "# DNF packages" ;
echo $PASSWD | sudo -S dnf update -y && echo "DNF UPDATE OK" && echo "40"; sleep 1

echo "# Flatpaks" ;
flatpak update -y && echo "FLATPAK UPDATE OK" && echo "60" ; sleep 1

echo "# Dbcache clean-up" ;  
echo $PASSWD | sudo -S dnf clean dbcache -y && echo "DBCACHE OK" && echo "80" ; sleep 1

echo "# Housekeeping" ;
echo $PASSWD | sudo -S dnf autoremove -y && echo "AUTOREMOVE OK" && echo "100" ; sleep 1

echo "# All done";
) |
zenity --progress \
        --title="Update System" \
        --pulsate \
        --auto-close \
        --percentage=0

if [ "$?" = -1 ] ; then
        zenity --error \
          --text="Update canceled."
fi


