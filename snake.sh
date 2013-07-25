#!/bin/bash

set -o nounset

# include "util.sh" 
source `dirname $0`/"util.sh"

# include "io.sh" 
source `dirname $0`/"io.sh"

# include "graphics.sh" 
source `dirname $0`/"graphics.sh"

WALL_THICK=1
WIDTH=$(( $(getScreenWidth) - 2 * $WALL_THICK ))
HEIGHT=$(( $(getScreenHeight) - 3 * $WALL_THICK ))

MID_X=$(( $WIDTH / 2 ))
MID_Y=$(( $HEIGHT / 2 ))

OFFSETS_X=( 0 0 1 -1 )
OFFSETS_Y=( -1 1 0 0 )

SNAKE_X=($MID_X $MID_X $MID_X $MID_X)
SNAKE_Y=($MID_Y $(( $MID_Y + 1 )) $(( $MID_Y + 2 )) $(( $MID_Y + 3 )))

FOOD_X=
FOOD_Y=

WIN=$(false; echo $?)
GAME_OVER=$(false; echo $?)
DIRECTION=0
VELOCITY=1

GAME_SPEED=0.2
TOTAL_ATE=0

POISON_X=( )
POISON_Y=( )

UP=0
DOWN=1
LEFT=3
RIGHT=2

function log() {
    echo -e "$1" >> snake.log
}

function drawBoard() {
    local HORIZONTAL_WALL_THICK=$(printf "%${WALL_THICK}s")
    local LINE=$(printf "%${WIDTH}s")

	local B=$BLUE_FONT_BLUE_BACK
	local W=$CYAN_FONT_CYAN_BACK

    if [ "$GAME_OVER" -eq 0 ]; then
	    B=$MAGENTA_FONT_MAGENTA_BACK
	    W=$WHITE_FONT_WHITE_BACK
    fi

	gotoXY 0 0

    # Top border
    for i in $(seq 0 $(( $WALL_THICK - 1 )) ); do
        echo -e "${W}${HORIZONTAL_WALL_THICK}${LINE}${HORIZONTAL_WALL_THICK}"
    done
    
    # Left right border and background
    for y in $( seq 0 $(($HEIGHT - 1)) ); do
        echo -e "${W}${HORIZONTAL_WALL_THICK}${B}${LINE}${W}${HORIZONTAL_WALL_THICK}"
    done
    
    # Bottom border    
    for i in $(seq 0 $(( $WALL_THICK - 1 )) ); do
        echo -e "${W}${HORIZONTAL_WALL_THICK}${LINE}${HORIZONTAL_WALL_THICK}"
    done
}

function drawSnake() {
    local SNAKE_LEN=${#SNAKE_X[@]}
    
	local Y=$1
	if [ "$GAME_OVER" -eq 0 ]; then 
	    Y=$RED_FONT_RED_BACK
	fi
    
    for i in $(seq 0 $(( $SNAKE_LEN - 1)) ); do
        gotoXY "${SNAKE_X[$i]}" "${SNAKE_Y[$i]}"
        echo -e "${ENABLE_BOLD}${Y} "
    done
}

function drawFood() {
	gotoXY "$FOOD_X" "$FOOD_Y"
	echo -e "$GREEN_FONT_GREEN_BACK ";
}

function exitGame() {
	tput sgr0
    setBlockingReadMode
    clearScreen
    enableCursor
    exit 0
}

function moveSnake() {
    local SNAKE_LEN=${#SNAKE_X[@]}
    local LAST_ELEMENT_INDEX=$(( $SNAKE_LEN - 1 ))

    # Delete snake tail, painting with the background color
    gotoXY "${SNAKE_X[$LAST_ELEMENT_INDEX]}" "${SNAKE_Y[$LAST_ELEMENT_INDEX]}"
    echo -e "${ENABLE_BOLD}${BLUE_FONT_BLUE_BACK} "

    local OFFSET_X=${OFFSETS_X[$DIRECTION]}
    local OFFSET_Y=${OFFSETS_Y[$DIRECTION]}

    local j=0
    if [ $SNAKE_LEN -gt 1 ]; then
        for i in $( seq $LAST_ELEMENT_INDEX -1 1 ); do
            let j=i-1
            SNAKE_X[$i]=${SNAKE_X[$j]}
            SNAKE_Y[$i]=${SNAKE_Y[$j]}
        done
    fi

    SNAKE_X[0]=$(( ${SNAKE_X[0]} + $OFFSET_X ))
    SNAKE_Y[0]=$(( ${SNAKE_Y[0]} + $OFFSET_Y ))
    
    drawSnake $YELLOW_FONT_YELLOW_BACK
}

function moveSnakeHeadBack() {
    local SNAKE_LEN=${#SNAKE_X[@]}

    if [ $SNAKE_LEN -gt 1 ]; then
        SNAKE_X[0]=${SNAKE_X[1]}
        SNAKE_Y[0]=${SNAKE_Y[1]}
    else
        local OPOSSITE_DIRECTION
        case "$DIRECTION" in
        "$UP")
            OPOSSITE_DIRECTION=$DOWN
        ;;
        "$DOWN")        
            OPOSSITE_DIRECTION=$UP
        ;;
        "$LEFT")
            OPOSSITE_DIRECTION=$RIGHT        
        ;;
        "$RIGHT")
            OPOSSITE_DIRECTION=$LEFT
        ;;
        esac
        
        local OFFSET_X=${OFFSETS_X[$OPOSSITE_DIRECTION]}
        local OFFSET_Y=${OFFSETS_Y[$OPOSSITE_DIRECTION]}

        SNAKE_X[0]=$(( ${SNAKE_X[0]} + $OFFSET_X ))
        SNAKE_Y[0]=$(( ${SNAKE_Y[0]} + $OFFSET_Y ))
    fi
}

function processInput() {
    read -s -t 10 ARROW
    
    case "$ARROW" in
    "$KEY_UP" | "$KEY_UP_2" | "$KEY_UP_ASCII" | "$KEY_UP_ASCII_UPPER")
            if [ $DIRECTION -ne $DOWN ]; then
                DIRECTION=$UP
            fi
        ;;
    "$KEY_DOWN" | "$KEY_DOWN_2" | "$KEY_DOWN_ASCII" | "$KEY_DOWN_ASCII_UPPER")
            if [ $DIRECTION -ne $UP ]; then
                DIRECTION=$DOWN
            fi    
        ;;
    "$KEY_RIGHT" | "$KEY_RIGHT_2" | "$KEY_RIGHT_ASCII" | "$KEY_RIGHT_ASCII_UPPER")
            if [ $DIRECTION -ne $LEFT ]; then
                DIRECTION=$RIGHT
            fi    
        ;;
    "$KEY_LEFT" | "$KEY_LEFT_2" | "$KEY_LEFT_ASCII" | "$KEY_LEFT_ASCII_UPPER")
            if [ $DIRECTION -ne $RIGHT ]; then
                DIRECTION=$LEFT
            fi    
        ;;
    $'\e')
            exitGame
        ;;

    esac
}

function isPointInsideSnakeBody() {
    local X_COORD="$1"
    local Y_COORD="$2"
    local START_POSITION="$3"

    local SNAKE_LEN=${#SNAKE_X[@]}
    local LAST_ELEMENT_INDEX=$(( $SNAKE_LEN - 1 ))

    for i in $( seq $START_POSITION $LAST_ELEMENT_INDEX ); do
        if [ ${SNAKE_X[$i]} -eq $X_COORD -a ${SNAKE_Y[$i]} -eq $Y_COORD ]; then
            return $(true; echo $?)
        fi
    done
    return $(false; echo $?)   
}

# Generates a new random position for the food 
# if the position is ocuppied by the snake or a poisson, is 
# recursively generated again
function generateRandomFoodPosition() {
    FOOD_X=$(( ($RANDOM % ($WIDTH - 1)) + $WALL_THICK ))
    FOOD_Y=$(( ($RANDOM % ($HEIGHT - 1)) + $WALL_THICK ))
    
    if isPointInsideSnakeBody "$FOOD_X" "$FOOD_Y" 0; then
        # Search for another point
        generateRandomFoodPosition
    fi
    
    if isPointInsidePoison "$FOOD_X" "$FOOD_Y"; then 
        # Search for another point
        generateRandomFoodPosition    
    fi 
}

# Add a new poison element to the board
function addPoison() {
    local POISON_LEN=${#POISON_X[@]}
    
    local PX=${SNAKE_X[0]}
    local PY=${SNAKE_Y[0]}
    while [ $PX == ${SNAKE_X[0]} -a $PY == ${SNAKE_Y[0]} ]; do
        PX=$(( $WALL_THICK + ($RANDOM % ($WIDTH - 1)) ))
        PY=$(( $WALL_THICK + ($RANDOM % ($HEIGHT - 1)) ))            
    done
    POISON_X[$POISON_LEN]=$PX
    POISON_Y[$POISON_LEN]=$PY
}

# Increments the snake body and spawns a new food element in the board
function eat() {
    # Increment snake body by 1

    local SNAKE_LEN=${#SNAKE_X[@]}
    local LAST_ELEMENT_INDEX=$(( $SNAKE_LEN - 1 ))

    SNAKE_X[$SNAKE_LEN]=${SNAKE_X[$LAST_ELEMENT_INDEX]}
    SNAKE_Y[$SNAKE_LEN]=${SNAKE_Y[$LAST_ELEMENT_INDEX]}

    let TOTAL_ATE++
    GAME_SPEED=$(bc -l <<< "$GAME_SPEED - 0.001")

    generateRandomFoodPosition
    addPoison
}

# Checks if the the passed coordinates are in one of the poisson elements
function isPointInsidePoison() {
    local X_COORD="$1"
    local Y_COORD="$2"

    local POISON_LEN=${#POISON_X[@]}
    local POISON_MAX_INDEX=$(( $POISON_LEN - 1 ))

    for i in $(seq 0 $POISON_MAX_INDEX); do
        if [ $X_COORD -eq ${POISON_X[$i]} -a $Y_COORD -eq ${POISON_Y[$i]} ]; then
            return $(true; echo $?)
        fi
    done
    return $(false; echo $?)      
}

function checkCollisions() {
    local HEAD_X=${SNAKE_X[0]}
    local HEAD_Y=${SNAKE_Y[0]}

    # Check againts walls
    local LEFT_BOUND=$WALL_THICK
    local RIGHT_BOUND=$(($WALL_THICK + $WIDTH))
    local TOP_BOUND=$WALL_THICK
    local BOTTOM_BOUND=$(($WALL_THICK + $HEIGHT))

    if [ $HEAD_X -lt $LEFT_BOUND -o $HEAD_X -ge $RIGHT_BOUND -o $HEAD_Y -lt $TOP_BOUND -o $HEAD_Y -ge $BOTTOM_BOUND ]; then
        moveSnakeHeadBack        
        GAME_OVER=$(true; echo $?)
        drawBoard
    fi

    # Check againts snake body
    if isPointInsideSnakeBody "$HEAD_X" "$HEAD_Y" 1; then
        GAME_OVER=$(true; echo $?)
        drawBoard
    fi
    
    # Check if snake ate poison
    if isPointInsidePoison "$HEAD_X" "$HEAD_Y" ; then
        GAME_OVER=$(true; echo $?)
        drawBoard        
    fi 
        
    if [ $HEAD_X -eq $FOOD_X -a $HEAD_Y -eq $FOOD_Y ]; then    
        eat
    fi
}

function setInitialPoison() {
    local POISON_INITIAL_LEN=$(( ($RANDOM % 20) + 10 ))

    for i in $(seq 0 $POISON_INITIAL_LEN); do
        local PX=$MID_X
        local PY=$MID_Y
        while [ $PX == $MID_X -a $PY == $MID_Y ]; do
            PX=$(( $WALL_THICK + ($RANDOM % ($WIDTH - 1)) ))
            PY=$(( $WALL_THICK + ($RANDOM % ($HEIGHT - 1)) ))            
        done
        POISON_X[$i]=$PX
        POISON_Y[$i]=$PY
    done
}

function drawPoison() {
    local POISON_LEN=${#POISON_X[@]}
    local POISON_MAX_INDEX=$(( $POISON_LEN - 1 ))
    local R=$RED_FONT_RED_BACK
    local E=$END_FORMAT_OUTPUT
    for i in $(seq 0 $POISON_MAX_INDEX); do
        gotoXY ${POISON_X[$i]} ${POISON_Y[$i]}
        echo -e "$R $E"
    done
}

function snake() {
    # Perform a nonblocking I/O read to consume "extra" keystrokes (e.g., the user holds a key)
    setNonBlockingReadMode
    disableCursor
    trap exitGame ERR EXIT 
    
    generateRandomFoodPosition
    setInitialPoison
    gotoXY 0 0
    drawBoard
    
    while [ true ]; do
        drawFood
        drawPoison
        drawSnake $YELLOW_FONT_YELLOW_BACK
        restoreTerminalFormat

        if [ "$GAME_OVER" -eq 1 ]; then
            processInput
            moveSnake

            checkCollisions
        fi

        sleep $GAME_SPEED
                
        # Consume queued unnecessary keystroke events (e.g, if user holds the key)
        # read 
    done
    
    setBlockingReadMode
}

>snake.log
log "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\nSnake!!!\n"
snake
