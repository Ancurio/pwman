#!/bin/bash

# Move to script's directory
cd "`dirname "$0"`"

if [ -f db ]; then
	echo "Database (db) already exists."
	exit
fi

stty -echo
read -p "Enter passphrase: " PHRASE
echo ""
read -p "Repeat passphrase: " PHRASE_REP
echo ""
stty echo
echo ""

if [ "$PHRASE" != "$PHRASE_REP" ]; then
	echo "Passphrases don't match"
	exit
fi

echo "" | gpg -q --batch --yes --passphrase-file <(echo "${PHRASE}") -c -o db 2> /dev/null

echo "Database created."
