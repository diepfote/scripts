#!/usr/bin/env bash

echo +--------------------------------------------+
echo "|USAGE: ./pastebin.sh <content> <dev_key>"
echo +--------------------------------------------+

DEV_KEY="$1"
CONTENT="$2"
PASTE_PRIVATE=1  # public = 0, unlisted = 1, private = 2

    #N = Never
    #10M = 10 Minutes
    #1H = 1 Hour
    #1D = 1 Day
    #1W = 1 Week
    #2W = 2 Weeks
    #1M = 1 Month
    #6M = 6 Months
    #1Y = 1 Year 
EXPIRATION_DATE=24H


echo $@
echo $CONTENT

# for more options see the pastebin.com API ( https://pastebin.com/api )

# combine to query
QUERY="api_dey_key='$DEV_KEY'&api_paste_code=$CONTENT&api_option=paste&api_paste_expire_date=$EXPIRATION_DATE&api_paste_private=$PASTE_PRIVATE&api_user_key='0b7568099058a5638272c0fd8970b98a'"

echo "query: $QUERY"

# post data to pastebin.com API
curl -d "$QUERY" https://pastebin.com/api/api_post.php

# the command will return the pastebin.com link to the newly created bin if successful
# if unsuccessful, it will return the errorcode provided by pastebin.com

# Note: If you just want to upload code / text to copy&paste between two machines quick and dirty, I suggest you use termbin.com
# Just type `echo your text goes here or maybe some file or whatever you want | nc https://termbin.com 9999`

