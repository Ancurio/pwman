#!/bin/bash

# Move to script's directory
cd "`dirname "$0"`"

if [ "$#" -ge 1 ]; then
	KEY=$1
else
	read -p "Enter key: " KEY
fi

stty -echo
read -p "Enter passphrase: " PHRASE
stty echo
echo ""

# Check if passphrase is correct by doing a dummy decrypt
gpg -q --batch --passphrase-file <(echo "${PHRASE}") -d "db" 2> /dev/null > /dev/null

# If gpg exited with anything but 0, the decryption failed
# and the passphrase must be wrong
if [ $? -ne 0 ]; then
	echo "Error: Bad passphrase?"
	echo ""
	exit
fi

RESULT=`gpg -q --batch --passphrase-file <(echo "${PHRASE}") -d "db" 2> /dev/null | grep -if <(echo "${KEY}")`

if [[ $RESULT = "" ]]; then
    echo ""
    echo "(No results found)"
    exit
fi

echo -e "\n$RESULT\n"
