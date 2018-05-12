#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "Usage: ${0} [db to merge in]"
    exit
fi

# Save full path to foreign db file before we switch directories
TO_MRG=$(realpath "${1}")

# Move to script's directory
cd "`dirname "$0"`"

# Read in passphrase
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

sort <(gpg -q --batch --passphrase-file <(echo "${PHRASE}") -d "${1}" 2> /dev/null) \
     <(gpg -q --batch --passphrase-file <(echo "${PHRASE}") -d db 2> /dev/null) \
     | uniq | gpg -q --yes --passphrase-file <(echo "${PHRASE}") -c -o db.new 2> /dev/null
     
mv db.new db
