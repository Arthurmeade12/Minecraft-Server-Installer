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
	[ $# -eq 0 ] && return 2
	echo -en "${YELLOW}${BOLD}==> WARNING:${RESET} ${YELLOW}${@}\nAborting ...$RESET"
	exit 1
}
# Readonly funcs
for X in {out,abort}; do
	readonly -f -- $X
done
### Make sure we're running bash, ksh, or zsh before we continue.
case $BASH_VERSION in
5.?.?*|4.?.?* )	: ;;
3.?.?* ) warn "You are using an outdated version of bash. If possible, please use this script with Bash Version ≥ 4.0.0." ;;
2.?.?*|1.?.?* )	abort 'Your bash version is extremely outdated. To run this script, preferably use bash version ≥ 4.0.0, but only ≥ 3.0.0 is required.' ;;
?* ) abort '${BOLD}ERROR: ${RESET}${RED}Invalid bash version found in $BASH_VERSION. Are you running bash ? Make sure your environment variables have been set correctly.' ;;
* ) abort "${BOLD}ERROR:${RESET}${RED}You aren't running bash." ;;
esac
### OS checks
# OS check
case $(sysctl -n kern.ostype) in
Darwin ) OS=0 ;;
* )	warn "${RED}ERROR: You are not running MacOS.${RESET}" 
	OS=1;;
esac
# 64-bit compat check
case $OS in
0 )	case $(sw_vers -productVersion) in
	10.*)	VERSION=$(sw_vers -productVersion | tr -d '10.') 
		# To-do: Make sure we're 10.7 or higher
		;;
	11.*)	: 
		;;
	* )	warn "Your OS is not 64-bit compatible. "
		BIT=32 
		;;
	esac
	;;
1 ) :
# To-do: Add linux 64-bit compat check
;; 
esac
# Intel processor check
case $(sysctl -n machdep.cpu.brand_string | grep Intel) in
	Intel* ): ;;
	* )	warn "You are not using the Intel processor. Maybe you are running Arm or PowerPC." ;;
esac
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
done
