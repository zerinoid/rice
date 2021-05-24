#!/bin/sh

if ! updates=$(apt list --upgradable 2> /dev/null | grep -ivc listing); then
    updates=0
fi

if [ "$updates" -gt 0 ]; then
    echo "$updates"
else
    echo ""
fi
