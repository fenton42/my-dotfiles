# Usage:
# source iterm2.zsh

# iTerm2 window/tab color commands
#   Requires iTerm2 >= Build 1.0.0.20110804
#   http://code.google.com/p/iterm2/wiki/ProprietaryEscapeCodes
tab-color() {
    echo -ne "\033]6;1;bg;red;brightness;$1\a"
    echo -ne "\033]6;1;bg;green;brightness;$2\a"
    echo -ne "\033]6;1;bg;blue;brightness;$3\a"
}
tab-reset() {
    echo -ne "\033]6;1;bg;*;default\a"
}

# Change the color of the tab when using SSH
# reset the color after the connection closes
color-ssh() {
    if [[ -n "$ITERM_SESSION_ID" ]]; then
        trap "tab-reset" INT EXIT
        if [[ "$*" =~ "devel|^pd|infotool" ]]; then
            tab-color 102 205 170
          elif [[ "$*" =~ "overkamp.(org|biz)" ]]; then
            tab-color 0 250 154
        elif [[ "$*" =~ "kunden.csl.de" ]]; then
            tab-color 255 69 0
        elif [[ "$*" =~ "private|epp-be.*" ]]; then
            tab-color 255 165 0
        else
            tab-color 255 255 0
        fi
    fi
    ssh $*
}
compdef _ssh color-ssh=ssh

alias ssh=color-ssh
