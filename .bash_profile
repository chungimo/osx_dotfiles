#
# .bash_profile
#
# @jham
#
#

# Nicer prompt.
export PS1="\[\e[0;32m\]\]\[\] \[\e[1;32m\]\]\t \[\e[0;2m\]\]\w \[\e[0m\]\]\[$\] "

# Use colors.
export CLICOLOR=1
export LSCOLORS=ExFxCxDxBxegedabagacad

# Custom $PATH with extra locations.
export PATH=/usr/local/bin:/usr/local/sbin:$HOME/bin:/usr/local/git/bin:$HOME/.composer/vendor/bin:$PATH

# Include alias file (if present) containing aliases for ssh, etc.
if [ -f ~/.bash_aliases ]
then
  source ~/.bash_aliases
fi

# Include bashrc file (if present).
if [ -f ~/.bashrc ]
then
  source ~/.bashrc
fi

# Syntax-highlight code for copying and pasting.
# Requires highlight (`brew install highlight`).
function pretty() {
  pbpaste | highlight --syntax=$1 -O rtf | pbcopy
}

# Git aliases.
alias gs='git status'
alias gc='git commit'
alias gp='git pull --rebase'
alias gcam='git commit -am'
alias gl='git log --graph --pretty=format:"%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset" --abbrev-commit'
alias gsd='git svn dcommit'
alias gsfr='git svn fetch && git svn rebase'

# Git upstream branch syncer.
# Usage: gsync master (checks out master, pull upstream, push origin).
function gsync() {
  if [[ ! "$1" ]] ; then
      echo "You must supply a branch."
      return 0
  fi

  BRANCHES=$(git branch --list $1)
  if [ ! "$BRANCHES" ] ; then
     echo "Branch $1 does not exist."
     return 0
  fi

  git checkout "$1" && \
  git pull upstream "$1" && \
  git push origin "$1"
}

# Turn on Git autocomplete.
brew_prefix=`brew --prefix`
if [ -f $brew_prefix/etc/bash_completion ]; then
  . $brew_prefix/etc/bash_completion
fi

# Use brew-installed PHP binaries.
export PATH="$brew_prefix/opt/php56/bin:$PATH"

# Use nvm.
#export NVM_DIR="$HOME/.nvm"
#. "$brew_prefix/opt/nvm/nvm.sh"

# Use rbenv.
if [ -f /usr/local/bin/rbenv ]; then
  eval "$(rbenv init -)"
fi

# Python settings.
###  export PYTHONPATH="/usr/local/lib/python2.7/site-packages"
#export PYTHONPATH="/usr/local/Cellar/python/2.7.14"

# Enter a running Docker container.
function denter() {
  if [[ ! "$1" ]] ; then
      echo "You must supply a container ID or name."
      return 0
  fi

  docker exec -it $1 bash
  return 0
}

# Delete a given line number in the known_hosts file.
knownrm() {
  re='^[0-9]+$'
  if ! [[ $1 =~ $re ]] ; then
    echo "error: line number missing" >&2;
  else
    sed -i '' "$1d" ~/.ssh/known_hosts
  fi
}

# Ask for confirmation when 'prod' is in a command string.
prod_command_trap () {
  if [[ $BASH_COMMAND == *prod* ]]
  then
    read -p "Are you sure you want to run this command on prod [Y/n]? " -n 1 -r
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
      echo -e "\nRunning command \"$BASH_COMMAND\" \n"
    else
      echo -e "\nCommand was not run.\n"
      return 1
    fi
  fi
}
#shopt -s extdebug
#trap prod_command_trap DEBUG

##########################
# shortcuts because lazy #
alias gohome="cd ~/"
alias goansible="cd ~/ansible"
alias goscripts="cd ~/scripts"
alias gogo="cd ~/go/src"
alias wordwrapon="tput rmam"
alias wordwrapoff="tput smam"

# shortcut commands
alias hosts="cat /etc/hosts"
alias powershell="/usr/local/microsoft/powershell/6.0.0-rc/pwsh"
alias flushdns="sudo killall -HUP mDNSResponder;sudo killall mDNSResponderHelper;sudo dscacheutil -flushcache"
alias iprenew='echo "add State:/Network/Interface/en0/RefreshConfiguration temporary" | sudo scutil'
alias whatismyip='curl ipinfo.io/ip'
alias weather="curl -s http://wttr.in/dallas"
alias helpme="grep ~/.bash_profile -e 'alias *'"
alias notes="cat ~/notes.txt"
alias ll="ls -l"
alias lunch="curl localhost:8081/lunchtime"
alias lunchgo="cd /Users/chung/go/src/weblunch/;go run weblunch.go"


##########################
# Go environment variables
export PATH=$PATH:/usr/local/Cellar/python/2.7.14/libexec/bin/
export GOPATH=$HOME/go:/Users/chung/workstuff
export GOBIN=$HOME/go/bin:/Users/chung/workstuff/bin
export GOROOT=/usr/local/opt/go/libexec
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:$GOROOT/bin

# Python environment variables
export PYTHONPATH="$PYTHONPATH:/usr/local/Cellar/qt/5.10.1/lib/QtCore.framework/Versions/5/QtCore"
export PYTHONPATH="$PYTHONPATH:/usr/local/Cellar/qt/5.10.1/lib/QtPrintSupport.framework/Versions/5/QtPrintSupport"

# Java environment variables
export JAVA_HOME=$(/usr/libexec/java_home)

##########################

_complete_ssh_hosts ()
{
        COMPREPLY=()
        cur="${COMP_WORDS[COMP_CWORD]}"
        comp_ssh_hosts=`cat ~/.ssh/known_hosts | \
                        cut -f 1 -d ' ' | \
                        sed -e s/,.*//g | \
                        grep -v ^# | \
                        uniq | \
                        grep -v "\[" ;
                cat ~/.ssh/config | \
                        grep "^Host " | \
                        awk '{print $2}'
                `
        COMPREPLY=( $(compgen -W "${comp_ssh_hosts}" -- $cur))
        return 0
}
complete -F _complete_ssh_hosts ssh

# added by Anaconda2 5.1.0 installer
#export PATH="/Users/chung/anaconda2/bin:$PATH"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/chung/google-cloud-sdk/path.bash.inc' ]; then source '/Users/chung/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/chung/google-cloud-sdk/completion.bash.inc' ]; then source '/Users/chung/google-cloud-sdk/completion.bash.inc'; fi
