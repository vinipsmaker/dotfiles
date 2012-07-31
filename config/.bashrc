# Check for an interactive session
[ -z "$PS1" ] && return

alias ls='ls --color=auto'
alias nautilus='nautilus --no-desktop'
#PS1='[\u@\h \W]\$ '

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
