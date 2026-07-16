#!/bin/sh

if command -v apt >/dev/null 2>&1; then
    updates=$(apt list --upgradable 2> /dev/null | grep -ivc listing)
elif command -v checkupdates >/dev/null 2>&1; then
    updates=$(checkupdates 2>/dev/null | wc -l)
elif command -v dnf >/dev/null 2>&1; then
    updates=$(dnf check-update -q 2>/dev/null | grep -v '^$' | wc -l)
elif command -v xbps-install >/dev/null 2>&1; then
    updates=$(xbps-install -un 2>/dev/null | wc -l)
else
    updates=0
fi

if [ -n "$updates" ] && [ "$updates" -gt 0 ] 2>/dev/null; then
    echo "#$updates"
else
    echo ""
fi
