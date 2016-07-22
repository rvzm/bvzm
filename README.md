# bvzm.tcl \- version 0.4.1

## Basic Information
This script is ran and tested with [eggdrop](http://eggheads.org) 1.6.21, and requires
no extra packages to be installed.

Currently, bvzm.tcl features a few commands, as well as a few options for automated channel management.

## Public channel commands
These commands are used in a channel that the bot is on.

Who     | Command          | Function
--------|------------------|----------
anyone  | regme            | Registers a user into the userfile, if they aren't already in it.
anyone  | greet            | using 'greet set' will set your greet - requires user to be in userfile.
anyone  | slap             | slap someone with a random object from the slapdata file, specified via settings->file->slapdata
anyone  | bitchslap        | slap someone with a Banzai item, specified via the file set in settings->file->slapbanzai
anyone  | bvzm             | this command by itself shows an error message
anyone  | fchk             | check your flags with the bot
### Weed package commands
Who     | Command    | Function
--------|------------|----------
anyone  | pack       | tells the bot to prepare the channel for a "chan-wide toke-out"
anyone  | bong       | pass a bong to yourself or someone else
anyone  | pipe       | pass a pipe to yourself or someone else
anyone  | joint      | pass a joint to yourself or someone else
anyone  | dab        | prepare a dab, then pass it to yourself or someone else
anyone  | weed       | show info about the weed package
### friend commands
Who     | Command    | Function
--------|------------|
friends | rollcall   | {requires bvzm chanflag}  lists all nicks in the channel for a Roll Call
friends | uptime     | shows bots current uptime
friends | addslap    | add an object to slap people with via the slap command
### chanop commands
Command | Function
mvoice  | {requires bvzm chanflag} mass-voices the channel
topic   | {requires tcs chanflag} manipulate topic sections via the t<1|2|3> subcommands

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

Subommand | Function
----------|----------
restart   | restart the bot
die       | kill the bot :(
nsauth    | have the bot authenticate itself to NickServ - change the settings->gen->npass value to what you wish the bot to use
registe   | have the bot register itself with NickServ - change settings->gen->npass and settings->gen->email to the desired values
rehash    | rehash the bot

## DCC Commands
package  | Command   | Function
---------|-----------|---------
dccts    | dccts     | DCC-To-Server - Send messages to predefined channels from dcc

## Automated channel management/features
Flag    | Name         | Function
--------|--------------|----------
avoice  | Autovoice    | Automatically voice users on join
greet   | AutoGreet    | Sends a user-defined message to the channel on join.
tcs     | TCS          | Control and maintain a topic structure for a channel.

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
