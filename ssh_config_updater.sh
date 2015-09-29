#!/bin/bash
check_file_location () {
    if [ -f $1 ]; then
        return 1;
    else 
        return 0;
    fi
}

config_file_location_check () {
    
    check_file_location $1
    check_file_ok=$?

    if [ "$check_file_ok" -eq "1" ]; then
        echo "default config file found"
    else
        echo -e "default config file not found, please enter location:"
        read sNewConfigLocation
        if [[ $sNewConfigLocation == "~"* ]]; then
            echo "expanding ~"
            eval sNewConfigLocation=$sNewConfigLocation
        fi 
        config_file_location_check $sNewConfigLocation
    fi

}

main () {
    local sConfigLocation="$HOME/.ssh/confg"
    
    config_file_location_check $sConfigLocation

}

main
