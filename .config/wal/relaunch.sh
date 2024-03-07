#!/bin/sh

pkill -x dunst && dunst
emacsclient -s $EMACS_SERVER_SOCKET -e "(load-theme 'ewal-spacemacs-modern t)"
