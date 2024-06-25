#!/usr/bin/env bash

# Set to the gist id to update
gist_id='4b85f310233a6b9d385643fa3a889d92'

# Uncomment and set to your GitHub API OAUTH token
github_oauth_token='###################'

# Or uncomment this and set to your GitHub username:password
#github_user="user:xxxx"

github_api='https://api.github.com'

gist_description='Gist update with API call from a Bash script'
filename='latest-commit.json'

get_file_content() {
  # Populate variables from the git log of latest commit
  # reading null delimited strings for safety on special characters
  {
    read -r -d '' subject
    read -r -d '' author
    read -r -d '' date
  } < <(
    # null delimited subject, author, date
    git log -1 --format=$'%s%x00%aN%x00%cD%x00'
  )

  # Compose the latest commit JSON, and populate it with the latest commit
  # variables, using jq to ensure proper encoding and formatting of the JSON
  read -r -d '' jquery <<'EOF'
.subject = $subject |
.author = $author |
.date = $date
EOF
  jq \
    --null-input \
    --arg subject "$subject" \
    --arg author "$author" \
    --arg date "$date" \
    "$jquery"
}

# compose the GitHub API JSON data payload
# to update the latest-commit.json file in the $gist_id
# uses jq to properly fill-in and escape the content string
# and compact the output before transmission
get_gist_update_json() {
  read -r -d '' jquery <<'EOF'
.description = $description |
.files[$filename] |= (
  .filename = $filename |
  .content = $content
)
EOF
  jq \
    --null-input \
    --compact-output \
    --arg description "$gist_description" \
    --arg filename "$filename" \
    --arg content "$(get_file_content)" \
    "$jquery"
}

# prepare the curl call with options for the GitHub API request
github_api_request=(
  curl # The command to send the request
  --fail # Return shell error if request unsuccessful
  --request PATCH # The request type
  --header "Content-Type: application/json" # The MIME type of the request
  --data "$(get_gist_update_json)" # The payload content of the request
)

if [ -n "${github_oauth_token:-}" ]; then
  github_api_request+=(
    # Authenticate the GitHub API with a OAUTH token
    --header "Authorization: token $github_oauth_token"
  )
elif [ -n "${github_user:-}" ]; then
  github_api_request+=(
    # Authenticate the GitHub API with an HTTP auth user:pass
    --user "$github_user"
  )
else
  echo 'GitHub API require either an OAUTH token or a user:pass' >&2
  exit 1
fi

github_api_request+=(
  -- # End of curl options
  "$github_api/gists/$gist_id" # The GitHub API url to address the request
)

# perform the GitHub API request call
if ! "${github_api_request[@]}"; then
  echo "Failed execution of:" >&2
  env printf '%q ' "${github_api_request[@]}" >&2
  echo >&2
fi