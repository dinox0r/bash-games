#!/bin/bash

set -o nounset

# include "util.sh" 
source `dirname $0`/"util.sh"

# include "io.sh" 
source `dirname $0`/"io.sh"

# include "graphics.sh" 
source `dirname $0`/"graphics.sh"

PHRASES=( "all your base are belong to us" "rome was not built in one day" "nuclear launch detected" "i am convinced that he does not play dice" "drastic times call for drastic measures" "a penny saved is a penny earned" "without music life would be a mistake""software sucks because users demand it to" "java is to javascript what car is to carpet" "actions speak louder than words" "never bite the hand that feeds you" "a house divided against itself cannot stand" "boredom is a great motivator" )
PHRASES_COUNT=${#PHRASES[@]}
HIDDEN_MESSAGE=""
MASKED_MESSAGE=""
MASK_CHAR="-"
MISTAKES_COUNT=0
WIN=$(false; echo $?)
GAME_OVER=$(false; echo $?)

function drawGameOverText() {
    enableBold
    drawColoredStringAt " GAME OVER... " "$RED_FONT_WHITE_BACK" 1 1
    restoreTerminalFormat
}

function drawWinnerText() {
    enableBold
    drawColoredStringAt " YOU WON! You saved a man's life, feel proud!" "$BLUE_FONT_WHITE_BACK" 1 1
    restoreTerminalFormat
}

function drawHangedMan() {
    if [ $WIN -eq 0 ]; then
        return 1
    fi

	local Y=$YELLOW_FONT_BLUE_BACK
	local E=$END_FORMAT_OUTPUT

    if [ "$MISTAKES_COUNT" -ge 1 ]; then
        gotoXY 39 4
        echo -e "${Y} o ${E}"
    fi

    if [ "$MISTAKES_COUNT" -ge 2 ]; then
        gotoXY 39 5
        echo -e "${Y} | ${E}"
        gotoXY 39 6
        echo -e "${Y} | ${E}"
    fi

    if [ "$MISTAKES_COUNT" -ge 3 ]; then
        gotoXY 39 5
        echo -e "${Y}/|\\ ${E}"
        gotoXY 39 6
        echo -e "${Y} | ${E}"
    fi 

    if [ "$MISTAKES_COUNT" -ge 4 ]; then
        gotoXY 39 7
        echo -e "${Y}/ \\ ${E}"
        
        enableBold
        drawColoredStringAt " GAME OVER... " "$RED_FONT_WHITE_BACK" 1 1
        restoreTerminalFormat
    fi 

    return 0
}

function victory() {
	local Y=$YELLOW_FONT_BLUE_BACK
	local E=$END_FORMAT_OUTPUT
    
    gotoXY 29 5
    echo -e "${Y}\o/${E}"        
    gotoXY 29 6        
    echo -e "${Y} | ${E}"
    gotoXY 29 7        
    echo -e "${Y} | ${E}"
    gotoXY 29 8 
    echo -e "${Y}/ \\ ${E}"

    drawWinnerText

    if isSoundAvailable; then
        paplay `dirname $0`/"good.wav"
    fi
}

function drawColoredLine() {
    local WIDE_LINE="                                                          "
	enableColor $1
    echo "$WIDE_LINE"
}

function drawBackground() {
	local Y=$YELLOW_FONT_YELLOW_BACK
	local B=$BLUE_FONT_BLUE_BACK
	local R=$RED_FONT_BLUE_BACK	

	gotoXY 0 0

    drawColoredLine $BLUE_FONT_BLUE_BACK
    drawColoredLine $BLUE_FONT_BLUE_BACK

    echo -e "$B                                        $Y         $B         "
    echo -e "$B                                        $R|      $Y  $B         "
    echo -e "$B                                        ${R}O      $Y  $B         "
    echo -e "$B                                               $Y  $B         "
    echo -e "$B                                               $Y  $B         "
    echo -e "$B                                               $Y  $B         "
    echo -e "$B                                              $Y    $B        "

    for i in {1..6}; do 
        drawColoredLine $WHITE_FONT_WHITE_BACK
    done

	restoreTerminalFormat
}

function chooseRandomHiddenPhrase() {
    HIDDEN_MESSAGE=${PHRASES[$(( $RANDOM % PHRASES_COUNT ))]} 
    MASKED_MESSAGE=$(tr '[A-Za-z0-9]' "$MASK_CHAR" <<< "$HIDDEN_MESSAGE")
}

function drawMaskedText() {
    local PROMPT="Message: "
    enableBold
    drawColoredStringAt "$PROMPT" "$BLACK_FONT_WHITE_BACK" 3 10
    drawColoredStringAt "$MASKED_MESSAGE" "$RED_FONT_WHITE_BACK" $(( $(expr length $PROMPT) + 4 )) 10
    restoreTerminalFormat    
} 

function drawPrompt() {
    drawColoredStringAt "Type a letter [a-z]..." "$BLACK_FONT_WHITE_BACK" 3 12
}

function drawErrorPromptMessage() {
    drawColoredStringAt "$1" "$RED_FONT_WHITE_BACK" 3 12
    
    if isSoundAvailable; then
        paplay `dirname $0`/"bell.oga"
    else 
        sleep 3
    fi
}

function isValidInput() {
    local LETTER_UPPER=$(tr 'a-z' 'A-Z' <<< "$1")
    grep -q "[A-Z]" <<< "$LETTER_UPPER"
}

function isInHiddenMessage() {
    local LETTER="$1"
    local HIDDEN_MESSAGE_LEN=$(expr length "$HIDDEN_MESSAGE")
   
    for i in $( seq 0 $(( $HIDDEN_MESSAGE_LEN - 1 )) ); do 
        CHAR=${HIDDEN_MESSAGE:$i:1}
        if [ "$CHAR" == "$LETTER" ]; then 
            return $(true; echo $?)
        fi
    done
    return $(false; echo $?)
}

function uncoverLetterInHiddenMessage() {
    local LETTER="$1"
    local HIDDEN_MESSAGE_LEN=$(expr length "$HIDDEN_MESSAGE")

    for i in $( seq 0 $(( $HIDDEN_MESSAGE_LEN - 1 )) ); do 
        CHAR=${HIDDEN_MESSAGE:$i:1}

        local POS=$(( $i + 1 ))

        if [ "$CHAR" == "$LETTER" ]; then 
            # Taken from: http://stackoverflow.com/questions/9318021/change-string-char-at-index-x
            
            MASKED_MESSAGE="${MASKED_MESSAGE:0:$i}$LETTER${MASKED_MESSAGE:$POS}"
        fi
    done
}

function revealMaskedText() {
    MASKED_MESSAGE=$HIDDEN_MESSAGE
    drawMaskedText
}

function exitGame() {
    setBlockingReadMode
    clear 
    exit 0
}

function startAgain() {
    chooseRandomHiddenPhrase
    MISTAKES_COUNT=0
    WIN=$(false; echo $?)
    GAME_OVER=$(false; echo $?)    
}

function playAgainPrompt() {
    drawColoredStringAt " Play again? (y/n)... " "$BLUE_FONT_WHITE_BACK" 1 3
    
    local OPTION=""            
    while [ "$OPTION" != $'\e' -a "$OPTION" != "y" -a "$OPTION" != "n" -a "$OPTION" != "Y" -a "$OPTION" != "N" ]; do
        read -s -n 1 OPTION
    done

    if [ "$OPTION" == "y" -o "$OPTION" == "Y" ]; then 
        startAgain
    else 
        exitGame
    fi    
}

function drawExitCommand() {
    drawColoredStringAt "(Press ESC to exit)" "$GREEN_FONT_WHITE_BACK" 39 14
}

function won() {
    grep -q "$MASK_CHAR" <<< "$MASKED_MESSAGE"
    if [ $? -eq 0 ]; then
        return $(false; echo $?)
    else 
        return $(true; echo $?)
    fi
}

function gameLoop() {
    local LETTER=""
    
    while [ true ]; do
	    clearScreen
	    drawBackground
        drawMaskedText
        drawHangedMan

        if [ "$GAME_OVER" -eq 1 ]; then
            drawPrompt
            drawExitCommand

            setBlockingReadMode
            gotoXY 0 13            
            read -s -n 1 LETTER
            
            if [ "$LETTER" == $'\e' ]; then 
                exitGame
            fi 

            # Check if the typed LETTER is valid
            # (this part is taken from: http://stackoverflow.com/questions/8117822/in-bash-can-you-use-a-function-call-as-a-condition-in-an-if-statement)
            if isValidInput "$LETTER"; then
                # Check if the typed LETTER is in the hidden message
                if isInHiddenMessage "$LETTER"; then
                    uncoverLetterInHiddenMessage "$LETTER"
                    
                    if won; then
                        WIN=$(true; echo $?)
                    fi
                else
                    drawErrorPromptMessage "Incorrect letter!          "
                    MISTAKES_COUNT=$(($MISTAKES_COUNT + 1))
                    if [ "$MISTAKES_COUNT" -ge 4 ]; then 
                        GAME_OVER=$(true; echo $?)
                    fi
                fi
            else
                drawErrorPromptMessage "Invalid input! Please try again"
            fi
            
            # Perform a nonblocking I/O read to consume "extra" keystrokes (e.g., the user holds a key)
            setNonBlockingReadMode
            # Consume queued unnecessary keystroke events (e.g, if user holds the key)            
            read
        else 
            revealMaskedText
            sleep 2
            playAgainPrompt
        fi   
        
        if [ "$WIN" -eq 0 ]; then
            victory
            sleep 2
            playAgainPrompt
        fi          
    done
}

function hangMan() {
    chooseRandomHiddenPhrase

    gameLoop
}

hangMan
