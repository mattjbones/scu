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
        
        entry_host="HOST $host"
        entry_hostname="HOSTNAME $hostname"
        entry_user="USER $user"
        
        echo -e "\n\tNew entry:"
        echo -e "\t\t$entry_host"
        echo -e "\t\t$entry_hostname"
        echo -e "\t\t$entry_user\n"
        read -p "        is this ok? [y/n]: " save
        case $save in 
            [y/Y]* )
                echo "Saving"
                echo -e $entry_host >> $SSH_CONFIG_FILE_LOCATION
                echo -e $entry_hostname >> $SSH_CONFIG_FILE_LOCATION
                echo -e $entry_user >> $SSH_CONFIG_FILE_LOCATION
                break;;
            [n/N]* )
                echo ""
        esac                
    done
}

get_hosts() {
    
    hosts=$(egrep "^HOST |^host |^Host " $SSH_CONFIG_FILE_LOCATION)    
    hostsArray=()
    count="0"
    for host in $hosts
    do
        res=$(( $count % 2))
        if [ ! $res -eq 0 ]
        then
            hostsArray+=($host)
        fi
        let "count++"
    done
    
    export hostsArray
}

print_hosts_with_selector() {

    if [[ "$1" == "true" ]] 
    then 
        local selector="1"
        for host in ${hostsArray[@]}
        do
            echo -e "\t\t$selector) $host"
            let "selector++"
        done
    else 
        for host in ${hostsArray[@]}
        do
            echo -e "\t\t$host"
        done
    fi
}

list_entries() {
    clear
    get_hosts
    echo -e "\n\tList of SSH Config hosts:"
    print_hosts_with_selector
    read -p "        Press any key to go back" key
    clear
}

remove_host_by_name() {
    sed "/$1$/,/^$/d" $SSH_CONFIG_FILE_LOCATION > config_tmp
    mv config_tmp $SSH_CONFIG_FILE_LOCATION
    echo -e "\t\t\tRemoved $1"
    read -p "        Press any key to go back" key
    clear    
}

remove_entry () {
    clear 
    echo ""
    get_hosts
    echo -e "\t\t0) BACK\n"
    print_hosts_with_selector "true"
    read -p "        Select host from list: " hostIndex
    if [ "$hostIndex" -eq 0 ]
    then
        return
    fi
    let "hostIndex--"
    selectedHost=${hostsArray[$hostIndex]}
    read -p "        Do you wish to remove $selectedHost [y/n]? " choice
    
    case $choice in 
        [y/Y]* )
            remove_host_by_name $selectedHost       
            ;;
        [n/N]* )
            remove_entry        
            ;;
         *)
            check_action
            ;;            
    esac
}

check_action () {
    while true
    do
        clear
        echo -e "\n\tSSH Config Updater:"
        #echo -e "\t\ta) update"
        echo -e "\t\ta) list"
        echo -e "\t\tb) add"
        echo -e "\t\tc) remove"
        echo -e "\t\t(Crtl-C to exit)"
        read -p "            " choice
        case $choice in
            [a/A]* )
                list_entries
                ;;

            [b/B]* )
                add_entry 
                ;;

            [c/C]* )
                remove_entry
                ;;
            *)
                echo -e "\t\tGoodbye"
                break 
                ;;
        esac
    done
}

main () {
    local sConfigLocation="$HOME/.ssh/config"
    
    config_file_location_check $sConfigLocation

    check_action
}

main
