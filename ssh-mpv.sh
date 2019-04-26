#!/bin/bash
# quickly list/play remote videos over ssh

# quit script on ctrl-c
trap 'echo interrupted; exit' INT

# script variables
vars=false  # remove this line after vars are set
user=''     # username to use when logging in via ssh
server=''   # address of remote server
dir=''      # directory to search on the server
edit=''     # editor to use for vipe
jumphost_required=false # set to true if you need to use a jumphost. e.g. if your remote server is not directly reachable
jumphost='' # enter user@server.fqdn you want to use as jumphost (if needed)

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
  if [ -n "$jumphost_required" ]; then
    ssh $user@$server -J $jumphost "find $dir -type f \
      | sed 's,$dir,,' \
      | grep -E '(avi|mp4|mkv)$' \
      | grep -i '$1' \
      | sort"
  else
    ssh $user@$server "find $dir -type f \
      | sed 's,$dir,,' \
      | grep -E '(avi|mp4|mkv)$' \
      | grep -i '$1' \
      | sort"
  fi
}

# call mpv to play video over ssh
# $1 - path to video from root $dir
play () {
  if [ -n "$jumphost_required" ]; then
    mpv "sftp://$user@localhost:9999$dir$1"  >/dev/null || exit
  else
    mpv "sftp://$user@$server$dir$1" >/dev/null || exit
  fi
}

if [ "$1" == '' ]; then
  usage

elif [ "$1" == '-v' ]; then
  echo "$(list ${*:2})" | EDITOR=$edit vipe

elif [ "$1" == '-l' ]; then
  list "${*:2}"

elif [ "$1" == '-p' ]; then
  if [ -n "$jumphost_required" ]; then
    ssh -L 9999:$server:22 $jumphost >/dev/null 2>/dev/null sleep 3600 &
    pid=$!
  fi
  sleep 1

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
