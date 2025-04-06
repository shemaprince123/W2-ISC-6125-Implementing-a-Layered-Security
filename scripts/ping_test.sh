#!/bin/sh
# This will generate ICMP traffic which should trigger our ping alert
echo "Sending ping to webserver..."
ping -c 10 webserver
echo "Done."
