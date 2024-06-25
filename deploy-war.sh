#!/bin/bash
echo "start\n"
set -e

CYN=$'\e[0;36m'
YLW=$'\e[0;33m'
BLE=$'\e[0;35m'
GRN=$'\e[0;32m'
RED=$'\e[0;31m'
NC=$'\e[0m'

DEPLOYBRANCH="master"
EDISERDIR="/home/ubuntu/ediservice"
WARDESTDIR="/home/ubuntu/ediservice/target"
TAG_DATE=ediService-$(date '+%Y%m%d.%H%M%S')

FNLWARFILE=${WARDESTDIR}/${TAG_DATE}.war
SERWARDIR="/opt/tomcat/webapps"
cd ${EDISERDIR} || { echo "[-] Failed to cd ${EDISERDIR}, EXITING!"; exit 1; }
GBRANCH="$(git rev-parse --abbrev-ref HEAD)" # GBRANCH=$(git branch | sed -n -e 's/^\* \(.*\)/\1/p')

#git branch check and code push
if [ "${GBRANCH}" != "${DEPLOYBRANCH}" ] ; then
        echo "[-] This branch is not in deploy + Aborting script!"
    else
        echo '[+] Found same branch so started';
        git pull origin ${GBRANCH}
        echo "[+] ${CYN}git push done for ${GBRANCH} ${NC}"

    #Generate war file
    echo "[+] Maven war generate processing..."
    cd ${EDISERDIR} || { echo "[-] Failed to cd ${EDISERDIR}, EXITING!"; exit 1; }
    mvn clean install || { echo "[-] Failed error for maven install command, EXITING!"; exit 1; }
    echo "[+] Maven war generated successful..."
    wait

    #check rootfile and process
    cd ${EDISERDIR} || { echo "[-] Failed to cd ${EDISERDIR}, EXITING!"; exit 1; }
    
    if [[ -f "${WARDESTDIR}/ediService.war" ]]; then
        cp ${WARDESTDIR}/ediService.war ${FNLWARFILE}
        echo "[+] file are renamed"
        echo "found old ROOT directory removing it."

        cd ${SERWARDIR} || { echo "Failed to cd ${SERWARDIR}, EXITING!" ; exit 1; }
        sudo rm -rf ./ROOT.war > /dev/null
        sudo cp ${FNLWARFILE} ${SERWARDIR}/ROOT.war
        sleep 5
        if [[ -d "${WARDESTDIR}/ROOT" ]]; then
                mkdir -p ROOT > /dev/null
                touch ROOT.war > /dev/null
            else
                echo "[+] Already Updating ROOT.war"
        fi
        cd - || { echo "Failed to cd into previous directory, EXITING!" ; exit 1; }
    fi
    echo  "[+] Updating time for ROOT.war"
fi

echo "${GRN}================================="
echo "${CYN}War ${YLW}are deployed ${GRN}Completed ${BLE}.........."
echo "${GRN}================================="

