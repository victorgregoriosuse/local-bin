#!/bin/bash

USAGE="${0##*/} [ -p | -d ] [ img | con | all ]"

# args required
[[ -z $@ ]] && echo -en "${USAGE}\n" && exit 1

# wipes docker or podman containers, images, or both (all)
for arg in "$@"; do
    case $arg in
        "-d")
            CONTCMD="docker"
            shift
            ;;
        "-p")
            CONTCMD="sudo podman"
            shift
            ;;
        "all")
            CLEANCONT=1
            CLEANINST=1
            shift
            ;;
        "con")
            CLEANCONT=1
            shift
            ;;
        "img")
            CLEANINST=1
            shift
            ;;
        *)
            echo -en "${USAGE}\n" && exit 1
            ;;
    esac
done

RETVAL=0
ENGINE=${CONTCMD#sudo\ *}
if [[ $RETVAL -eq 0 ]] && [[ $CLEANCONT -eq 1 ]]; then
    echo -en "=== Stopping $ENGINE containers...\n"
    for x in $($CONTCMD ps | awk '{ print $1 }' | egrep -vw CONTAINER); do $CONTCMD stop $x; done
    RETVAL=$?

    if [ $RETVAL -eq 0 ]; then
        echo -en "=== Removing $ENGINE containers...\n"
        for x in $($CONTCMD ps -a | awk '{ print $1 }' | egrep -vw CONTAINER); do $CONTCMD rm $x; done
        RETVAL=$?
    fi
fi

if [[ $RETVAL -eq 0 ]] && [[ $CLEANINST -eq 1 ]]; then
    echo -en "=== Removing $ENGINE images...\n"
    for x in $($CONTCMD image ls -a | awk '{ print $3 }' | egrep -vw IMAGE); do $CONTCMD rmi $x; done
    RETVAL=$?
fi

exit $RETVAL
