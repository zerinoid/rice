#Bash alias file
alias aph="apt search"\
	aps="sudo apt install"\
	apd="sudo apt update"\
    apdl="apt list --upgradable"\
	apg="sudo apt upgrade"\
    apr="sudo apt remove"\
    apf="apt-file search"\
	op="xdg-open"\
	rm="rm -v"\
	cp="cp -iv"\
	mv="mv -iv"\
    sudo="sudo "\
    v="vim"\
	grep="grep --color=auto"\
	egrep="egrep --color=auto"\
	fgrep="fgrep --color=auto"\
    sgrep="grep -R -n -H -C 5 --exclude-dir={.git,.svn,CVS}"\
	cfz="vim $ZDOTDIR/.zshrc"\
    sxh="vim ~/.config/sxhkd/sxhkdrc"\
    bsp="vim ~/.config/bspwm/bspwmrc"\
	ba="vim ~/.bash_aliases"\
    pol="vim ~/.config/polybar/config.ini"\
    xdf="vim ~/.Xdefaults"\
    purge="sudo sync && echo 3 > /proc/sys/vm/drop_caches"\
    pbc="xclip -selection clipboard"\
	pbp="xclip -selection clipboard -o"\
	ducks="du -cks * | sort -rn | head"\
    dud="du -d 1 -h"\
    dush="du -sh"\
    dux="du -hsx * | sort -rh | head -n 40"\
    dfth="df -Th | grep -e ^/dev -e Filesystem | grep -v loop"\
    t="tail -f"\
	doc="docker-compose exec workspace"\
	ngso="ng s --open"\
	pas="php artisan serve"\
	nrw="npm run watch"\
	gam="dit commit -am"\
    ga="dit add" \
    gc="dit commit -m"\
    gs="dit status"\
    gp="dit push"\
    gf="dit pull"\
    gd="dit difftool"\
    ytv="straw-viewer --player=mpv"\
    ffmpeg="ffmpeg -hide_banner"\
	kbd="setxkbmap -model abnt2 -layout br\
		-option caps:escape"\
	kbn="setxkbmap -model abnt2 -layout br\
		-option caps:escape\
        -variant nodeadkeys"\
    bls="beet ls"\
    bla="beet ls -a"\
    bf="find ~/music -mindepth 2 -type d -mtime 0 -exec beet import {} +; -exec beet embedart -y {} +"\
    bw="beet write"\
    lsb="lsblk | grep -v loop" \
    trem="transmission-remote" \
    w3m="w3m -config ~/.config/w3m/config"\
    mpdas="mpdas -c ~/.config/mpdasrc"\
    nmset="rfkill block wlan; sleep 3; rfkill unblock wlan"\
    dit='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'

alias l="ls -lFh"\
    la="ls -lAFh"\
    lr="ls -tRFh"\
    lt="ls -ltFH"\
    ll="ls -l"\
    ldot="ls -ld .*"\
    lS="ls -1FSsh"\
    lart="ls -1Fcart"\
    lrt="ls -1Fcrt"\
