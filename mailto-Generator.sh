#Generiert aus einer E-Mail-Adressen-Liste mailto-Links für Massenmails und Blindkopien.
#Parameter: Dateiname der einzulesenden Liste mit untereinander aufgelisteten E-Mail-Adressen
#./mailto-Generator.sh liste.txt
#Stand 29.07.2020

file="MAILTO.md"

tr '\n' ';' < "$1" > $file
sed -i '1s/^/([Massenmail](mailto:/' $file
sed -i '$s/$/) [Blindkopie](mailto:/' $file

tr '\n' ';' < "$1" >> $file
sed -i '$s/$/))/' $file

