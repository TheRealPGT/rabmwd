#!/bin/bash

# Copyright 2019 Archie Hilton <archie.hilton1@gmail.com>

# This program is free software: you can redistribute it and/or modify
#     it under the terms of the GNU General Public License as published by
#     the Free Software Foundation, either version 3 of the License, or
#     (at your option) any later version.
#
#     This program is distributed in the hope that it will be useful,
#     but WITHOUT ANY WARRANTY; without even the implied warranty of
#     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#     GNU General Public License for more details.
#
#     You should have received a copy of the GNU General Public License
#     along with this program.  If not, see <https://www.gnu.org/licenses/>.

MODULES_DIR="/usr/share/dwmbar/modules/"

OUTPUT_CACHE="/home/$USER/.config/dwmbar/.cache/"
OUTPUT=""

CONFIG_FILE="/home/$USER/.config/dwmbar/config"
source $CONFIG_FILE

get_bar()
{
	for module in $MODULES; do
		if [[ $INTERNET -eq 0 ]] || [[ $ONLINE_MODULES != *"$module"* ]];then
			module_out="$(cat $OUTPUT_CACHE$module | sed 's/\.$//g')"
			bar="$bar$module_out"
		fi
	done
	# Uncomment to remove last separator
	# bar=$(echo $bar | sed 's/.$//g')
	echo "$LEFT_PADDING$bar$RIGHT_PADDING"
}

run_module()
{
	if [[ -f "$CUSTOM_DIR$1" ]]
	then
		out="$($CUSTOM_DIR$1)"
	else
		out="$($MODULES_DIR$1)"
	fi

	[[ ! "$out" = "" ]] && out="$out$SEPARATOR."
	echo "$out" > "$OUTPUT_CACHE$module"
}

run()
{
	# for module in $MODULES; do
	# 	pgrep $module &> /dev/null
	# 	notrunning=$([[ $? -eq 1 ]])
	# 	if $notrunning && [[ $INTERNET -eq 0 ]]; then
	# 		run_module $module
	# 	elif $notrunning && [[ $INTERNET -eq 1 ]]; then
	# 		[[ "$ONLINE_MODULES" != *"$module"* ]] && run_module $module
	# 	fi
	# done

	parallel $MODULES_DIR{} ::: $MODULES

	get_bar
	sleep $DELAY;
}

run