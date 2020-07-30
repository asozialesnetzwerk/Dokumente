#!/bin/bash
TEMP=$(mktemp)
WIDTH=60
HEIGHT=10
cat <<EOF >/etc/dialogrc
screen_color = (YELLOW,BLACK,ON)
use_shadow = OFF
EOF

BACKTITLE="ATA-E-Mail-Master-Skript"

function add_acc(){
	
	#ifnotexist
	MCFG="$HOME/.msmtprc"
	if [ ! -f "$MCFG" ]; then
        newcfg="true"
        touch $MCFG
        echo "defaults" >> $MCFG
        echo "auth           on" >> $MCFG
        echo "tls            on" >> $MCFG
        echo "tls_trust_file /etc/ssl/certs/ca-certificates.crt" >> $MCFG
        echo "logfile        ~/.msmtp.log" >> $MCFG
    fi

    a="account"
    b="smtp.gmail.com"
    c="587"
    d="username@gmail.com"
    e="username"
    f=" "
    echo "$(dialog --backtitle "${BACKTITLE}" \
    --colors --title "Mail-Account hinzufügen" \
    --stdout --form "Überprüfe eventuell bei deinem Mailprovider, was in welche Felder gehört.  \n\
account ist eine frei wählbare Bezeichnung.  \n\
user ist eventuell immer das, was vor dem @ steht?" $((${HEIGHT}*2)) ${WIDTH} 6 \
    "account        " 1 1 "$a" 1 $((${WIDTH}/3)) $((${WIDTH}/2)) 0 \
    "SMTP-Host      " 2 1 "$b" 2 $((${WIDTH}/3)) $((${WIDTH}/2)) 0 \
    "SMTP-Port      " 3 1 "$c" 3 $((${WIDTH}/3)) $((${WIDTH}/2)) 0 \
    "E-Mail-Adresse " 4 1 "$d" 4 $((${WIDTH}/3)) $((${WIDTH}/2)) 0 \
    "user           " 5 1 "$e" 5 $((${WIDTH}/3)) $((${WIDTH}/2)) 0 \
    "E-Mail-Passwort" 6 1 "$f" 6 $((${WIDTH}/3)) $((${WIDTH}/2)) 0)" > "$TEMP"
    
    a=$(cat "$TEMP" | head -1)
    b=$(cat "$TEMP" | head -2 | tail -1)
    c=$(cat "$TEMP" | head -3 | tail -1)
    d=$(cat "$TEMP" | head -4 | tail -1)
    e=$(cat "$TEMP" | head -5 | tail -1)
    f=$(cat "$TEMP" | head -6 | tail -1)

    echo "" >> $MCFG
    echo "# Generated with ATA-Masterskript: $a" >> $MCFG
    echo "account        $a" >> $MCFG
    echo "host           $b" >> $MCFG
    echo "port           $c" >> $MCFG
    echo "from           $d" >> $MCFG
    echo "user           $e" >> $MCFG
    echo "password       $f" >> $MCFG     
    
    if [ ! -z $newcfg ]; then
        echo "# Set a default account" >> $MCFG
        echo "account default : $a" >> $MCFG
    fi
    
	return 1
}



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

