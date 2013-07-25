#!/bin/bash 

set -o nounset

#################################
# COLOR OUTPUT VARIABLES
#################################
# Color   Foreground   Background
# -------------------------------
# black       30           40
# red         31           41
# green       32           42
# yellow      33           43
# blue        34           44
# magenta     35           45
# cyan        36           46
# white       37           47
#################################

# This was generated with the following short python script:

# colors = ['black', 'red', 'green', 'yellow', 'blue', 'magenta', 'cyan', 'white']; 
# index = 0
# for x in [ "{0}_FONT_{1}_BACK='\E[{2};{3}m'".format(colors[i].upper(), colors[j].upper(), i + 30, j + 40) for i in xrange(0, 8) for j in xrange(0, 8) ]: 
#     print x.ljust(38) + "#" + str(index) 
#     index += 1

readonly BLACK_FONT_BLACK_BACK='\E[30;40m'     #0
readonly BLACK_FONT_RED_BACK='\E[30;41m'       #1
readonly BLACK_FONT_GREEN_BACK='\E[30;42m'     #2
readonly BLACK_FONT_YELLOW_BACK='\E[30;43m'    #3
readonly BLACK_FONT_BLUE_BACK='\E[30;44m'      #4
readonly BLACK_FONT_MAGENTA_BACK='\E[30;45m'   #5
readonly BLACK_FONT_CYAN_BACK='\E[30;46m'      #6
readonly BLACK_FONT_WHITE_BACK='\E[30;47m'     #7
readonly RED_FONT_BLACK_BACK='\E[31;40m'       #8
readonly RED_FONT_RED_BACK='\E[31;41m'         #9
readonly RED_FONT_GREEN_BACK='\E[31;42m'       #10
readonly RED_FONT_YELLOW_BACK='\E[31;43m'      #11
readonly RED_FONT_BLUE_BACK='\E[31;44m'        #12
readonly RED_FONT_MAGENTA_BACK='\E[31;45m'     #13
readonly RED_FONT_CYAN_BACK='\E[31;46m'        #14
readonly RED_FONT_WHITE_BACK='\E[31;47m'       #15
readonly GREEN_FONT_BLACK_BACK='\E[32;40m'     #16
readonly GREEN_FONT_RED_BACK='\E[32;41m'       #17
readonly GREEN_FONT_GREEN_BACK='\E[32;42m'     #18
readonly GREEN_FONT_YELLOW_BACK='\E[32;43m'    #19
readonly GREEN_FONT_BLUE_BACK='\E[32;44m'      #20
readonly GREEN_FONT_MAGENTA_BACK='\E[32;45m'   #21
readonly GREEN_FONT_CYAN_BACK='\E[32;46m'      #22
readonly GREEN_FONT_WHITE_BACK='\E[32;47m'     #23
readonly YELLOW_FONT_BLACK_BACK='\E[33;40m'    #24
readonly YELLOW_FONT_RED_BACK='\E[33;41m'      #25
readonly YELLOW_FONT_GREEN_BACK='\E[33;42m'    #26
readonly YELLOW_FONT_YELLOW_BACK='\E[33;43m'   #27
readonly YELLOW_FONT_BLUE_BACK='\E[33;44m'     #28
readonly YELLOW_FONT_MAGENTA_BACK='\E[33;45m'  #29
readonly YELLOW_FONT_CYAN_BACK='\E[33;46m'     #30
readonly YELLOW_FONT_WHITE_BACK='\E[33;47m'    #31
readonly BLUE_FONT_BLACK_BACK='\E[34;40m'      #32
readonly BLUE_FONT_RED_BACK='\E[34;41m'        #33
readonly BLUE_FONT_GREEN_BACK='\E[34;42m'      #34
readonly BLUE_FONT_YELLOW_BACK='\E[34;43m'     #35
readonly BLUE_FONT_BLUE_BACK='\E[34;44m'       #36
readonly BLUE_FONT_MAGENTA_BACK='\E[34;45m'    #37
readonly BLUE_FONT_CYAN_BACK='\E[34;46m'       #38
readonly BLUE_FONT_WHITE_BACK='\E[34;47m'      #39
readonly MAGENTA_FONT_BLACK_BACK='\E[35;40m'   #40
readonly MAGENTA_FONT_RED_BACK='\E[35;41m'     #41
readonly MAGENTA_FONT_GREEN_BACK='\E[35;42m'   #42
readonly MAGENTA_FONT_YELLOW_BACK='\E[35;43m'  #43
readonly MAGENTA_FONT_BLUE_BACK='\E[35;44m'    #44
readonly MAGENTA_FONT_MAGENTA_BACK='\E[35;45m' #45
readonly MAGENTA_FONT_CYAN_BACK='\E[35;46m'    #46
readonly MAGENTA_FONT_WHITE_BACK='\E[35;47m'   #47
readonly CYAN_FONT_BLACK_BACK='\E[36;40m'      #48
readonly CYAN_FONT_RED_BACK='\E[36;41m'        #49
readonly CYAN_FONT_GREEN_BACK='\E[36;42m'      #50
readonly CYAN_FONT_YELLOW_BACK='\E[36;43m'     #51
readonly CYAN_FONT_BLUE_BACK='\E[36;44m'       #52
readonly CYAN_FONT_MAGENTA_BACK='\E[36;45m'    #53
readonly CYAN_FONT_CYAN_BACK='\E[36;46m'       #54
readonly CYAN_FONT_WHITE_BACK='\E[36;47m'      #55
readonly WHITE_FONT_BLACK_BACK='\E[37;40m'     #56
readonly WHITE_FONT_RED_BACK='\E[37;41m'       #57
readonly WHITE_FONT_GREEN_BACK='\E[37;42m'     #58
readonly WHITE_FONT_YELLOW_BACK='\E[37;43m'    #59
readonly WHITE_FONT_BLUE_BACK='\E[37;44m'      #60
readonly WHITE_FONT_MAGENTA_BACK='\E[37;45m'   #61
readonly WHITE_FONT_CYAN_BACK='\E[37;46m'      #62
readonly WHITE_FONT_WHITE_BACK='\E[37;47m'     #63

# This enables the bold format 
readonly ENABLE_BOLD='\E[01m'

# This restores the terminal format back to normal
readonly END_FORMAT_OUTPUT='\e[00m'

# Generated with:
#   cut -d"=" -f1 < colors.txt | xargs -i echo "\${} " | tr -d '\n' | xargs -i echo "PALLETE=( {} )"
readonly -a PALLETE=( $BLACK_FONT_BLACK_BACK $BLACK_FONT_RED_BACK $BLACK_FONT_GREEN_BACK $BLACK_FONT_YELLOW_BACK $BLACK_FONT_BLUE_BACK $BLACK_FONT_MAGENTA_BACK $BLACK_FONT_CYAN_BACK $BLACK_FONT_WHITE_BACK $RED_FONT_BLACK_BACK $RED_FONT_RED_BACK $RED_FONT_GREEN_BACK $RED_FONT_YELLOW_BACK $RED_FONT_BLUE_BACK $RED_FONT_MAGENTA_BACK $RED_FONT_CYAN_BACK $RED_FONT_WHITE_BACK $GREEN_FONT_BLACK_BACK $GREEN_FONT_RED_BACK $GREEN_FONT_GREEN_BACK $GREEN_FONT_YELLOW_BACK $GREEN_FONT_BLUE_BACK $GREEN_FONT_MAGENTA_BACK $GREEN_FONT_CYAN_BACK $GREEN_FONT_WHITE_BACK $YELLOW_FONT_BLACK_BACK $YELLOW_FONT_RED_BACK $YELLOW_FONT_GREEN_BACK $YELLOW_FONT_YELLOW_BACK $YELLOW_FONT_BLUE_BACK $YELLOW_FONT_MAGENTA_BACK $YELLOW_FONT_CYAN_BACK $YELLOW_FONT_WHITE_BACK $BLUE_FONT_BLACK_BACK $BLUE_FONT_RED_BACK $BLUE_FONT_GREEN_BACK $BLUE_FONT_YELLOW_BACK $BLUE_FONT_BLUE_BACK $BLUE_FONT_MAGENTA_BACK $BLUE_FONT_CYAN_BACK $BLUE_FONT_WHITE_BACK $MAGENTA_FONT_BLACK_BACK $MAGENTA_FONT_RED_BACK $MAGENTA_FONT_GREEN_BACK $MAGENTA_FONT_YELLOW_BACK $MAGENTA_FONT_BLUE_BACK $MAGENTA_FONT_MAGENTA_BACK $MAGENTA_FONT_CYAN_BACK $MAGENTA_FONT_WHITE_BACK $CYAN_FONT_BLACK_BACK $CYAN_FONT_RED_BACK $CYAN_FONT_GREEN_BACK $CYAN_FONT_YELLOW_BACK $CYAN_FONT_BLUE_BACK $CYAN_FONT_MAGENTA_BACK $CYAN_FONT_CYAN_BACK $CYAN_FONT_WHITE_BACK $WHITE_FONT_BLACK_BACK $WHITE_FONT_RED_BACK $WHITE_FONT_GREEN_BACK $WHITE_FONT_YELLOW_BACK $WHITE_FONT_BLUE_BACK $WHITE_FONT_MAGENTA_BACK $WHITE_FONT_CYAN_BACK $WHITE_FONT_WHITE_BACK )

function enableColor() {
   echo -ne $1
}

function clearScreen() {
	tput clear
}

function enableBold() {
	echo -ne $ENABLE_BOLD
}

function gotoXY() {
   local ROW=$2
   local COL=$1
   tput cup "$ROW" "$COL"
}

function restoreTerminalFormat() {
	echo -ne $END_FORMAT_OUTPUT
}

function drawColoredStringAt() {
    local TEXT=$1
    local COLOR=$2
    gotoXY $3 $4
    echo -e "${COLOR}${TEXT}${END_FORMAT_OUTPUT}"
} 

function writePixelIndexAtXY() {
    gotoXY $1 $2 
    echo "$PALLETE[$3] $END_FORMAT_OUTPUT"
}

function getScreenWidth() { 
    echo $(tput cols)
}

function getScreenHeight() { 
    echo $(tput lines)
}

function setTerminalTitle() {
    local TITLE="$1"
    # The space character, followed by the title and the ring bell char (007)
    printf "\e]0;$TITLE\007"
}

function disableCursor() {
    printf "\e[?25l"
}

function enableCursor() {
	printf "\e[?12l\e[?25h"
}

