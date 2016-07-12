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
