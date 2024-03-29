#!/bin/bash
# ---------------------------------------------------------------------------- #
#                                   arguments                                  #
# ---------------------------------------------------------------------------- #
# ---------------------------- nombre d'arguments' --------------------------- #
function L_args_count() {
    echo "$1"
} 
# ---------------------------------------------------------------------------- #
#                                  interaction                                 #
# ---------------------------------------------------------------------------- #
# -------------------------- question par yes ou non ------------------------- #
# Ask a yes/no question
# @param $1 question
# @param $2 default answer (y/n)
# @return true or false
# echo $(L_question_yes_no "on efface?" n)
function L_question_yes_no() {
    local question="$1"
    local default="$2"
    local answer
    local valid
    while true; do
        read -p "$question [$default] " answer
        if [ -z "$answer" ]; then
            answer="$default"
        fi
        case "$answer" in
            [Yy]* ) valid=true; break;;
            [Nn]* ) valid=false; break;;
        esac
    done
    echo "$valid"
}
# ------------------------ question attend une réponse ----------------------- #
function L_question()
{
    local question="$1"
    local default="$2"
    local answer
    local valid
    local tdefault
    if [[ $# -gt 0 ]]
    then 
    tdefault=""
    else
    tdefault="[$default]"
    fi
    
        read -p "$question $tdefault " answer
        if [ -z "$answer" ]; then
            answer="$default"
        fi
        echo "$answer"
}
# ----------------------------------- choix ---------------------------------- #
# selections=(
# "PC"
# "Téléphone"
# )
# L_choice "Mettre le ttl pour " selected_choice "${selections[@]}"
# if [[ $selected_choice == 0 ]]
# then
# echo "PC"
# else
# echo "Téléphone"
# fi

 function L_choice()
 {
 local prompt="$1" outvar="$2"
    shift
    shift
    local options=("$@") cur=0 count=${#options[@]} index=0
    local esc=$(echo -en "\e") # cache ESC as test doesn't allow esc codes
    printf "$prompt\n"
    while true
    do
        # list all options (option list is zero-based)
        index=0 
        for o in "${options[@]}"
        do
            if [ "$index" == "$cur" ]
            then echo -e " >\e[7m$o\e[0m" # mark & highlight the current option
            else echo "  $o"
            fi
            index=$(( $index + 1 ))
        done
        read -s -n3 key # wait for user to key in arrows or ENTER
        if [[ $key == $esc[A ]] # up arrow
        then cur=$(( $cur - 1 ))
            [ "$cur" -lt 0 ] && cur=0
        elif [[ $key == $esc[B ]] # down arrow
        then cur=$(( $cur + 1 ))
            [ "$cur" -ge $count ] && cur=$(( $count - 1 ))
        elif [[ $key == "" ]] # nothing, i.e the read delimiter - ENTER
        then break
        fi
        echo -en "\e[${count}A" # go up to the beginning to re-render
    done
    # export the selection to the requested output variable
    printf -v $outvar "$cur"
    }