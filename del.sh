#!/bin/bash

# Move to script's directory
cd "`dirname "$0"`"

read -p "Enter key: " KEY

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

RESULT=`gpg -q --batch --passphrase-file <(echo "${PHRASE}") -d "db" 2> /dev/null | grep -if <(echo $KEY)`

echo "The following entries will be deleted:"
echo -e "\n$RESULT\n"

read -p "Are you sure? [yes/no]: " CONF

if [[ $CONF = "yes" ]]; then
    gpg -q --batch --passphrase-file <(echo "${PHRASE}") -d "db" 2> /dev/null \
    | grep -vif <(echo $KEY) \
    | gpg -q --batch --yes --passphrase-file <(echo "${PHRASE}") -c -o db.new 2> /dev/null
    mv db.new db
fi
