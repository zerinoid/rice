#Bash alias file

# apt
alias \
    aph="apt search"\
	aps="sudo apt install"\
	apd="sudo apt update"\
    apdl="apt list --upgradable"\
	apg="sudo apt upgrade"\
    apr="sudo apt remove"\
    apf="apt-file search"

# ls
alias \
    l="ls -lFh"\
    la="ls -lAFh"\
    lr="ls -tRFh"\
    lt="ls -ltFH"\
    ll="ls -l"\
    ldot="ls -ld .*"\
    lS="ls -1FSsh"\
    lart="ls -1Fcart"\
    lrt="ls -1Fcrt"

# GNU/unix
alias \
    op="xdg-open"\
	rm="rm -v"\
	cp="cp -iv"\
	mv="mv -iv"\
    t="tail -f"\
    sudo="sudo "\
	grep="grep --color=auto"\
	egrep="egrep --color=auto"\
	fgrep="fgrep --color=auto"\
    sgrep="grep -R -n -H -C 5 --exclude-dir={.git,.svn,CVS}"\
    purge="sudo sync && echo 3 > /proc/sys/vm/drop_caches"

# customizations
alias \
    cfz="vim $ZDOTDIR/.zshrc"\
    sxh="vim ~/.config/sxhkd/sxhkdrc"\
    bsp="vim ~/.config/bspwm/bspwmrc"\
	ba="vim ~/.bash_aliases"\
    pol="vim ~/.config/polybar/config.ini"\
    xdf="vim ~/.Xdefaults"\

# du
alias \
    ducks="du -cks * | sort -rn | head"\
    dud="du -d 1 -h"\
    dush="du -sh"\
    dux="du -hsx * | sort -rh | head -n 40"\
    dfth="df -Th | grep -e ^/dev -e Filesystem | grep -v loop"

# development
alias \
	doc="docker-compose exec workspace"\
	ngso="ng s --open"\
	pas="php artisan serve"\
	nrw="npm run watch"

# git
alias \
    gam="git commit -am"\
    ga="git add" \
    gc="git commit -m"\
    gs="git status"\
    gp="git push"\
    gf="git pull"\

# dotfiles git
alias \
    dit='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'\
    gdc="dit commit -m"\
    ds="dit status"\
    dp="dit push"\
    gdf="dit pull"\
	dam="dit commit -am"

# beets
alias \
    bls="beet ls"\
    bla="beet ls -a"\
    bf="find ~/music -mindepth 2 -type d -mtime 0 -exec beet import {} +; -exec beet embedart -y {} +"\
    bw="beet write"

# with config
alias \
    w3m="w3m -config ~/.config/w3m/config"\
    mpdas="mpdas -c ~/.config/mpdasrc"

# misc
alias \
    v="vim"\
    nmset="rfkill block wlan; sleep 3; rfkill unblock wlan"\
    pbc="xclip -selection clipboard"\
	pbp="xclip -selection clipboard -o"\
    ytv="straw-viewer --player=mpv"\
    ffmpeg="ffmpeg -hide_banner"\
    trem="transmission-remote" \
    mp3tag="wine ~/fixo/progs/mp3tag/Mp3tag.exe"\
	kbd="setxkbmap -model abnt2 -layout br\
		-option caps:escape"\
	kbn="setxkbmap -model abnt2 -layout br\
		-option caps:escape\
        -variant nodeadkeys"
