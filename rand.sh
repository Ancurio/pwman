#!/bin/bash

read -p "len: " LEN
echo ""

# Generate a random password from system entropy
tr -cd '[:alnum:]' < /dev/urandom | fold -w$LEN | head -n1
echo ""
