#!/usr/bin/env bash

# Configuration
USERNAME="vs4vijay"
SUFFIX="H"
DOMAIN="googlemail.com"
NAMES=(X Vijay Soni)
COUNTRY="US"
STATE="CA"
POSTALCODE="94025"
DELAY=1

usage() { 
  echo "Usage: $0 -e <email> [-s <suffix>] [-l <no-of-loops>] [-d <delay>] [-t]" 1>&2; 
  exit 1; 
}

changeTorNode() {
  echo -e 'AUTHENTICATE ""\r\nsignal NEWNYM\r\nQUIT' | nc 127.0.0.1 9051
}

handleQuit() {
  # echo ""
  printInfo "[*] $count request sent for Email($EMAIL)"
  printInfo "[*] PID: $$, Seconds: $SECONDS"
  times
}

handleExit() {
  handleQuit
}

printSuccess() {
  echo "${COLOR_SUCCESS}$1${COLOR_END}"
}

printInfo() {
  echo "${COLOR_INFO}$1${COLOR_END}"
}

printNormal() {
  echo "${COLOR_NORMAL}$1${COLOR_END}"
}

printError() {
  echo "${COLOR_ERROR}$1${COLOR_END}"
}

while getopts "e:s:d:t" opt; do
  case $opt in
    e)
      EMAIL=$OPTARG
      USERNAME=$(echo $EMAIL | cut -d "@" -f 1)
      DOMAIN=$(echo $EMAIL | cut -d "@" -f 2)
      echo "To Email: $EMAIL" >&2
      ;;
    s)
      SUFFIX=$OPTARG
      echo "With Suffix: $SUFFIX" >&2
      ;;
    d)
      DELAY=$OPTARG
      echo "With Delay: $DELAY seconds" >&2
      ;;
    l)
      LOOP=$OPTARG
      echo "With Loop: $LOOP" >&2
      ;;
    t)
      TOR=true
      echo "Using Tor" >&2
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      usage
      ;;
  esac
done

globalParams() {
  # Global Constants
  
  COLOR_ERROR=$(tput setaf 1)
  COLOR_SUCCESS=$(tput setaf 2)
  COLOR_NORMAL=$(tput setaf 4)
  COLOR_INFO=$(tput setaf 6)
  COLOR_END=$(tput sgr0)
}

generateParams() {
  #randomNo=$(shuf -i 0-54321 -n 1)
  #randomWord=$(shuf -n 1 /usr/share/dict/words)
  
  local phoneStart=$(shuf -i 91-99 -n 1)
  local phoneEnd=$(shuf -i 11111111-99999999 -n 1)
  phone="$phoneStart$phoneEnd"
  
  local timeDate=$(TZ='Asia/Kolkata' date +%I%P%d%b)
  local newSuffix="T${SUFFIX}${timeDate}${RANDOM}"
  email="$USERNAME@$DOMAIN"
  email="$USERNAME+$newSuffix@$DOMAIN"
  
  getRandomFromArray "${NAMES[@]}"
  firstName=$result
  
  getRandomFromArray "${NAMES[@]}"
  lastName=$result
  
  country=$COUNTRY
  state=$STATE
  postalCode=$POSTALCODE
  
  tempDateString=$(TZ='Asia/Kolkata' date -d '2 hour ago' +%FT%T.086Z)
  
  cmd=$([ $TOR ] && echo "torify curl" || echo "curl")
}

getRandomFromArray() {
  local array=("$@")
  local index=0
  while [ "x${array[$index]}" != "x" ]
  do
    index=$(( $index + 1 ))
  done;
  # size=${#array[@]}
  index=$(( $index - 1 ))
  result=${array[$(shuf -i 1-$index -n 1)]}
}

run() {
  banner="Email ($email), Name {$firstName $lastName}"
  
  $cmd "https://wtfismyip.com/json" 2> /dev/null
}

main() {
  generateParams
  
  if [ $TOR ]; then
    ipLocation=$(torify curl https://wtfismyip.com/json 2> /dev/null | grep -e Location | cut -d ":" -f 2)
  fi
  
  run # command function to run
  
  if [ $TOR ]; then
    echo ""
    echo "Changing Tor Node"
    changeTorNode
  fi
  
  if [ $? -eq 0 ]; then
    printSuccess "[$count$ipLocation] $banner"
  else
    printError "[$count] Error - $banner"
  fi
}

trap handleExit EXIT
trap handleQuit QUIT

globalParams
count=0
while true; do
  count=$(( $count + 1 ))
  main
  sleep $DELAY
done

# To Do
# [x] Delay and Infinite loop
# [] Specify no. of loops
# [] Colorify
# [x] User Input(email, campaignId)
# [] File Output
# [x] Torify
# [] Notifications(Pushbullet)
# Handle error gracefully
# Chef Script
# Parallel processing


