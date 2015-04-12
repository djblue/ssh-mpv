# ssh-mpv

List/play videos over ssh using mpv.

## deps

Dependencies needed for the script to work properly.

- [vipe](http://joeyh.name/code/moreutils/): pipe stdin to vim to stdout
  (from moreutils)
- [mpv](http://mpv.io/): mplayer fork with enhancements

## vars

Edit the following variables in the script before use.

- user: ssh server user
- server: ssh server name 
- dir: directory to search on the ssh server
- edit: editor to use for vipe

## usage

    ssh-mpv [opt] <search...>

### opt

- l: list remote videos to stdout
- v: view remote listing in $edit
- p: play listing from stdin
