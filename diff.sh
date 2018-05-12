#!/bin/bash

if [ "$#" -ne 2 ]; then
    echo "Usage: ${0} [db1] [db2]"
    exit
fi

# Read in passphrase
stty -echo
read -p "Enter passphrase: " PHRASE
stty echo
echo ""

diff -u <(gpg -q --batch --passphrase-file <(echo "${PHRASE}") -d "${1}" 2> /dev/null | sort) \
        <(gpg -q --batch --passphrase-file <(echo "${PHRASE}") -d "${2}" 2> /dev/null | sort) \
	| less
