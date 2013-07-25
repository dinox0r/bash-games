#!/bin/bash 

function existProgram() {
    type "$1" >/dev/null 2>&1
}

function isSoundAvailable() {
    if existProgram "paplay"; then
        return $(true; echo $?)
    else
        return $(false; echo $?)
    fi
}
