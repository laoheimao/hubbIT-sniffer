#!/usr/bin/env bash
# This script set ups the monitoring interface required for hubbit-sniffer

if [[ -z "$1" ]]; then
    exit 1
else
    iface=hubbit-$1
fi

# Check if root
if [ $(id -u) -ne 0 ]; then
    echo "You need to be root..."
    exit 1
fi

if ip link show dev $iface &>/dev/null; then
    echo "iface $iface already exists. Deleting the old one"
    ip link set down dev $iface
    iw dev $iface del
fi

echo Creating new virtual monitor interface $iface
iw phy $1 interface add $iface type monitor
# Promiscious mode allows the interface to pickup traffic not intended for "us"
ip link set promisc on dev $iface
ip link set up dev $iface
