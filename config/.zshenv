# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=4096
SAVEHIST=4096
# End of lines configured by zsh-newuser-install

export PATH="$PATH:$HOME/bin"

export BROWSER='firefox'
export EDITOR='nano'
export PAGER='less'
export VISUAL='emacs'

export GCC_COLORS=auto

export _JAVA_OPTIONS='-Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel'
export JAVA_FONTS=/usr/share/fonts/TTF

export RPG2K_RTP_PATH=~/Jogos/RTP/2000
export RPG2K3_RTP_PATH=~/Jogos/RTP/2003

# "Wording behaviour"
# see select-word-style to learn more
#
# Remove / and - from WORDCHARS
# ${WORDCHARS//[_-]} would remove _ and -
WORDCHARS="${WORDCHARS//[-\/=.]}"

# See REDIRECTIONS WITH NO COMMAND on zshmisc
NULLCMD=':'
