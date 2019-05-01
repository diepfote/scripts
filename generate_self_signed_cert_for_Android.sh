#!/usr/bin/env bash

cd $1

# generate cert.pem and key.pem
openssl req -x509 -newkey rsa:4096 -nodes -out cert.pem -keyout key.pem -days 365
# generate CA.pem
openssl req -new -days 365 -key key.pem  -out CA.pem

options_file=options.cnf
# for Android root CA
echo 'basicConstraints=CA:true' > $options_file

# generate crt file
openssl x509 -req -days 365 -in CA.pem  -signkey key.pem  -extfile $options_file -out CA.crt
# convert to DER format for Android
openssl x509 -inform PEM -outform DER -in CA.crt -out CA.der.crt

