#!/bin/bash

openssl genrsa -out passwordPrivKey.pem 2048
openssl rsa -in passwordPrivKey.pem -out passwordPubKey.pem -outform PEM -pubout

echo -n "password" > PASSWORD

# To encrypt
openssl rsautl -encrypt -inkey passwordPubKey.pem -pubin -in PASSWORD -out PASSWORD.dat

# To decrypt
DECRYPTED=$(openssl rsautl -decrypt -inkey ./passwordPrivKey.pem -in PASSWORD.dat)
echo $DECRYPTED