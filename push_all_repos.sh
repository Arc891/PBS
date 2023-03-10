#!/bin/env bash

PBS="$HOME/.config/pbs/"

REPOS_FILE=$PBS"repos_to_push"
BACKUP_FILE=$PBS"old_repos"

find_repos() {
    echo "Finding all .git folders...";
    if [ ! -d $PBS ]; then mkdir $PBS; fi;
    if [ -f $REPOS_FILE ]; then
        cat $REPOS_FILE;
        read -p "Do you want to update this list of repos? [y/N] " conf;
        if   [ "$conf" == "n" ] || [ "$conf" == "N" ]; then
            echo "Stopped updating repos file."
            return;
        elif [ "$conf" != "y" ] && [ "$conf" != "Y" ]; then
            echo "Invalid option, aborting...";
            return;
        else 
            echo "Looking for all repos...";
        fi
    fi

    repos=$(sudo find / -name .git);
    
    if [ ! -f $BACKUP_FILE ]; then touch $BACKUP_FILE; fi;
    cp $REPOS_FILE $BACKUP_FILE;
    if [ -f $REPOS_FILE ]; then rm $REPOS_FILE; touch $REPOS_FILE; fi;
    printf "" > $REPOS_FILE;

    for n in $repos; do
        cd $n/..;
        printf "\n\n";
        echo "Foud repo in $(pwd)";
        git status;
        valid="no";
        while [ "$valid" != "yes" ]; do 
            read -p "Do you want to add this repo ($(pwd))? [y/n]: " to_add;
            
            if [ "$to_add" == "y" ] || [ "$to_add" == "Y" ]; then
                echo $(pwd) >> $REPOS_FILE;
                echo "$(pwd) added.";
                valid="yes";
            elif [ "$to_add" == "n" ] || [ "$to_add" == "N" ]; then
                echo "Skipping...";
                valid="yes";
            else
                valid="no";
            fi
        done
    done

    echo "Final list: ";
    cat $REPOS_FILE;
}

quick_push() {
    git add .;
    git commit -m "Quick push before shutdown";
    git pull;
    git push;
}

push_repos() {
    
    for d in $(cat $REPOS_FILE); do    
        cd $d;

        if [ "$1" == "-f" ]; then
            quick_push;
            continue;
        fi

        echo "In repo $d";
        git status;

        read -p "What to add? [A]ll/[f]ast add & push/[s]pecific/[n]one: " to_add;
        
        if   [ "$to_add" == "a" ] || [ "$to_add" == "A" ]; then
            git add .;
        elif [ "$to_add" == "f" ] || [ "$to_add" == "F" ]; then
            quick_push;
            continue;
        elif [ "$to_add" == "s" ] || [ "$to_add" == "S" ]; then
            while [ "$f" != "q" ]; do
                read -p "Type the file(s) you'd like to add (q to stop): " to_add;
                if [ -f ./"$to_add" ] || [ -d ./"$to_add" ]; then
                    git add $to_add;
                elif [ "$to_add" == "q" ]; then
                    break;
                else
                    echo "No such file found";
                fi
            done
        elif [ "$to_add" == "n" ] || [ "$to_add" == "N" ]; then
            continue;
        else 
            git add .;
        fi
        
        read -p "Enter a commit message: " msg;
        
        git commit -m "$msg";
        git pull;
        git push;
    done
}

find_repos;
sleep 1;
read -p "Continue? [y/n]: " conf;
[ "$conf" == "y" ] && push_repos || echo "Aborting pushes...";