#!/bin/bash

set -e

CYN=$'\e[0;36m'
YLW=$'\e[0;33m'
BLE=$'\e[0;35m'
GRN=$'\e[0;32m'
RED=$'\e[0;31m'
NC=$'\e[0m'
NC=$'\e[0m'

#Main Folder
folderInIn="09-08-22_8"
folderInMain="/Volumes/vyom_Drive/Video"

#user_1
fileMp4In1="New Technology Stair Light #technology #light.mp4"
tagsUser1="#technology","#light"
# userTkn1="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI2MmQ2YTMxZjFkYWViYzAwMjllZjExOTgiLCJyb2xlIjoidXNlciIsImlhdCI6MTY1OTY5NjQyOX0._rMTMA0v3u4pndIT6qB1Whu3Mt-F3jTaTXyfsxUq7cM"
userTkn1="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI2MTljZTA0YzU4NDI5YTAwMWUzNGMxODciLCJyb2xlIjoidXNlciIsImlhdCI6MTY1OTY3MzM5NH0.PFbWonVsLWG_A19qQ4n52LlSdHUCa9uAlFRXe44DiP8"

#user_2
fileMp4In2="The idea of overcoming fear vs amazing creation #creation #overcoming.mp4"
tagsUser2="#creation","#overcoming"
# userTkn2="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI2MmQ2YTMxZjFkYWViYzAwMjllZjExOTgiLCJyb2xlIjoidXNlciIsImlhdCI6MTY1OTY5NjQyOX0._rMTMA0v3u4pndIT6qB1Whu3Mt-F3jTaTXyfsxUq7cM"
userTkn2="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI2MjE3NzkwOTI4YzZkODAwMWViZmExZDAiLCJyb2xlIjoidXNlciIsImlhdCI6MTY1ODI5ODY1Mn0._CxIqY6sVmE-agK6Yz-Pisr-Iotms95Ilos1U3xj_r4"

#user_3
fileMp4In3="Amazing idea to shoot photo with camera #amazing #cemera #shoot.mp4"
tagsUser3="#amazing","#cemera","#shoot"
# userTkn3="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI2MWYyMzRiYWRmZGM1OTAwMmExYWFkYzYiLCJyb2xlIjoidXNlciIsImlhdCI6MTY1OTY5NzQ5Nn0.uodV0FEvC_QhKAN6B0fT8q92WSWS0JUWUjlmQ7WQhpk"
userTkn3="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI2MWU2NWYyMDJlYmRiMTAwMWVhZjIwNDIiLCJyb2xlIjoidXNlciIsImlhdCI6MTY1ODQxNjU3Nn0.NWKTpvri1LqZY-CJTB_PW6mfmnuc71EuHMWIr5iNlCI"

#user_4
fileMp4In4="New amazing technology #technology.mp4"
tagsUser4="#technology"
userTkn4="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI2MjUxM2IyYmNiMzk0NDAwMWU5NzE0MmQiLCJyb2xlIjoidXNlciIsImlhdCI6MTY1ODkwMTUwOX0.cGqroKQlTFgmXKXsgfdkHfCPvK8ULcpr99VkJrVF2p0"
# userTkn4="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI2Mjk5ZmIwM2ZmYWNlYzAwMWVjMWEyYzAiLCJyb2xlIjoidXNlciIsImlhdCI6MTY1OTc1OTQ0MX0.xSHG4tIeLEOMxPOSr2m7OT41yvqvl4mwjh3uCoGBWpg"

#user_5
fileMp4In5="crazy Salon barber #salon.mp4"
tagsUser5="#salon"
userTkn5="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI2MmM4MWY5MGQwNmY4ZjAwMjlkNTE3YWIiLCJyb2xlIjoidXNlciIsImlhdCI6MTY1OTU5MTYxMH0.mpLDbcYUQ0UFxMgIHbg-lxYoVgVQnLKBLFZdvsBLht4"
# userTkn5="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI2MjU4MmFmZWNhNzAwODAwMWViYWJjNzEiLCJyb2xlIjoidXNlciIsImlhdCI6MTY1OTUwNzAwNH0.2_xhp-hwaLRKxjEOEYPGYNf3LaSfWcaRYR1A-LraOqg"


#######################################

folderIn="$folderInMain/$folderInIn"
hostUrl="https://xyz.com/rest/api/video/store"

function fun_1() {
    trimFile1=$( echo -n "$fileMp4In1" | cut -d '.' -f1 )
    userVidIn1="$folderIn/$fileMp4In1"
    userJpgOut1="$folderIn/$trimFile1.jpg"
    userMp3Out1="$folderIn/$trimFile1.mp3"

    ffmpeg -y -i "$userVidIn1" -vf 'scale=720:trunc(ow/a/2)*2' -frames:v 1 -qscale:v 0 "$userJpgOut1"
    ffmpeg -y -i "$userVidIn1" "$userMp3Out1"
    Tkn1="Authorization: Berear $userTkn1"
    # TEMPLfile=$(mktemp)
    HTTPS1=$(curl --location --request POST "$hostUrl" \
        --header "$Tkn1" \
        --form file=@"$userJpgOut1" \
        --form file=@"$userMp3Out1" \
        --form file=@"$userVidIn1" \
        --form title="$trimFile1" \
        --form tags="$tagsUser1" \
        --form isDraft="false" \
        --form name="$trimFile1" \
        --form description="$trimFile1" \
        --form allowToWatch="Everyone" \
        --form videoToComment="Everyone" \
        --form canAnyoneDuet="Everyone" \
        --write-out "%{http_code}" \
        --write-out "%{http_code}\n" --output /dev/null
    );
    if [[ "$HTTPS1" == 200 ]] ; then
        echo "$HTTPS1"
        echo "${GRN}ROLEIT-API-CALL-DONE====${NC}"
    else
        echo "${RED}ROLEIT-API-CALL-ERROR====${NC}"
        exit 0
    fi;
    echo "${CYN}User_111111 done${YLW}>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>${NC}"
}

function fun_2() {
    trimFile2=$( echo -n "$fileMp4In2" | cut -d '.' -f1 )
    userVidIn2="$folderIn/$fileMp4In2"
    userJpgOut2="$folderIn/$trimFile2.jpg"
    userMp3Out2="$folderIn/$trimFile2.mp3"

    ffmpeg -y -i "$userVidIn2" -vf 'scale=720:trunc(ow/a/2)*2' -frames:v 1 -qscale:v 0 "$userJpgOut2"
    ffmpeg -y -i "$userVidIn2" "$userMp3Out2"
    Tkn2="Authorization: Berear $userTkn2"
    HTTPS2=$(curl --location --request POST "$hostUrl" \
        --header "$Tkn2" \
        --form file=@"$userJpgOut2" \
        --form file=@"$userMp3Out2" \
        --form file=@"$userVidIn2" \
        --form title="$trimFile2" \
        --form tags="$tagsUser2" \
        --form isDraft="false" \
        --form name="$trimFile2" \
        --form description="$trimFile2" \
        --form allowToWatch="Everyone" \
        --form videoToComment="Everyone" \
        --form canAnyoneDuet="Everyone" \
        --write-out "%{http_code}\n" --output /dev/null
    );
    if [[ "$HTTPS2" == 200 ]] ; then
        echo "$HTTPS2"
        echo "${GRN}ROLEIT-API-CALL-DONE====${NC}"
    else
        echo "${RED}ROLEIT-API-CALL-ERROR====${NC}"
        exit 0
    fi;
    echo "${CYN}User_222222 done${YLW}>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>${NC}"
}

function fun_3() {
    trimFile3=$( echo -n "$fileMp4In3" | cut -d '.' -f1 )
    userVidIn3="$folderIn/$fileMp4In3"
    userJpgOut3="$folderIn/$trimFile3.jpg"
    userMp3Out3="$folderIn/$trimFile3.mp3"

    ffmpeg -y -i "$userVidIn3" -vf 'scale=720:trunc(ow/a/2)*2' -frames:v 1 -qscale:v 0 "$userJpgOut3"
    ffmpeg -y -i "$userVidIn3" "$userMp3Out3"
    Tkn3="Authorization: Berear $userTkn3"
    TEMPLfile=$(mktemp)
    HTTPS3=$(curl --location --request POST "$hostUrl" \
        --header "$Tkn3" \
        --form file=@"$userJpgOut3" \
        --form file=@"$userMp3Out3" \
        --form file=@"$userVidIn3" \
        --form title="$trimFile3" \
        --form tags="$tagsUser3" \
        --form isDraft="false" \
        --form name="$trimFile3" \
        --form description="$trimFile3" \
        --form allowToWatch="Everyone" \
        --form videoToComment="Everyone" \
        --form canAnyoneDuet="Everyone" \
        --write-out "%{http_code}\n" --output /dev/null
    );
    if [[ "$HTTPS3" == 200 ]] ; then
        echo "$HTTPS3"
        echo "${GRN}ROLEIT-API-CALL-DONE====${NC}"
    else
        echo "${RED}ROLEIT-API-CALL-ERROR====${NC}"
        exit 0
    fi;
    echo "${CYN}User_3333333 done ${YLW}>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>${NC}"
}

function fun_4() {
    trimFile4=$( echo -n "$fileMp4In4" | cut -d '.' -f1 )
    userVidIn4="$folderIn/$fileMp4In4"
    userJpgOut4="$folderIn/$trimFile4.jpg"
    userMp3Out4="$folderIn/$trimFile4.mp3"

    ffmpeg -y -i "$userVidIn4" -vf 'scale=720:trunc(ow/a/2)*2' -frames:v 1 -qscale:v 0 "$userJpgOut4"
    ffmpeg -y -i "$userVidIn4" "$userMp3Out4"
    Tkn4="Authorization: Berear $userTkn4"
    HTTPS4=$(curl --location --request POST "$hostUrl" \
        --header "$Tkn4" \
        --form file=@"$userJpgOut4" \
        --form file=@"$userMp3Out4" \
        --form file=@"$userVidIn4" \
        --form title="$trimFile4" \
        --form tags="$tagsUser4" \
        --form isDraft="false" \
        --form name="$trimFile4" \
        --form description="$trimFile4" \
        --form allowToWatch="Everyone" \
        --form videoToComment="Everyone" \
        --form canAnyoneDuet="Everyone" \
        --write-out "%{http_code}\n" --output /dev/null
    )
    if [[ "$HTTPS4" == 200 ]] ; then
        echo "$HTTPS4"
        echo "${GRN}ROLEIT-API-CALL-DONE====${NC}"
    else
        echo "${RED}ROLEIT-API-CALL-ERROR====${NC}"
        exit 0
    fi;
    echo "${CYN}User_4444444 done${YLW}>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>${NC}"
}

function fun_5() {
    trimFile5=$( echo -n "$fileMp4In5" | cut -d '.' -f1 )
    userVidIn5="$folderIn/$fileMp4In5"
    userJpgOut5="$folderIn/$trimFile5.jpg"
    userMp3Out5="$folderIn/$trimFile5.mp3"

    ffmpeg -y -i "$userVidIn5" -vf 'scale=720:trunc(ow/a/2)*2' -frames:v 1 -qscale:v 0 "$userJpgOut5"
    ffmpeg -y -i "$userVidIn5" "$userMp3Out5"
    Tkn5="Authorization: Berear $userTkn5"
    HTTPS5=$(curl --location --request POST "$hostUrl" \
        --header "$Tkn5" \
        --form file=@"$userJpgOut5" \
        --form file=@"$userMp3Out5" \
        --form file=@"$userVidIn5" \
        --form title="$trimFile5" \
        --form tags="$tagsUser5" \
        --form isDraft="false" \
        --form name="$trimFile5" \
        --form description="$trimFile5" \
        --form allowToWatch="Everyone" \
        --form videoToComment="Everyone" \
        --form canAnyoneDuet="Everyone" \
        --write-out "%{http_code}\n" --output /dev/null
    );
    if [[ "$HTTPS5" == 200 ]] ; then
        echo "$HTTPS5"
        echo "${GRN}ROLEIT-API-CALL-DONE====${NC}"
    else
        echo "${RED}ROLEIT-API-CALL-ERROR====${NC}"
        exit 0
    fi;
    echo "${CYN}User_5555555 done${YLW}>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>${NC}"
}

fun_1
fun_2
fun_3
fun_4
fun_5

