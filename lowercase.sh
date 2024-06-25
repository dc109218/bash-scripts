#!/usr/bin/env bash
echo -n "Enter String Uppercase: "
read -r i
lowercase=$(echo "$i" | tr '[:upper:]' '[:lower:]')
echo "Lowercase: $lowercase"
