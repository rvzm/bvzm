# bvzm.tcl \- version 0.5


## Basic Information
This script is ran and tested with [eggdrop](http://eggheads.org) 1.8.4
Currently requires no extra packages to be installed.

## 'text' Directory
This folder contains a modified motd for bvzm to use.

## Install
to install bvzm.tcl, clone it to your scripts/ folder, then copy bvzm-settings.tcl.dist to bvzm-settings.tcl and edit to your liking.

## Public channel commands
These commands are used in a channel that the bot is on.
The command character is defined by settings->gen->pubtrig

Who     | Command          | Function
--------|------------------|----------
anyone  | regme            | Registers a user into the userfile, if they aren't already in it.
anyone  | greet            | using 'greet set' will set your greet - does not require user to be in userfile.
anyone  | bvzm             | this command by itself shows an error message
anyone  | fchk             | check your flags with the bot
anyone  | whoami           | see your nick, userhost, and handle as seen by the bot
anyone  | version          | full version reply
anyone  | dccts            | show info about dccts
anyone  | pack             | tells the bot to prepare the channel for a "chan-wide toke-out"

### friend commands
Who     | Command    | Function
--------|------------|----------
friends | rollcall   | {requires bvzm chanflag}  lists all nicks in the channel for a Roll Call
friends | uptime     | shows bots current uptime

### Controller command 'e'
Command | Function
-----------|----------
e          | channel op commands - basic (de)op/voice and kick
-> op      | give op status to yourself or someone else
-> deop    | remove op status from yourself or someone else
-> voice   | give voice status to yourself or someone else
-> devoice | remove voice status from yourself or someone else
-> kick    | kick a user from the channel, reason optional
-> remove  | politely inform a user to leave, after a setable time bvzm will kick them if they have not already left
-> mode    | push a mode change to the channel
-> invite  | invite a user to the channel
-> topic   | change the channel topic
-> mvoice  | initiate a mass voice
-> help    | display help information about each command

### Master commands
Command | Function
--------|----------
status  | displays current system status, such as load averages, and other info found in the `uptime` command

## bvzm command
Use the "bvzm" command, and its various subcommands to see information about the script, and
help options for the commands

Subcommand   | Function
-------------|----------
help         | shows basic help
-> {command} | show command help for a specified command
info         | shows information about bvzm.tcl to the channel
commands     | show a list of commands


## Controller
The controller (set via settings->gen->controller)

Subcommand | Function
-----------|----------
restart    | restart the bot
die        | kill the bot :(
nsauth     | have the bot authenticate itself to NickServ - change the settings->gen->npass value to what you wish the bot to use
register   | have the bot register itself with NickServ - change settings->gen->npass and settings->gen->email to the desired values
group      | have the bot group itself to a specified nick with NickServ - change settings->gen->group->nick and settings->gen->group->pass
rehash     | rehash the bot

## DCC Commands
package  | Command   | Function
---------|-----------|---------
dccts    | dccts     | DCC-To-Server - Send messages to predefined channels from dcc

## Automated channel management/features
Flag    | Name         | Function
--------|--------------|----------
avoice  | Autovoice    | Automatically voice users on join
greet   | AutoGreet    | Sends a user-defined message to the channel on join

## Settings
All settings for bvzm.tcl are located in bvzm-settings.tcl

### general (settings->gen)
Setting    | Function
-----------|----------
pubtrig    | public trigger command character
controller | master controll command character
npass      | NickServ password (used for nsauth and register)
email      | NickServ registration email (used for register)
homechan   | where the script will report controller messages

### dccts (settings->dccts)
Setting    | Function
-----------|----------
mode       | enable (1) or disable (0) dccts (DCC-to-Server)
reqflag    | flag required to use dccts - can be single flag or multiflag
chan1      | dccts channel 1
chan2      | dccts channel 2
chan3      | dccts channel 3
chan4      | dccts channel 4
chan5      | dccts channel 5

## Contact
I can be contacted at irc.gotham.chat in #bvzm, #eggdrop, and #gotham
