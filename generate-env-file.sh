#!/bin/sh
# Declare all environment variables that have to be copied
declare env_array=(
TYPEORM_HOST
TYPEORM_DATABASE
TYPEORM_USERNAME
TYPEORM_PASSWORD
TYPEORM_DRIVER
TYPEORM_TYPE
APP_TOKEN_SECRET
)

# Set file output name
FILE_OUTPUT_NAME=.env

# Prevent overwriting an existing .env file
if [ -f ".env" ]; then
    echo "A .env file is already present in the current directory."
else
  # Print all environment variables to .env file
  for i in "${env_array[@]}";
  do
     printf '%s\n' "${i}=${!i}" >> $FILE_OUTPUT_NAME;
  done
fi
