
Tixati Manual Installation


System-wide Install
-------------------

You need to be root to complete these steps.

Step 1:
Copy the "tixati" binary executable (the file that is all lower-case) to /usr/bin

Step 2:
Copy the "tixati.png" icon file to /usr/share/icons/hicolor/48x48/apps

Step 3:
Copy the "tixati.desktop" shell-link file to /usr/share/applications .  This will show Tixati on your applications menu.

Step 4:
Issue the following command to update the GTK icon cache:
gtk-update-icon-cache

Step 5:  (optional)
If you want to use magnet-links, issue the following commands:
gconftool-2 --set --type=string /desktop/gnome/url-handlers/magnet/command 'tixati "%s"'
gconftool-2 --set --type=string /desktop/gnome/url-handlers/magnet/enabled true
gconftool-2 --set --type=string /desktop/gnome/url-handlers/magnet/need-terminal false



Single User Install
-------------------

Use this option if you only want to use Tixati for a single user on your system or you don't have admin privileges.

Step 1:
Copy the "tixati" binary executable (the file that is all lower-case) to /home/username/bin , replacing username with your own.

Step 2:
Copy the "tixati.png" icon file to /home/username/.icons .  This directory may be hidden on your system.

Step 3:
Copy the "tixati.desktop" shell-link file to /home/username/.local/share/applications .  This directory may also be hidden.  This will show Tixati on your applications menu.

Step 4:
Issue the following command to update the GTK icon cache:
gtk-update-icon-cache

Step 5:  (optional)
If you want to use magnet-links, issue the following commands:
gconftool-2 --set --type=string /desktop/gnome/url-handlers/magnet/command 'tixati "%s"'
gconftool-2 --set --type=string /desktop/gnome/url-handlers/magnet/enabled true
gconftool-2 --set --type=string /desktop/gnome/url-handlers/magnet/need-terminal false


