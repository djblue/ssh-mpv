#!/bin/bash
# quickly list/play remote videos over ssh

# quit script on ctrl-c
trap 'echo interrupted; exit' INT

# script variables
vars=false  # remove lines after vars are set
user=''     # username to use when logging in
server=''   # address of remote server
dir=''      # directory to search on the server
edit=''     # editor to use for vipe

# check that the vars have been set
if [ -n "$vars" ]; then
  echo "Please edit vars in $0"
  exit 1
fi

# display usage info
usage () {
  echo "USAGE: $(basename $0) [opt] <search...>"
  echo "  -l list remote videos to stdout"
  echo "  -v view remote listing in $edit"
  echo "  -p play listing from stdin"
}

# list remote videos from ssh server
# $1 - search to use during grep
list () {
  ssh $user@$server "find $dir -type f \
    | sed 's,$dir,,' \
    | grep -E '(avi|mp4|mkv)$' \
    | grep -i '$1' \
    | sort"
}

# call mpv to play video over ssh
# $1 - path to video from root $dir
play () {
  mpv "sftp://$user@$server$dir$1" || exit
}

if [ "$1" == '' ]; then
  usage

elif [ "$1" == '-v' ]; then
  echo "$(list ${*:2})" | EDITOR=$edit vipe

elif [ "$1" == '-l' ]; then
  list "${*:2}"

elif [ "$1" == '-p' ]; then
  while read line; do
    play "$line"
  done < /dev/stdin

else
  IFS=$'\n' # set newline as splitter for select loop
  PS3='>> ' # set '>> ' as select menu prompt

  select video in $(list "$@"); do
    play "$video"
    exit
  done

  # no match found on remote ssh server
  echo 'no match'

fi
