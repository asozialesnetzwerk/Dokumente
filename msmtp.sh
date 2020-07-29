#!/bin/bash
TEMP=$(mktemp)
WIDTH=60
HEIGHT=10
cat <<EOF >/etc/dialogrc
screen_color = (YELLOW,BLACK,ON)
use_shadow = OFF
EOF

BACKTITLE="ATA-E-Mail-Master-Skript"




#if git clone newer than..
updates=""
while true
do
cat <<EOF >/etc/dialogrc
screen_color = (YELLOW,BLACK,ON)
use_shadow = OFF
EOF
    case $(IFS="_"; dialog --keep-tite --output-fd 1 --no-ok --no-cancel --backtitle "${BACKTITLE}" \
    --colors --title "Hauptmenü" \
    --menu "Du kannst mit Pfeiltasten, Nummerntasten oder den rot markierten Hotkeys einen Menüpunkt wählen. \n\
Drücke die Entertaste, um die gewählte Funktion aufzurufen." $((${HEIGHT}*2)) ${WIDTH} 4 \
    ACC "Mail-Account hinzufügen" \
    TEST "Mail-Konfiguration testen" \
    ATA "ATA ausüben" \
    Exit "Skript verlassen") in
	ACC) add_acc; unset IFS;;
	TEST) test_mail;;
	ATA) choose_ata;;
	Exit) echo "Bye!"; break;;
    esac
done

