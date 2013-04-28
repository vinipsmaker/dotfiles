# Check for an interactive session
[ -z "$PS1" ] && return

alias ls='ls --color=auto'
alias grep='grep -I'
alias vino-server='/usr/lib/vino/vino-server'
alias youtube='youtube-dl -f 43 -l'
alias mplayer='mplayer -ao pulse'
alias aplayer='mplayer -vo none'
#PS1='[\u@\h \W]\$ '

. /usr/share/git/completion/git-completion.bash
. /usr/share/git/completion/git-prompt.sh
GIT_PS1_SHOWDIRTYSTATE=false
PS1='\[\e[0;32m\]\u\[\e[m\] \[\e[1;34m\]\w\[\e[m\]$(__git_ps1) \[\e[1;32m\]\$\[\e[m\] \[\e[1;37m\]'
export BROWSER='firefox'
export EDITOR='nano'
export PAGER='less'
export VISUAL='emacs'

export HISTCONTROL='ignoredups::ignorespace'

export _JAVA_OPTIONS='-Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel'
export JAVA_FONTS=/usr/share/fonts/TTF

export MPD_HOST='ilovepunkrock@localhost'

complete -cf sudo
complete -cf man
complete -cf killall
complete -cf which

if [[ -z $DISPLAY && $XDG_VTNR -le 3 ]]; then
    exec startx
else
    fortune -c
fi
