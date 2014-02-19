# The following lines were added by compinstall

zstyle ':completion:*' completer _expand _complete _ignored
zstyle ':completion:*' ignore-parents parent pwd ..
zstyle ':completion:*' insert-unambiguous true
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-suffixes true
zstyle ':completion:*' menu select=long
zstyle ':completion:*' original false
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %l%s
zstyle ':completion:*' squeeze-slashes true
zstyle :compinstall filename '/home/vinipsmaker/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall
# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=4096
SAVEHIST=4096
setopt appendhistory extendedglob
unsetopt notify
bindkey -e
# End of lines configured by zsh-newuser-install

# zshoptions {{{

setopt TRANSIENT_RPROMPT

## History control
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_NO_STORE

# }}}

# Zsh normally leaves the stty intr setting alone and handles the INT
# signal.  Which means that when you type ^C, you're sending a signal
# to the tty process group, not a normal keystroke to the shell input.
# This has some helpful side-effects for process management, but means
# the the line editor exits.
#
# In order to behave the way you want, you have to trap the INT signal
# and print the ^C yourself: {{{

## will be redefined later
updatemyprompt() { }

local _trapped='no'
TRAPINT() {
  print -n -u2 '^C'

  _trapped='yes'
  updatemyprompt

  return $((128+$1))
}

# }}}

# Key bindings {{{

autoload zkbd
function zkbd_file() {
    [[ -f ~/.zkbd/${TERM}-${VENDOR}-${OSTYPE} ]] && printf '%s' ~/".zkbd/${TERM}-${VENDOR}-${OSTYPE}" && return 0
    [[ -f ~/.zkbd/${TERM}-${DISPLAY}          ]] && printf '%s' ~/".zkbd/${TERM}-${DISPLAY}"          && return 0
    return 1
}

[[ ! -d ~/.zkbd ]] && mkdir ~/.zkbd
keyfile=$(zkbd_file)
ret=$?
if [[ ${ret} -ne 0 ]]; then
    zkbd
    keyfile=$(zkbd_file)
    ret=$?
fi
if [[ ${ret} -eq 0 ]] ; then
    source "${keyfile}"
else
    printf 'Failed to setup keys using zkbd.\n'
fi
unfunction zkbd_file; unset keyfile ret

[[ -n ${key[Home]} ]] && bindkey "${key[Home]}" beginning-of-line
[[ -n ${key[End]} ]] && bindkey "${key[End]}" end-of-line
[[ -n ${key[Delete]} ]] && bindkey "${key[Delete]}" delete-char
[[ -n ${key[PageUp]} ]] && bindkey "${key[PageUp]}" beginning-of-buffer-or-history
[[ -n ${key[PageDown]} ]] && bindkey "${key[PageDown]}" end-of-buffer-or-history

# }}}

# Aliases {{{

alias ls='ls --color=auto'
alias cgrep='grep --color=always -I'
alias grep='grep --color=auto -I'
alias less='less -Ri'
alias youtube='youtube-dl -f 43 -l'
alias mplayer='mplayer -ao pulse --quvi-format=default'
alias aplayer='mplayer -vo none'

if [ $TERMINOLOGY ]; then
  alias ls2='tyls'
  alias cat2='tycat'
fi

# }}}

# Functions {{{

man(){
  env man $* || (command -v $1 >/dev/null 2>&1 && $1 --help | less)
}

# }}}

# Prompt {{{

autoload -U colors && colors

setopt prompt_subst

fortune -c

autoload -Uz vcs_info
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' enable git svn

## %n: username
## %m: hostname
## %~: working dir
## %?: last command's exit status

updatemyprompt() {
  # vcs_info_msg_0_ var {{{
  vcs_info
  # }}}

  # Last command status {{{
  local _PROMPT_CHAR=""

  if [ x"$_trapped" = x"yes" ]; then
    _PROMPT_CHAR='$'
  else
    _PROMPT_CHAR="%(?::%{$bg[red]%})\$%{$reset_color%}"
  fi
  # }}}

  PROMPT='%n'
  if [[ ! -z $SSH_TTY ]]; then
    PROMPT="${PROMPT}"' @ %m'
  fi
  PROMPT="${PROMPT}"' %{$fg[blue]%}%~ %{$reset_color%}'"${_PROMPT_CHAR}"' '
}

precmd() { updatemyprompt }
preexec() { _trapped='no' }

RPROMPT='%{$fg[yellow]%}${vcs_info_msg_0_}%{$reset_color%}'

# }}}
