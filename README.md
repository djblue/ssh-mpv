 ssh-mpv
===========

List and play videos over ssh using [mpv](https://mpv.io/).

 Dependencies
----------------

Dependencies needed for the script to work properly.

- [vipe](http://joeyh.name/code/moreutils/): pipe stdin to vim to stdout
  (from moreutils)
- [mpv](http://mpv.io/): mplayer fork with enhancements
- [SSH](https://de.wikipedia.org/wiki/Secure_Shell): Secure Shell to get access on your remote video files

Install it on linux:
```bash
sudo apt update
sudo apt install openssh mpv moreutils
```

 Variables
-------------

Edit the following variables in the script before use.

- user: ssh server user
- server: ssh server name 
- dir: directory to search on the ssh server
- edit: editor to use for vipe

*And you have the option to use a [Jump Host](https://www.tecmint.com/access-linux-server-using-a-jump-host/) to access the server indeirectly if he is e.g. behind a NAT/Firewall)*

## Usage

```bash
    ssh-mpv [opt] <search...>
```

### Options
```bash
- l: list remote videos to stdout
- v: view remote listing in $edit
- p: play listing from stdin
```
