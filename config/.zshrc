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
setopt appendhistory extendedglob
unsetopt notify
bindkey -e
# End of lines configured by zsh-newuser-install

# Extra plugins {{{

## Smarter help and a bash-like help function
unalias run-help
autoload run-help
alias help='run-help'

## autocompletion for vlc based on --help
compdef _gnu_generic vlc

## Magic quoting in URLs to save me from typing quoted strings
autoload -U url-quote-magic
zle -N self-insert url-quote-magic

## Fish shell like syntax highlighting
function () {
    local _syntax_highlighting_file=/usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

    if [ -f $_syntax_highlighting_file ]; then
        . $_syntax_highlighting_file
    fi
}

# }}}

# zshoptions {{{

setopt TRANSIENT_RPROMPT
setopt print_exit_value
setopt COMPLETE_IN_WORD
setopt INTERACTIVE_COMMENTS

## History control
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_NO_STORE

# }}}

# Call rehash after any pacman/yaourt operation. A behaviour more accurate could
# be achieved through `zstyle ':completion:*' rehash true`. {{{

TRAPUSR1() { rehash }

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

## Native keys

### Tab
bindkey "^I" expand-or-complete-prefix

### Alt + F
bindkey "^[f" emacs-forward-word

### Ctrl + U
bindkey "^U" backward-kill-line

## Extended keys

function () {
    typeset -A key

    ### Shift+Tab isn't available in the zkbd map
    key[Shift+Tab]="^[	"

    if (( ${+terminfo[smkx]} )) && (( ${+terminfo[rmkx]} )); then
        ### If application mode/terminfo is available
        function zle-line-init () {
            echoti smkx
        }
        function zle-line-finish () {
            echoti rmkx
        }
        zle -N zle-line-init
        zle -N zle-line-finish

        ### List of desired keys
        key[Home]=${terminfo[khome]}
        key[End]=${terminfo[kend]}
        key[Delete]=${terminfo[kdch1]}
        key[PageUp]=${terminfo[kpp]}
        key[PageDown]=${terminfo[knp]}

        key[Shift+Tab]=${terminfo[kcbt]}
    else
        ### Fallback to manually managed user-driven database
        printf 'Failed to setup keys using terminfo (application mode unsuported).\n'
        printf 'Jumping to zkbd fallback.\n'

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
    fi

    ### Setup keys accordingly

    [[ -n ${key[Home]} ]] && bindkey "${key[Home]}" beginning-of-line
    [[ -n ${key[End]} ]] && bindkey "${key[End]}" end-of-line
    [[ -n ${key[Delete]} ]] && bindkey "${key[Delete]}" delete-char
    [[ -n ${key[PageUp]} ]] && bindkey "${key[PageUp]}" beginning-of-buffer-or-history
    [[ -n ${key[PageDown]} ]] && bindkey "${key[PageDown]}" end-of-buffer-or-history

    ### Shift+Tab on completion list
    zmodload zsh/complist
    bindkey -M menuselect "${key[Shift+Tab]}" reverse-menu-complete
}

# }}}

# Aliases {{{

alias nc='ncat'
alias ls='ls --color=auto'
alias cgrep='grep --color=always -I'
alias grep='grep --color=auto -I'
alias less='less -Ri'
alias youtube='youtube-dl -f 43'
alias mplayer='mplayer -ao pulse --quvi-format=default'
alias aplayer='mplayer -vo none'
alias insult='wget http://www.randominsults.net -O - 2>/dev/null | grep \<strong\> | sed "s;^.*<i>\(.*\)</i>.*$;\1;"'
alias spacman='sudo pacman'

if [ $TERMINOLOGY ]; then
  alias ls2='tyls'
  alias cat2='tycat'
fi

# }}}

# Functions {{{

man() {
  env man $* || (command -v $1 >/dev/null 2>&1 && $1 --help | less)
}

mdless() {
  markdown $1 | lynx -stdin
}

# }}}

# Prompt {{{

autoload -U colors && colors

setopt prompt_subst

fortune -c

autoload -Uz vcs_info
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' enable git

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

  PROMPT='%{$fg[cyan]%}%n'
  if [[ ! -z $SSH_TTY ]]; then
    PROMPT="${PROMPT}"' @ %m'
  fi
  PROMPT="${PROMPT}"' %{$fg[magenta]%}%~ %{$reset_color%}'"${_PROMPT_CHAR}"' '
}

precmd() {
  # Update the prompt
  updatemyprompt

  # Call rehash after any pacman/yaourt operation
  [[ $history[$[ HISTCMD -1 ]] == *(pacman|yaourt)* ]] && killall -USR1 zsh
}

preexec() { _trapped='no' }

RPROMPT='%{$fg[yellow]%}${vcs_info_msg_0_}%{$reset_color%}'

# }}}
