#!/usr/bin/env bash

# place file in /usr/bin
#Usage: minusculus cmd server


#check arguments
if [[ $# -lt 2 ]]; then
  echo "Usage: $0 command server"
  exit
fi

# declare functions (COMMANDS)
function create {
  mkdir ${TARGET}
}

function update {
  if exists && ! running ; then
    echo "Server exists and is offline."
    rm ${JAR}
    wget -O ${JAR} ${LATEST}
    chmod ug+rwx ${JAR}
    echo "Update successful!"
    return 0
  else
    echo "Server does not exist or is running. Try minusculus running ${SERVER} or minusculus exists ${SERVER}"
    exit
  fi
}

function start {
  if exists; then
    if running; then
      echo "Server is already running!"
      exit
    else
      bash "${TARGET}/start.sh"
      echo "Server started."
      return
    fi
  else
    exit
  fi
}

function stop {
  # TODO check if its actually WATERFALL (needs end instead of stop)
  if exists && running; then
    screen -S $SERVER -p 0 -X stuff "stop $(printf '\r')"
  else
    echo "Server does not exist or is running. Try minusculus running ${SERVER} or minusculus exists ${SERVER}"
    exit
  fi
}

function exists {
  if [[ -f "${JAR}" ]]; then
    # paper.jar exists! Server exists!
    echo "Server found."
    return
  else
    # paper.jar does not exist. No Server.
    echo "paper.jar not found. Does the Server ${SERVER} exist?"
    false
  fi
}

function running {
  if screen -ls | grep -q "${SERVER}"; then
    echo "Screen is running."
    return
  else
    echo "Screen is not running."
    false
  fi
}

# create vars
. /home/minecraft/minusculus.config
DIR="/home/minecraft/"
CMD=$1
SERVER=$2
TARGET="${DIR}${2}"
JAR="${TARGET}/paper.jar"
CONFIG="/home/minecraft/minusculus.config"

# check command
case "${1}" in
  "create")
  create
    ;;

  "update")
  update
    ;;

  "start")
  start
    ;;

  "stop")
  stop
    ;;

  "exists")
  exists
    ;;

  "running")
  running
    ;;

  *)
  echo "Command not found."
  exit
    ;;
esac