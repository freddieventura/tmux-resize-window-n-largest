#!/usr/bin/env bash

set_tmux_option() {
  local option="$1"
  local value="$2"
  tmux set-option -gq "$option" "$value"
}

get_tmux_option() {
  local option="$1"
  local default_value="$2"
  local option_value=$(tmux show-option -gqv "$option")
  if [ -z "$option_value" ]; then
    echo "$default_value"
  else
    echo "$option_value"
  fi
}

set_tmux_hook() {
    local trigger=$1
    local index=$2
    tmux set-hook -g "${1}"\["${2}"\]" \"${3}\""
}

set_tmux_runshell_command() {
    echo "run-shell $1 $2 $3 $4 $5"
}

set_tmux_runshell_sync_active_pane() {
    local viewport=($(getViewportByNLargestHeight))
    local fullpath_command="${CURRENT_DIR}/sync_active_pane.sh"
    local run_shell_command=$(set_tmux_runshell_command "" "-s " "${sync_source}" "-t " "${sync_destiny}")
    echo $run_shell_command;
}


#get_optionname() {
#    get_tmux_option "${optionname_option}" "${optionname_default}"
#}
#set_optionname() {
#    set_tmux_option "${optionname_option}" "${optionname_default}"
#}

get_plugin_active() {
    get_tmux_option "${plugin_active_option}" "${plugin_active_default}"
}
set_plugin_active() {
    set_tmux_option "${plugin_active_option}" "${plugin_active_default}"
}


get_target_session_one() {
    get_tmux_option "${target_session_one_option}" "${target_session_one_default}"
}
set_target_session_one() {
    set_tmux_option "${target_session_one_option}" "${target_session_one_default}"
}

get_order_session_one() {
    get_tmux_option "${order_session_one_option}" "${order_session_one_default}"
}
set_order_session_one() {
    set_tmux_option "${order_session_one_option}" "${order_session_one_default}"
}

get_axis_session_one() {
    get_tmux_option "${axis_session_one_option}" "${axis_session_one_default}"
}
set_axis_session_one() {
    set_tmux_option "${axis_session_one_option}" "${axis_session_one_default}"
}

get_target_session_two() {
    get_tmux_option "${target_session_two_option}" "${target_session_two_default}"
}
set_target_session_two() {
    set_tmux_option "${target_session_two_option}" "${target_session_two_default}"
}

get_order_session_two() {
    get_tmux_option "${order_session_two_option}" "${order_session_two_default}"
}
set_order_session_two() {
    set_tmux_option "${order_session_two_option}" "${order_session_two_default}"
}

get_axis_session_two() {
    get_tmux_option "${axis_session_two_option}" "${axis_session_two_default}"
}
set_axis_session_two() {
    set_tmux_option "${axis_session_two_option}" "${axis_session_two_default}"
}

get_target_session_three() {
    get_tmux_option "${target_session_three_option}" "${target_session_three_default}"
}
set_target_session_three() {
    set_tmux_option "${target_session_three_option}" "${target_session_three_default}"
}

get_order_session_three() {
    get_tmux_option "${order_session_three_option}" "${order_session_three_default}"
}
set_order_session_three() {
    set_tmux_option "${order_session_three_option}" "${order_session_three_default}"
}

get_axis_session_three() {
    get_tmux_option "${axis_session_three_option}" "${axis_session_three_default}"
}
set_axis_session_three() {
    set_tmux_option "${axis_session_three_option}" "${axis_session_three_default}"
}


get_window_size() {
    get_tmux_option "window-size"
}

get_aggresive_resize() {
    get_tmux_option "aggresive-resize"
}

getClientWidth () {
    local target_session=$1
    echo $(tmux list-clients -t ${target_session} | awk -v clientNo=$2 'NR == clientNo { gsub(/\[/, "", $3); print $3 }' | awk -F "x" '{ print $1 }')
}
getClientHeight () {
    local target_session=$1
    echo $(tmux list-clients -t ${target_session} | awk -v clientNo=$2 'NR == clientNo { gsub(/\[/, "", $3); print $3 }' | awk -F "x" '{ print $2 }')
}
isClientFocused () {
    local target_session=$1
    echo $(tmux list-clients -t ${target_session} | awk -v clientNo=$2 'NR == clientNo { if (match($5, /focused/)) print 1; else print 0 }')
}

getTotalClients () {
    local target_session=$1
    echo $(tmux list-clients -t ${target_session} | awk 'END { print NR }')
}

getClientsWidths () {
    local target_session=$1
    declare -a clients_widths
    no_clients=$(getTotalClients ${target_session})
    for i in $(seq 1 $no_clients); do
        width=$(getClientWidth ${target_session} $i)
        clients_widths+=("$width")
    done
    echo "${clients_widths[@]}"
}

getClientsHeights () {
    local target_session=$1
    declare -a clients_heights
    no_clients=$(getTotalClients ${target_session})
    for i in $(seq 1 $no_clients); do
        height=$(getClientHeight ${target_session} $i)
        clients_heights+=("$height")
    done
    echo "${clients_heights[@]}"
}


getClientsFocused () {
    local target_session=$1
    declare -a clients_focused
    no_clients=$(getTotalClients ${target_session})
    for i in $(seq 1 $no_clients); do
        focused=$(isClientFocused ${target_session} $i)
        clients_focused+=("$focused")
    done
    echo "${clients_focused[@]}"
}


getLargestWidthClient () {
    local target_session=$1
    clients_widths=($(getClientsWidths ${target_session}))
    local max="${clients_widths[0]}"
    local maxIndex=0
    for i in "${!clients_widths[@]}"; do
        if ((${clients_widths[i]} > max)); then
          max="${clients_widths[i]}"
          maxIndex=$i
        fi
    done
    echo "$maxIndex"
}


# This functon below will return an array with the index number
# of each client according to its largest width
orderByWidth () {
    local target_session=$1
    clients_widths=($(getClientsWidths ${target_session}))
    length=${#clients_widths[@]}
    declare -a outputArray

    #Zeroing all the outputArray
    for i in $(seq 0 $((${length}-1))); do
    #for i in seq 0 ${length}; do
        outputArray+=("0 ")
    done

    for i in "${!clients_widths[@]}"; do
        for j in "${!clients_widths[@]}"; do
            if [[ ${clients_widths[i]} > ${clients_widths[j]} ]]; then
                outputArray[i]=$((outputArray[i]+1))
            fi
        done
    done
    echo ${outputArray[@]}
}

orderByHeight () {
    local target_session=$1
    clients_heights=($(getClientsHeights ${target_session}))
    length=${#clients_heights[@]}
    declare -a outputArray

    #Zeroing all the outputArray
    for i in $(seq 0 $((${length}-1))); do
    #for i in seq 0 ${length}; do
        outputArray+=("0 ")
    done

    for i in "${!clients_heights[@]}"; do
        for j in "${!clients_heights[@]}"; do
            if [[ ${clients_heights[i]} > ${clients_heights[j]} ]]; then
                outputArray[i]=$((outputArray[i]+1))
            fi
        done
    done
    echo ${outputArray[@]}
}

# This function will give you the viewport
# x and y characters of resolution for a given
# argument meaning the position of the client
# among the largest ones by 'x' width or 'y' Height
getViewportByNLargest() {
    local target_session=$1
    local n_position=$2
    local axis=$3
    if [[ $axis == 'x' ]]; then
        ordered_clients_array=($(orderByWidth ${target_session}))
    elif [[ $axis == 'y' ]]; then
        ordered_clients_array=($(orderByHeight ${target_session}))
    fi 
    for i in $(seq 0 ${#ordered_clients_array}); do
        if [[ ${ordered_clients_array[$i]} == ${n_position} ]]; then
            client_no=$i;
            break;
        fi
    done

    declare -a viewport
    clients_widths=($(getClientsWidths ${target_session}))
    viewport+=("${clients_widths[${client_no}]}")
    clients_heights=($(getClientsHeights ${target_session}))
    viewport+=("${clients_heights[${client_no}]}")

    echo ${viewport[@]}
}


echo $(getViewportByNLargest 1 1 'x')
