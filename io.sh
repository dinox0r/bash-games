#!/bin/bash 

KEY_UP=$'\e[A'
KEY_DOWN=$'\e[B'
KEY_RIGHT=$'\e[C'
KEY_LEFT=$'\e[D'

KEY_UP_2=$'\e[0A'
KEY_DOWN_2=$'\e[0B'
KEY_RIGHT_2=$'\e[0C'
KEY_LEFT_2=$'\e[0D'

KEY_UP_ASCII='w'
KEY_DOWN_ASCII='s'
KEY_RIGHT_ASCII='d'
KEY_LEFT_ASCII='a'

KEY_UP_ASCII_UPPER='W'
KEY_DOWN_ASCII_UPPER='S'
KEY_RIGHT_ASCII_UPPER='D'
KEY_LEFT_ASCII_UPPER='A'

function setBlockingReadMode() {
    if [ -t 0 ]; then
        stty sane
    fi
}

function setNonBlockingReadMode() { 
    if [ -t 0 ]; then
        stty -echo -icanon time 0 min 0
    fi
}
