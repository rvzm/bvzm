# bvzm.tcl \- version 0.3.5

## Basic Information
This script is ran and tested with [eggdrop](http://eggheads.org) 1.6.21, and requires
no extra packages to be installed.

## NOTICE
soon this script will be switched to being tested on eggdrop 1.8

Currently, bvzm.tcl features a few commands, as well as a few options for automated channel management.

## Channel commands
Who     | Command    | Function
--------|------------|----------
anyone  | pack       | tells the bot to prepare the channel for a "chan-wide toke-out"
anyone  | bong       | pass a bong to yourself or someone else
anyone  | pipe       | pass a pipe to yourself or someone else
anyone  | joint      | pass a joint to yourself or someone else
anyone  | dab        | prepare a dab, then pass it to yourself or someone else
anyone  | weed       | show info about the weed package
anyone  | regme      | Registers you into the userfile, if you arent already in it.
anyone  | greet      | using 'greet set' will set your greet - this does not go by userfile handles
anyone  | bvzm       | this command by itself shows an error message
 -->    | - help    | shows help information about bvzm.tcl - currently only the bvzm command
 -->    | - info    | shows information about bvzm.tcl to the channel
friends | rollcall   | lists all nicks in the channel for a Roll Call
friends | uptime     | shows bots current uptime
chanop  | mvoice     | mass-voices the channel

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
### homechan
Homechan is where the script will report controller messages. it is suggested this room be secret and/or members only.
