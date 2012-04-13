#!/usr/bin/env bash
ENDPOINT=http://puush.me

if [ $# -eq 1 ]; then
  curl -s -F "z=lol" -F "e=$PUUSH_EMAIL" -F "k=$PUUSH_APIKEY" -F f=@$1 $ENDPOINT/api/up/ | cut -d',' -f 2
else
  echo "Usage: puu.sh <file>"
fi
