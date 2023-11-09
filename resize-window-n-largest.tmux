#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/scripts/helpers.sh"
source "$CURRENT_DIR/scripts/variables.sh"

set_hooks() {
    if [[ $(get_plugin_active)  == '1' ]] then
        if [[ $(get_target_session_one) != 'none' ]] then
            echo $(get_target_session_one)
            echo $(get_order_session_one)
            echo $(get_axis_session_one)
            viewport=($(getViewportByNLargest \$$(get_target_session_one) $(get_order_session_one) $(get_axis_session_one)))
#            tmux resize-window -x ${viewport[0]} -y ${viewport[1]}"\"
#            tmux set-hook -t \$$(get_target_session_one) after-select-window[0] \""resize-window -x ${viewport[0]} -y ${viewport[1]}"\"
#            tmux set-hook -t $(get_target_session_one) after-select-window[0] \""resize-window -x ${viewport[0]} -y ${viewport[1]}"\"
            tmux set-hook -t $(get_target_session_one) after-select-window\[0\] \""resize-window -x ${viewport[0]} -y ${viewport[1]}"\"
        fi
    else
        tmux set-hook -gu after-select-window[0]
        no_windows=$(($(tmux list-windows -t 0 | wc -l) - 1))
        for i in $(seq 0 ${no_windows}); do 
            tmux set-option -t 0:$i "window-size" $(get_window_size)
            tmux set-option -t 0:$i "aggressive-resize" $(get_aggresive_resize)
        done
    fi
}


main () {
    set_hooks
}
main
