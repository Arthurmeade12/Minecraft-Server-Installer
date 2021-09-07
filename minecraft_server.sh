#!/usr/bin/env bash
# minecraft_server.sh
#############################################################################
# Copyright (c) 2021, Arthur Meade <arthurmeade12@gmail.com>
#
# This software is provided 'as-is', without any express or implied
# warranty. In no event will the authors be held liable for any damages
# arising from the use of this software.
# 
# Permission is granted to anyone to use this software for any purpose,
# including commercial applications, and to alter it and redistribute it
# freely, subject to the following restrictions:
#
#  1. The origin of this software must not be misrepresented; you must not
#  claim that you wrote the original software. If you use this software
#  in a product, an acknowledgment in the product documentation is required.
#
#  2. Altered source versions must be plainly marked as such, and must not be
#  misrepresented as being the original software.
#
#  3. This notice may not be removed or altered from any source
#  distribution.
#############################################################################
set -eu
### Vars
SUDO=false
if [[ $EUID = 0 ]]; then
	SUDO=true
fi
BLUE=`tput setaf 20`
BOLD=`tput bold`
RESET=`tput sgr0`
RED=`tput setaf 1`
WHITE=`tput setaf 15`
YELLOW=`tput setaf 3`
GREEN=`tput setaf 2`
TEAL=`tput setaf 6`
PURPLE=`tput setaf 5`
UNDERLINED=`tput smul`
# Readonly vars
for X in {BLUE,BOLD,RESET,RED,WHITE,TEAL,PURPLE,SUDO,UNDERLINED}; do
	readonly -- $X
done
out(){
	for X in "$@"; do
		echo -en "${BLUE}${BOLD}==>${RESET} ${WHITE}${X} "
		echo "`tput sgr0`"
	done
}
abort(){
	[ $# -eq 0 ] && return 2
	echo -en "${RED}${BOLD}==> ${@}\nAborting ...$RESET"
	exit 1
}
warn(){
	tput setaf 3 && tput bold
		 	echo -n 'WARNING:'
}
# Readonly funcs
for X in {out,abort}; do
	readonly -f -- $X
done
### Make sure we're running bash, ksh, or zsh before we continue.
case $BASH_VERSION in
5.?.?*|4.?.?* )	: ;;
3.?.?* )	tput setaf 3 && tput bold
		 	echo -n 'WARNING:'
		 	tput sgr0 && tput setaf 3
		 	echo "`tput setaf 3`You are using an outdated version of bash. If possible, please use this script with Bash Version ≥ 4.0.0."
		 	tput sgr0
		 	;;
2.?.?*|1.?.?* )	abort 'Your bash version is extremely outdated. To run this script, preferably use bash version ≥ 4.0.0, but only ≥ 3.0.0 is required.'
				;;
?* )	tput setaf 1 && tput bold
		echo -n 'ERROR:'
		tput sgr0 && tput setaf 1
		echo ' Invalid bash version found in $BASH_VERSION. Are you running bash ? Make sure your environment variables have been set correctly, and that you haven'"'"'t put a fake bash executable in your $PATH. '
	 	tput sgr0 
	 	exit 1
	 	;;
* ) tput setaf 1 && tput bold
	echo -n "ERROR:" 
	tput sgr0 && tput setaf 1
	echo "You arent running bash.`tput bold` Aborting ..."
	tput sgr0
	exit 1
	;;
esac
# Readonly funcs
for X in {out,abort}; do
	readonly -f -- $X
done
### OS checks
# MacOS (really Darwin) check
case $(sysctl -n kern.ostype) in
Darwin ): ;;
* ) abort "ERROR: You are not running MacOS." 
	;;
esac
# 64-bit compat check
VERSION=$(sw_vers -productVersion)
if [[ $VERSION = 10.* ]]; then
	TEN_VERSION=$(sw_vers -productVersion | tr -d '10.')
	if [[ $VERSION ]]
elif [[ $VERSION = 11.* ]]; then
	:
else
	abort "ERROR: Your OS is not 64-bit compatible. \nAborting..." 
fi
# Intel processor check
case $(sysctl -n machdep.cpu.brand_string | grep Intel) in
	Intel* ): ;;
	* )	echo -e "ERROR: You are not using the Intel processor. Maybe you are running Arm or PowerPC. \nAborting..." 
	;;
esac
###### Check for basic commands
# Make sure we don't use user overrides
command -p ls 1>/dev/null
builtin pwd 1>/dev/null
builtin echo 1>/dev/null
command mkdir cool 1>/dev/null
command touch hey 1>/dev/null
command -p rm -r cool hey 1>/dev/null
###### Script
### Vars
out "Welcome to Arthur's Minecraft Server Installer !"
out "This installer only installs Servers for 1.17.1, the latest minecraft version."
out "${RED}This means that softwares like Magma and Sponge are unavailable for installation."
while a=$((a + 1)); do
	case $a in
		5 )	abort "Aborting due to 5 invalid answers. " ;;
		? ) true ;;
	esac
	echo "${GREEN}${BOLD}==> ${YELLOW}What server software would you like to use ?"