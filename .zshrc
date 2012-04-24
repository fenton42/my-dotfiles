# dotfiles.org/~brendano/.zshrc - for zsh, the best shell in the world
# brendan o'connor - brenocon at gmail

# if [[ -f ~/.profile ]] && [ ! "$PROFILE_READ" ]; then
#     export PROFILE_READ=yes
#     source ~/.profile
# fi

#[[ -f ~/.inputrc ]] && export INPUTRC=~/.inputrc

[[ -f ~/db.sh ]] && source ~/db.sh

# http://www.zsh.org/mla/workers/1996/msg00191.html
[[ `who am i` != *\) ]] && is_local=yes

[[ "$is_local" = yes ]]  && export DISPLAY=${DISPLAY:-:0.0}

#alias cm="open /Applications/Emacs.app"
alias cm="/Applications/Emacs.app/Contents/MacOS/Emacs"
alias ccm=/Applications/Emacs.app/Contents/MacOS/bin/emacs
#alias lp='ls --color ^*(~|.pyc|ptlc)(^/)'
function lsfull {  ls -d $(pwd)/$1  }
function 'h?' {
  history +1 | perl -pe "s/ *\d+//" | grep "$@" | uniq | grep --color=always "$@"
}

# mac gui apps
# function better than alias: no hanging for tab completion
excel()  {  open -a "Microsoft Excel" "$@"  }
word()   {  open -a "Microsoft Word" "$@"  }
ppt()    {  open -a "Microsoft Powerpoint" "$@"  }
ff()     {  open -a "/Applications/Firefox.app" "$@"  }
safari() {  open -a Safari "$@"  }
smul()   {  open -a Smultrion "$@"  }
alias apps='open /Applications'

alias view='gvim --cmd "au GUIEnter * simalt ~x"'
alias v=vim
#iterm TERM=ansi screws up emacs
#alias emacs="TERM=xterm emacs"
alias e="emacs -nw"
alias screen='TERM=screen screen'  # http://ubuntuforums.org/showthread.php?t=90910

export PYTHONSTARTUP=~/.pythonrc

# no spelling corrections  (man zshbuiltins)
alias mv='nocorrect mv'
alias cp='nocorrect cp'
alias mkdir='nocorrect mkdir'
alias rm='nocorrect rm'
alias pu=pushd
alias p=popd
alias ..="cd .."

if ls --color  &>/dev/null; then
  ls_opt="--color" # gnu (linux)
else
  ls_opt="-G"      # mac
  #ls_opt="-F"
fi
alias ls="ls $ls_opt"
alias ll='ls -l'
alias grep='grep --color'
alias cgrep='grep --color=always'
function lcgrep {
  grep --color=always "$@" | less -r
}

alias pyclean='rm **/*(.pyc|.ptlc|~)'
alias rmtil='rm *~'
alias rrmtil='rm **/*~'

export PAGER=less
export MANPAGER="less -r"
alias lesr='less -r'
# export LESS="-i"     # git diff unhappy

export EDITOR=vim
# export SVN_SSH="ssh -l $USER"

# er i bet all this color stuff could be simplified
setopt prompt_subst
autoload colors zsh/terminfo
if [[ "$terminfo[colors]" -ge 8 ]]; then
  colors
fi
for color in RED GREEN YELLOW BLUE MAGENTA CYAN WHITE; do
  if [[ "$TERM" == dumb ]]; then
    eval PR_$color=
    eval PR_LIGHT_$color=
    BOLD=
    UNBOLD=
  else
    eval PR_$color='%{$terminfo[bold]$fg[${(L)color}]%}'
    eval PR_LIGHT_$color='%{$fg[${(L)color}]%}'
    BOLD='%B'
    UNBOLD='%b'
  fi  
done
PR_NO_COLOUR="%{$terminfo[sgr0]%}"
[[ "$TERM" == dumb ]] && PR_NO_COLOUR=

## PS1 and PS2 also work, but conflict with sh/bash.
## PROMPT conflicts with cmd.exe, less important
if [[ "$is_local" == yes ]]; then
  PROMPT='$BOLD$PR_BLUE%~$UNBOLD $PR_GREEN%#$PR_NO_COLOUR '
else
  PROMPT='$BOLD$PR_RED%n@%m:$PR_BLUE%~$UNBOLD $PR_GREEN%#$PR_NO_COLOUR '  #user@machine on front
fi
# %m  is machine name

# Prompt in right margin
## RPROMPT='[%h]'

case $TERM in 
  xterm*|rxvt|cygwin|putty|ansi)
    precmd () { print -Pn "\e]0;%~ (%m)\a" }
  
    # i now use leopard terminal, it automatically makes tab titles the process under execution, so preexec() doesnt do anything.  unclear what a good workaround is.
    preexec () { 
      # note, iterm is 'ansi'
      # if [[ "$is_local" == yes ]]; then
        cmd="$2"
        # truncation doesnt work, need to turn off dollar expansion in print -P
        # i think?
        # cmd=${cmd[0,200]}
        # print -Pn "\e]0;$cmd (%m)\a" 
        print -Pn "\e]0;$cmd (%m)\a" 
      }
    # else
    #   precmd () { print -Pn "\e]0;%m: %~\a" }
    #   preexec () { 
    #     cmd=${1[0,100]}
    #     print -Pn "\e]0;%m: $cmd\a" 
    #   }
    # fi
    ;;
esac

# ----- Lots of options.  (man zshoptions) -----

# History awesomeness!  see rant at dotfiles.org/~brendano/.inputrc
# (zsh does not use gnu readline, so doesnt use .inputrc, but this duplicates
# those features...)
HISTFILE=~/.zhistory
HISTSIZE=100000
SAVEHIST=100000
setopt appendhistory
setopt share_history
setopt histignoredups
setopt hist_no_store
setopt histreduceblanks


setopt autopushd pushdminus pushdtohome autocd pushdignoredups

autoload -U compinit
compinit
setopt clobber
setopt nocorrectall   # only want commands, not arg correction
setopt correct
setopt equals
setopt extendedglob
setopt interactive_comments
setopt longlistjobs
setopt nohup
setopt nonomatch  # echo not-here*  actually gets the *
#setopt nullglob  # echo not-here*  expands to no args

# completion for *lots* of commands - man, ssh, etc
zmodload -i zsh/complist
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

#more more more more options
#setopt   notify globdots correct pushdtohome cdablevars autolist
#setopt   correctall autocd recexact longlistjobs
#setopt   autoresume histignoredups pushdsilent noclobber
#setopt   autopushd pushdminus extendedglob rcquotes mailwarning
#unsetopt bgnice autoparamslash



# zsh doesn't use readline, and these are almost always not set
# or set wrongly.  yikes...

# if [ -f ~/.zkbd/$TERM-$VENDOR-$OSTYPE ]; then
#   source ~/.zkbd/$TERM-$VENDOR-$OSTYPE
#   [[ -n ${key[Backspace]} ]] && bindkey "${key[Backspace]}" backward-delete-char
#   [[ -n ${key[Home]} ]] && bindkey "${key[Home]}" beginning-of-line
#   [[ -n ${key[PageUp]} ]] && bindkey "${key[PageUp]}" up-line-or-history
#   [[ -n ${key[Delete]} ]] && bindkey "${key[Delete]}" delete-char
#   [[ -n ${key[End]} ]] && bindkey "${key[End]}" end-of-line
#   [[ -n ${key[PageDown]} ]] && bindkey "${key[PageDown]}" down-line-or-history
#   [[ -n ${key[Up]} ]] && bindkey "${key[Up]}" up-line-or-search
#   [[ -n ${key[Up]} ]] && bindkey "${key[Up]}" up-line-or-search
#   [[ -n ${key[Left]} ]] && bindkey "${key[Left]}" backward-char
#   [[ -n ${key[Down]} ]] && bindkey "${key[Down]}" down-line-or-search
#   [[ -n ${key[Right]} ]] && bindkey "${key[Right]}" forward-char 
# else

#emacs bindings, e.g. ctrl-{a,e,d,k,u,y}
bindkey -e  

#history only on first substring of command you're typing
#bindkey "\e[A" up-line-or-search
#bindkey "\e[B" down-line-or-search
bindkey "\e[A" history-beginning-search-backward
bindkey "\e[B" history-beginning-search-forward
#new iterm binds up arrow to this, wtf, ^[[A is standard on all other xterm's
bindkey "\eOA" history-beginning-search-backward
bindkey "\eOB" history-beginning-search-forward

bindkey "\e[1~" beginning-of-line
bindkey "\e[2~" quoted-insert
bindkey "\e[3~" delete-char
bindkey "\e[4~" end-of-line
bindkey "\e[5~" beginning-of-history
bindkey "\e[6~" end-of-history
bindkey "\e[7~" beginning-of-line
bindkey "\e[8~" end-of-line
bindkey "\e[H" beginning-of-line
bindkey "\e[F" end-of-line
bindkey "\eOH" beginning-of-line
bindkey "\eOF" end-of-line
bindkey "\eOd" backward-word
bindkey "\eOc" forward-word 

# ubuntu demanded this once from iterm TERM=xterm-color
bindkey '^?' backward-delete-char 

bindkey -e

# iterm
growl() {
  if [ "$1" ]; then TEXT="$@"; else TEXT=$(cat); fi
  print -Pn "\e]0;\a"
  print -Pn "\e]9;$TEXT\a"
  print -Pn "\e]0;%~ (%m)\a"
}

lst() {
  if [ "$1" ]; then
    prefix="$1/"
  else
    prefix=
  fi
  print -l $prefix**/* | xargs ls -d $ls_opt
}

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"  # This loads RVM into a shell session.

export PATH=$PATH:~/bin:/Developer/usr/bin 
export PATH=/usr/local/sbin:/usr/local/bin:$PATH:/Applications/IBM/informix/bin/

export MANPATH=$MANPATH
export C_INCLUDE_PATH=$C_INCLUDE_PATH

cdpath=( ~/Documents/Projekte_SSD /usr /opt/local )
export ARCHFLAGS='-arch x86_64'
export DYLD_LIBRARY_PATH=$DYLD_LIBRARY_PATH:/Applications/IBM/informix/lib/esql/:/Applications/IBM/informix/lib/

alias wjoker='whois -h whois.joker.com '

if [ -e "/usr/local/CrossPack-AVR" ]; then
PATH="$PATH:/usr/local/CrossPack-AVR/bin"
export PATH
fi

fortune -o
