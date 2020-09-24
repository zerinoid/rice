# Luke's config for the Zoomer Shell

# Enable colors and change prompt:
autoload -U colors && colors
PS1="%B%{$fg[red]%}[%{$fg[yellow]%}%n%{$fg[green]%}@%{$fg[blue]%}%M %{$fg[magenta]%}%~%{$fg[red]%}]%{$reset_color%}$%b "

RPROMPT="%{$fg[red]%}[%*]%{$reset_color%} "

# History in cache directory:
#HISTSIZE=10000
#SAVEHIST=10000
#HISTFILE=~/.cache/zsh/history

# Basic auto/tab complete:
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)		# Include hidden files.

# vi mode
bindkey -v
export KEYTIMEOUT=1

# Use vim keys in tab complete menu:
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -v '^?' backward-delete-char

# toggle de morderfucking deadkey
bindkey -s '^\' 'dt\n'

# Change cursor shape for different vi modes.
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] ||
     [[ $1 = 'block' ]]; then
    echo -ne '\e[1 q'
  elif [[ ${KEYMAP} == main ]] ||
       [[ ${KEYMAP} == viins ]] ||
       [[ ${KEYMAP} = '' ]] ||
       [[ $1 = 'beam' ]]; then
    echo -ne '\e[5 q'
  fi
}
zle -N zle-keymap-select
zle-line-init() {
    zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
    echo -ne "\e[5 q"
}
zle -N zle-line-init
echo -ne '\e[5 q' # Use beam shape cursor on startup.
preexec() { echo -ne '\e[5 q' ;} # Use beam shape cursor for each new prompt.

# Use lf to switch directories and bind it to ctrl-o
lfcd () {
    [ "$TERM" = "alacritty" ] && TERM=xterm-256color #hack pro alacritty abrir o lf
    tmp="$(mktemp)"
    lf -last-dir-path="$tmp" "$@"
    if [ -f "$tmp" ]; then
        dir="$(cat "$tmp")"
        rm -f "$tmp"
        [ -d "$dir" ] && [ "$dir" != "$(pwd)" ] && cd "$dir"
    fi
}
bindkey -s '^o' 'lfcd\n'

# Edit line in vim with ctrl-e:
autoload edit-command-line; zle -N edit-command-line
#bindkey '^e' edit-command-line

# Load aliases and shortcuts if existent.
[ -f "$HOME/.config/shortcutrc" ] && source "$HOME/.config/shortcutrc"
[ -f "$HOME/.config/aliasrc" ] && source "$HOME/.config/aliasrc"

# =================================
# zsh do leo
# =================================

# fzf search
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# arquivo de alias
[ -f ~/.bash_aliases ] && . ~/.bash_aliases

# arquivo de funções
[ -f ~/.funcrc ] && . ~/.funcrc

# =================================
# CORES BONITAS
# =================================

# Import colorscheme from 'wal' asynchronously
# # &   # Run the process in the background.
# # ( ) # Hide shell job control messages.
# (cat ~/.cache/wal/sequences &)

# To add support for TTYs this line can be optionally added.
source ~/.cache/wal/colors-tty.sh

#color manpages
export LESS_TERMCAP_mb=$'\e[1;31m'     # begin bold
export LESS_TERMCAP_md=$'\e[1;36m'     # begin blink
export LESS_TERMCAP_so=$'\e[1;33;44m'  # begin reverse video
export LESS_TERMCAP_us=$'\e[1;37m'     # begin underline
export LESS_TERMCAP_me=$'\e[0m'        # reset bold/blink
export LESS_TERMCAP_se=$'\e[0m'        # reset reverse video
export LESS_TERMCAP_ue=$'\e[0m'        # reset underline
export GROFF_NO_SGR=1                  # for konsole and gnome-terminal

export MANPAGER='less -s -M -R +Gg'

# Directory coloring
export LS_OPTIONS='--color=auto'
# export LS_COLORS=

# colorize
export ZSH_COLORIZE_STYLE="paraiso-dark"
export LESSOPEN="| /usr/share/source-highlight/src-hilite-lesspipe.sh %s"
export LESS=' -R '
# export LESSOPEN='|~/.lessfilter %s'


# History
export HISTFILE="$HOME/.zsh_history"
export HISTSIZE=1000000
export SAVEHIST=$HISTSIZE

# =================================
# OPTIONS
# =================================

setopt autocd
setopt append_history           # Dont overwrite history
setopt extended_history         # Also record time and duration of command    s.
setopt inc_append_history
setopt share_history            # Share history between multiple shells
setopt no_beep
setopt no_hist_beep
setopt no_list_beep
setopt hist_ignore_all_dups
setopt hist_ignore_space


# Common aliases
alias ls="ls $LS_OPTIONS"
#alias ll="ls $LS_OPTIONS -lAhFtr"
#alias ccat="pygmentize -O style=monokai -f 256 -g"
alias dig="dig +nocmd any +multiline +noall +answer"

# Common CTRL bindings.
bindkey "^a" beginning-of-line
bindkey "^e" end-of-line
bindkey "^[[1;3C" forward-word
bindkey "^[[1;3D" backward-word
bindkey "^k" kill-line
bindkey "^d" delete-char
bindkey "^y" push-line-or-edit
bindkey "^[^?" backward-kill-word
bindkey "^u" backward-kill-line
bindkey "^_" undo

# Do not require a space when attempting to tab-complete.
bindkey "^i" expand-or-complete-prefix

# ctrl left/right
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

# zsh-autosuggestions
bindkey "^ " autosuggest-accept

# funções especiais para back/forward baseados na pasta "/"
backward-kill-dir () {
    local WORDCHARS=${WORDCHARS_/\/}
    zle backward-kill-word
}
zle -N backward-kill-dir
bindkey '^w' backward-kill-dir

backward-word-dir () {
    local WORDCHARS="${WORDCHARS_/\/}"
    zle backward-word
}
zle -N backward-word-dir
bindkey "^b" backward-word-dir

forward-word-dir () {
    local WORDCHARS="${WORDCHARS_/\/}"
    zle forward-word
}
zle -N forward-word-dir
bindkey "^f" forward-word-dir


### Added by Zplugin's installer
source "$HOME/.zplugin/bin/zplugin.zsh"
autoload -Uz _zplugin
(( ${+_comps} )) && _comps[zplugin]=_zplugin
### End of Zplugin installer's chunk

# ===========================
# zplugin
# ===========================

# Load OMZ Git library
zplugin snippet OMZ::lib/git.zsh

# Load Git plugin from OMZ
# zplugin snippet OMZ::plugins/git/git.plugin.zsh
zplugin cdclear -q # <- forget completions provided up to this moment

setopt promptsubst

# Load theme from OMZ
#zplugin snippet OMZ::themes/dstufft.zsh-theme

# Load syntax and autosuggestions
zplugin light zsh-users/zsh-autosuggestions
zplugin light zdharma/fast-syntax-highlighting
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=244,bold"

# Load fzf and options
zplugin ice from"gh-r" as"program"
zplugin load junegunn/fzf-bin

  export FZF_DEFAULT_OPTS="--height 40% --reverse --border --inline-info --color=dark,bg+:235,hl+:10,pointer:5"
  export FZF_DEFAULT_COMMAND='fd'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# Load diff-so-fancy
# zplugin ice as"program" pick"bin/git-dsf"
# zplugin light zdharma/zsh-diff-so-fancy

# Load oh-my-zsh plugins
zplugin snippet OMZ::plugins/command-not-found/command-not-found.plugin.zsh
zplugin snippet OMZ::plugins/colorize/colorize.plugin.zsh
zplugin snippet OMZ::plugins/nvm/nvm.plugin.zsh
zplugin snippet OMZ::plugins/cp/cp.plugin.zsh
zplugin snippet OMZ::plugins/docker/_docker
zplugin snippet OMZ::plugins/docker-compose/_docker-compose

# Load larkery/zsh-histdb
zplugin load larkery/zsh-histdb

source $HOME/.zplugin/plugins/larkery---zsh-histdb/sqlite-history.zsh
autoload -Uz add-zsh-hook
add-zsh-hook precmd histdb-update-outcome

# Usar histdb para sugestões do autosuggest
_zsh_autosuggest_strategy_histdb_top_here() {
    local query="select commands.argv from
history left join commands on history.command_id = commands.rowid
left join places on history.place_id = places.rowid
where places.dir LIKE '$(sql_escape $PWD)%'
and commands.argv LIKE '$(sql_escape $1)%'
group by commands.argv order by count(*) desc limit 1"
    suggestion=$(_histdb_query "$query")
}

ZSH_AUTOSUGGEST_STRATEGY=histdb_top_here

# Load enhancd
zplugin ice pick"init.sh"
zplugin light b4b4r07/enhancd
ENHANCD_FILTER="fzf"
ENHANCD_COMMAND="c"

fpath+=${ZDOTDIR:-~}/.zsh_functions
