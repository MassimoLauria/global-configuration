#!/bin/sh


if [[ $# -ne 2 ]]; then
    echo "Usage $0 <hostname> <pubkey>"
    exit 1
fi


echo "Sending pubkey $2 to host $1"
cat $2 | ssh $1 "mkdir -p ~/.ssh; cat >> ~/.ssh/authorized_keys"
exit 0
