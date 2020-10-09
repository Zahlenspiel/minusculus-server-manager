#!/usr/bin/env bash

# minusculus server manager by Marc Jansen - Zahlenspiel

#check arguments
if [[ $# -lt 1 ]]; then
  echo "Usage: $0 [install|deinstall]"
  exit
fi

# functions
function install {
		if grep -q "minecraft" /etc/passwd; then
			echo "User 'minecraft' already exists."
			false
		else
			echo
			groupadd minus
			echo "User 'minecraft' does not exist."
			# do you wish to continue?
			sleep 1
			echo "Creating..."
			sleep 1
			# creates the user
			useradd -N -g minus -m -d /home/minecraft --badname minecraft
			echo "User 'minecraft' created successfully!"
			true
		fi
}

function deinstall {
 false
}


# check command
case "${1}" in
  "install")
  install
    ;;

  "deinstall")
	deinstall
    ;;

  *)
  echo "Command not found. Usage: $0 [install|deinstall]"
  exit
    ;;
esac
