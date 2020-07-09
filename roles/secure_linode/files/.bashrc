# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

## >> ALIASES 
alias l='ls -AlhF --color=yes --group-directories-first'
alias grep='grep --color=auto'
alias rm='rm -i'
alias lservices='systemctl list-unit-files --type=service'
alias quicksniff='tcpdump -s0 -n -w ~/$(date +%Y%m%d)-$HOSTNAME-capture.pcap -i' $1
alias walk='snmpwalk -Os -v2c -c public $1'

## >> ENV EXPORTS
export TERM=screen-256color

# Configure Bash History
# append to the history file, don't overwrite it
mkdir -p ~/bash_history
shopt -s histappend
export HISTFILE=~/bash_history/.bash_history-$(hostname)-$(date +%Y-%m).log
export HISTSIZE=10000
export HISTFILESIZE=100000
export HISTCONTROL=ignoredups
export HISTTIMEFORMAT='%F %T '

## >> Tweaks
# Turn on recursive globbing (enables ** to recurse all directories)
shopt -s globstar 2> /dev/null

# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob;

## SMARTER TAB-COMPLETION (Readline bindings) ##

# Perform file completion in a case insensitive fashion
bind "set completion-ignore-case on"

# Treat hyphens and underscores as equivalent
bind "set completion-map-case on"

# Display matches for ambiguous patterns at first tab press
bind "set show-all-if-ambiguous on"

## >> FUNCTIONS
function file {
/usr/bin/file $1
echo "Real path: $(/bin/readlink -f $1)"
}

function return-limits {
    
    for process in $@; do
        process_pids=`ps -C $process -o pid --no-headers | cut -d " " -f 2`
        
        if [ -z $@ ]; then
            echo "[no $process running]"
        else
            for pid in $process_pids; do
                echo "[$process #$pid -- limits]"
                cat /proc/$pid/limits
            done
        fi
        
    done
}

function colors_all {
x=`tput op` 
y=`printf %76s`
for i in {0..256}
do 
    o=00$i
    echo -e ${o:${#o}-3:3} `tput setaf $i;tput setab $i`${y// /=}$x
done
}

function genpass {
echo -n "Date + sha512sum: "
date +%s | gsha512sum | base64 | head -c 32 ; echo

echo -n "OpenSSL Random: "
openssl rand -base64 32
}

function colors_palette {
FGNAMES=(' black ' '  red  ' ' green ' ' yellow' '  blue ' 'magenta' '  cyan ' ' white ')
BGNAMES=('DFT' 'BLK' 'RED' 'GRN' 'YEL' 'BLU' 'MAG' 'CYN' 'WHT')
echo "     ----------------------------------------------------------------------------"
for b in $(seq 0 8); do
    if [ "$b" -gt 0 ]; then
        bg=$(($b+39))
    fi

    echo -en "\033[0m ${BGNAMES[$b]} : "
    for f in $(seq 0 7); do
        echo -en "\033[${bg}m\033[$(($f+30))m ${FGNAMES[$f]} "
    done
    echo -en "\033[0m :"

    echo -en "\033[0m\n\033[0m     : "
    for f in $(seq 0 7); do
        echo -en "\033[${bg}m\033[1;$(($f+30))m ${FGNAMES[$f]} "
    done
    echo -en "\033[0m :"
    echo -e "\033[0m"

    if [ "$b" -lt 8 ]; then
        echo "     ----------------------------------------------------------------------------"
    fi
done
echo "     ----------------------------------------------------------------------------"
}

# Set Bash Prompt
export PS1='[\u@\[\033[38;5;197m\]\h \[\e[1;37m\]\w\[\e[0m\]]$ '
