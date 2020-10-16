#!/bin/bash
set +x 
export HOMEBREW_NO_INSTALLED_DEPENDENTS_CHECK=false
brew tap aide-qc/deploy
brew install qcor
UNAME=$(uname | tr "[:upper:]" "[:lower:]")
# If Linux, try to determine specific distribution
if [ "$UNAME" == "linux" ]; then
    # If available, use LSB to identify distribution
    if [ -f /etc/lsb-release -o -d /etc/lsb-release.d ]; then
        export DISTRO=$(lsb_release -i | cut -d: -f2 | sed s/'^\t'//)
    # Otherwise, use release info file
    else
        export DISTRO=$(ls -d /etc/[A-Za-z]*[_-][rv]e[lr]* | grep -v "lsb" | cut -d'/' -f3 | cut -d'-' -f1 | cut -d'_' -f1)
    fi
fi
# For everything else (or if above failed), just use generic identifier
[ "$DISTRO" == "" ] && export DISTRO=$UNAME
unset UNAME
# if Ubuntu, install lapack
if [ "$DISTRO" == "Ubuntu" ]; then
    sudo apt-get update -y && sudo apt-get install -y liblapack-dev
elif [[ $DISTRO == "fedora"* ]]; then
    sudo dnf update -y && sudo dnf install gcc gcc-c++ lapack-devel
fi
