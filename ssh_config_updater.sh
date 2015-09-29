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
    local check_file_ok=$?

    if [ "$check_file_ok" -eq "1" ]; then
        echo "SSH config file found"
        SSH_CONFIG_FILE_LOCATION=$1; export SSH_CONFIG_FILE_LOCATION 
    else
        echo -e "default config file not found, please enter location:"
        read sNewConfigLocation
        if [[ $sNewConfigLocation == "~"* ]]; then
            echo "expanding ~"
            sNewConfigLocation=${sNewConfigLocation/#\~/$HOME}
        fi 
        config_file_location_check $sNewConfigLocation
    fi

}

add_entry () {
    while true
    do
        clear
        echo ""
        read -p "        Enter HOST (dev_server): " host
        read -p "        Enter HOSTNAME (e.g google.com): " hostname
        read -p "        Enter USER: " user
        
        echo -e "\n\tNew entry:"
        entry_host="HOST $host"
        entry_hostname="HOSTNAME $hostname"
        entry_user="USER $user"
        echo -e "\t\t$entry_host"
        echo -e "\t\t$entry_hostname"
        echo -e "\t\t$entry_user\n"
        read -p "        is this ok? [y/n]: " save
        case $save in 
            [y/Y]* )
                echo "Saving"
                break;;
            [n/N]* )
                echo ""
        esac                
    done
}

check_action () {
    
    clear
    echo -e "\n\tSSH Config Updater:"
    echo -e "\t\ta) update"
    echo -e "\t\tb) add"
    echo -e "\t\tc) remove"
    while true
    do
        read -p "            " choice

        case $choice in
            [a/A]* )
                echo "Update Chosen"
                break;;

            [b/B]* )
                add_entry 
                break;;

            [c/C]* )
                echo "Remove Chosen"
                break;;
        esac
    done
}

main () {
    local sConfigLocation="$HOME/.ssh/config"
    
    config_file_location_check $sConfigLocation

    check_action
}

main
