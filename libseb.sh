#!/bin/sh
#
# libseb.sh: Simple functions without gettext for seb cmdline tools
#
# Copyright (C) 2017 SliTaz GNU/Linux - BSD License
#

# Parse cmdline options and store values in a variable.
for opt in "$@"; do
	opt_name="${opt%%=*}"
	opt_name="$(echo -n "${opt_name#--}" | tr -c 'a-zA-Z0-9' '_')"
	case "$opt" in
		--*=*)		export  $opt_name="${opt#*=}" ;;
		--*)		export  $opt_name="yes" ;;
	esac
done

# Exit if command returns 1
check() {
	local code="$?"
	case "$output" in
		html)
			case "$code" in
				0) echo " <span style='color: green;'>Done</span>" ;;
				1) 
					echo " <span style='color: red;'>--> Error</span>" 
					exit 1 ;;
			esac ;;
		*)
			case "$code" in
				0) info 32 "Done" ;;
				1) colorize 31 "--> Error" && exit 1 ;;
			esac ;;
	esac
}

# Check if user is logged as root
check_root() {
	if [ $(id -u) -ne 0 ]; then
		echo "You must be root to execute: $(basename $0) $@"; exit 1
	fi
}

# Get console cols
get_cols() {
	if ! stty size | cut -d " " -f 2; then
		echo 80
	fi
}

# Indent text
indent() {
	local in="$1"
	shift
	case "$output" in
		html) echo ": $@" ;;
		*) echo -e "\033["${in}"G $@" ;;
	esac
}

# Display a bold message
boldify() {
	case "$output" in
		html) echo "<strong>$@</strong>" ;;
		*) echo -e "\\033[1m$@\\033[0m" ;;
	esac
}

# Colorize message
colorize() {
	: ${color=$1}
	shift
	case "$output" in
		html|raw) echo "$@" ;;
		*) 
			case "$color" in
				0*) echo -e "\\033[${color:-38}m$@\\033[39m" ;;
				*)  echo -e "\\033[1;${color:-38}m$@\\033[0;39m" ;;
			esac ;;
	esac; unset color
}

# Last command status
status() {
	local code="$?"
	case "$output" in
		html)
			case "$code" in
				0) echo " <span style='color: green;'>Done</span>" ;;
				1) echo " <span style='color: red;'>Fail</span>" ;;
			esac ;;
		*)
			case "$code" in
				0) info 32 "Done" ;;
				1) info 31 "Fail" ;;
			esac ;;
	esac
}

# Print info a la status way: info [color] [content]
info() {
	local info="$2"
	case "$output" in
		html) echo " <span class='info'>$info</span>" ;;
		*)
			local char="$(echo $info | wc -L)"
			local in=$((7 + ${char}))
			indent $(($(get_cols) - ${in})) "[ $(colorize $1 $info) ]" ;;
	esac
}

# Line separator
separator() {
	case "$output" in
		html) echo -n '<hr />' ;;
		*) printf "%$(get_cols)s\n" | tr ' ' "${1:-=}" ;;
	esac
}

title() {
	echo ""; colorize 33 "$@"; separator
}

footer() {
	separator "-"; [ "$1" ] && colorize 035 "$1"; echo ""
}

# Testsuite
if [ $(basename $0) == "libseb.sh" ]; then
	title "libseb.sh title()"
	echo -n "Checking status() 0"; status
	echo -n "Checking status() 1"; ls /a/a 2>/dev/null; status
	echo -n "Checking info()"; info 035 "3.4K"
	echo -n "Checking colorize()"; colorize 33 " message"
	echo -n "Checking colorize()"; colorize 033 " message"
	echo "Checking footer()"; footer "Footer message"
fi
