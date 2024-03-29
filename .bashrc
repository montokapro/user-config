# Bash initialization for interactive non-login shells and
# for remote shells (info "(bash) Bash Startup Files").

# Export 'SHELL' to child processes.  Programs such as 'screen'
# honor it and otherwise use /bin/sh.
export SHELL

if [[ $- != *i* ]]
then
    # We are being invoked from a non-interactive shell.  If this
    # is an SSH session (as in "ssh host command"), source
    # /etc/profile so we get PATH and other essential variables.
    [[ -n "$SSH_CLIENT" ]] && source /etc/profile

    # Don't do anything else.
    return
fi

# Source the system-wide file.
source /etc/bashrc

# Adjust the prompt depending on whether we're in 'guix environment'.
if [ -n "$GUIX_ENVIRONMENT" ]
then
    PS1='\u@\h \w [env]\$ '
else
    PS1='\u@\h \w\$ '
fi
alias ls='ls -p --color=auto'
alias ll='ls -l'
alias grep='grep --color=auto'

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000000
HISTFILESIZE=2000000

# local bin
export PATH=$PATH:$HOME/.local/bin

# guix
export GUIX_PROFILE=$HOME/.guix-profile
export GUIX_LOCPATH=$HOME/.guix-profile/lib/locale

# nix
export PATH=$PATH:/nix/var/nix/profiles/default/bin

# gpg
if command -v tty &> /dev/null
then
  GPG_TTY=$(tty)
  export GPG_TTY
fi

# editor
export EDITOR="emacs -nw"

# ruby
export PATH=$PATH:$HOME/.rbenv/bin
eval "$(rbenv init - bash)"

# scala
export PATH=$PATH:$HOME/.local/share/coursier/bin

if command -v find &> /dev/null && command -v find &> /dev/null
then
  #THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
  export SDKMAN_DIR="/home/steve/.sdkman"
  [[ -s "/home/steve/.sdkman/bin/sdkman-init.sh" ]] && source "/home/steve/.sdkman/bin/sdkman-init.sh"
fi
