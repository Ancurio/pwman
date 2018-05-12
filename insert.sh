#!/bin/bash

# Move to script's directory
cd "`dirname "$0"`"

read -p "entry: " ENTRY

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

# Use gpg to decrypt the db into a stream, concat this stream
# with the new password entry, and direct the resulting stream
# back into gpg for re-encryption. No temp files are used,
# but the original file is not overwritten.
cat <(gpg -q --batch --passphrase-file <(echo "${PHRASE}") -d "db" 2> /dev/null) \
    <(echo "${ENTRY}") \
| gpg -q --batch --yes --passphrase-file <(echo "${PHRASE}") -c -o db.new 2> /dev/null

mv db.new db
