# bvzm.tcl \- version 0.3.4

## Basic Information
This script is ran and tested with [eggdrop](http://eggheads.org) 1.6.21, and requires
no extra packages to be installed.

Currently, bvzm.tcl features a few commands, as well as a few options for automated channel management.

## Commands
Place   | Command    | Function
--------|------------|----------
channel | pack       | tells the bot to prepare the channel for a "chan-wide toke-out"
channel | rollcall   | lists all nicks in the channel for a Roll Call
channel | uptime     | shows bots current uptime
channel | mvoice     | mass-voices the channel
dcc     | dccts      | DCC-To-Server - Send messages to predefined channels from dcc

## Automated channel management
Flag    | Name         | Function
--------|--------------|----------
avoice  | Autovoice    | Automatically voice users on join
greet   | AutoGreet    | Sends a user-defined message to the channel on join.
tcs    | TCS          | Control and maintain a topic structure for a channel.

## Settings
All settings for bvzm.tcl are located in bvzm-settings.tcl
