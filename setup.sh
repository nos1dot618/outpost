#!/usr/bin/env bash
set -xeuo pipefail

sudo apt-get update
sudo apt-get install -y libssl-dev

mkdir -p "creds/"
openssl genpkey \
        -algorithm RSA \
        -out "creds/http_server.key" \
        -pkeyopt rsa_keygen_bits:2048
# Generate a self signed certificate.
openssl req \
        -new -x509 \
        -key "creds/http_server.key" \
        -out "creds/http_server.crt" \
        -days 365 \
        -subj "/CN=localhost"
