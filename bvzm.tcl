# ##################################################
# ### bvzm.tcl - bvzm tool file ####################
# ### Coded by rvzm             ####################
# ### ------------------------- ####################
# ### Edited: 6/21/2016         ####################
# ### Version: 0.1              ####################
# ##################################################

set pubtrig "@"
set controller "~"
set bvzm_dir "bvzm_db"
set npass ""

# some flags
setudef flag bvzm
setudef flag avoice

proc getTrigger {} {
  global pubtrig
  return $pubtrig
}
proc getPass {} {
	global npass
	return $npass
}
# Main Commands
bind pub - ${pubtrig}bvzm bvzm:main
bind pub - ${pubtrig}pack weed:pack
bind pub - ${pubtrig}boobies yus:boobies
# Friendly commands
bind pub f ${pubtrig}mvoice mass:voice
bind pub f ${pubtrig}chk sym:check
# Control Commands
bind pub m ${controller}bvzm hub:control
bind pub m ${pubtrig}rollcall nicks:rollcall

# Autos
bind join - * hub:autovoice

# DB stuff
if {![file exists $bvzm_dir]} {
	file mkdir $bvzm_dir
}
proc write_bdb { w_db w_info } {
	global bvzm_dir
	set fs_write [open $bvzm_dir/$w_db w]
	puts $fs_write "$w_info"
	close $fs_write
}
proc bdb { r_db } {
	global bvzm_dir
	set fs_open [open $bvzm_dir/$r_db r]
	gets $fs_open db_out
	close $fs_open
	return $db_out
}
proc create_bdb { bdb db_info } {
	global bvzm_dir
	if {[file exists $bvzm_dir/$bdb] == 0} {
		set crtdb [open $bvzm_dir/$bdb a+]
		puts $crtdb "$db_info"
		close $crtdb
	}
}

# Main Command Procs
proc yus:boobies {nick uhost hand chan text} {
	putserv "PRIVMSG $chan :B00BIEZ";
	putlog "BOOBIEZ"
}
proc weed:pack {nick uhost hand chan text} {
	putserv "PRIVMSG $chan \00303Pack your bowls! Chan-wide Toke-out in 1 Minute!\003"
	global wchan
	set wchan $chan
	utimer 60 weed:pack:go
}
proc weed:pack:go {} {
	global wchan
	putserv "PRIVMSG $wchan :\00303::\003045\00303:";
	putserv "PRIVMSG $wchan :\00303::\003044\00303:";
	putserv "PRIVMSG $wchan :\00303::\003043\00303:";
	putserv "PRIVMSG $wchan :\00303::\003042\00303:";
	putserv "PRIVMSG $wchan :\00303::\003041\00303:";
	putserv "PRIVMSG $wchan :\00303::\00311\002SYNCRONIZED!\002 \00304FIRE THEM BOWLS UP!!!"; return

}
proc bvzm:main {nick uhost hand chan text} {
  global botnick
    if {[lindex [split $text] 0] == ""} {
      puthelp "PRIVMSG $chan :\037ERROR\037: Incorrect Parameters. \037SYNTAX\037: [getTrigger]bvzm help"; return
    }
    if {[lindex [split $text] 0] == "help"} {
      puthelp "PRIVMSG $chan :\002Public Cmds\002: bvzm commands use [getTrigger]";
	  puthelp "PRIVMSG $chan :bvzm commands: info | quote";

	}
	if {[lindex [split $text] 0] == "info"} {
	  putserv "PRIVMSG $chan :bvzm.tcl - bvzm tool file ~ Coded by rvzm"; return
	}
}
proc mass:voice {nick uhost hand chan text} {
  if {![matchattr $hand o|m $chan] && ![channel get $chan bvzm]} {return}
    set botnick "bvzm";
    if {[string tolower $nick] != [string tolower $botnick]} {
      foreach whom [chanlist $chan] {
        if {![isvoice $whom $chan] && ![isbotnick $whom] && [onchan $whom $chan]} {
          pushmode $chan +v $whom
        }
      }
   flushmode $chan
  }
}
proc nicks:rollcall {nick uhost hand chan text} {
  if {![matchattr $hand o|m $chan] && ![channel get $chan bvzm]} {return}
   set rollcall [chanlist $chan]
   putserv "PRIVMSG $chan :Roll Call!"
   putserv "PRIVMSG $chan :$rollcall"
}
proc sym:check {nick uhost hand chan text} {
	putserv "PRIVMSG $chan :\[\u2714\] $text";
	return
}

# Controller command
proc hub:control {nick uhost hand chan text} {
	set v1 [lindex [split $text] 0]
	set v2 [lindex [split $text] 1]
	putlog "*** bvzm controller - $nick has issued a command: $text"
	#putserv "PRIVMSG ${controlchan} :*** bvzm controller - $nick has issued a command: $text"
	if {[lindex [split $text] 0] == ""} {
      puthelp "PRIVMSG $chan :\037ERROR\037: Incorrect Parameters. \037SYNTAX\037: ${controller}bvzm help"; return
    }
	if {$v1 == "restart"} {
	  restart;
	  return
	  }
	if {$v1 == "die"} {
	  die;
	  return
	}
	if {$v1 == "hai"} { putserv "PRIVMSG $chan :hello sir doofenshmerts"; putserv "PRIVMSG $chan ::P" }
	if {$v1 == "nsauth"} {
		putserv "NS ID [getPass]";
		putserv "NS CERT ADD";
		putserv "PRIVMSG $chan Authed to NickServ";
		return;
	}
	if {$v1 == "config"} {
		if {$v2 == "reload"} { rehash; putnow "PRIVMSG $chan :Reloading Configuration File."; return }
	}
}
# Autos procs
proc hub:autovoice {nick host hand chan} {
	if {[channel get $chan "avoice"]} {
		pushmode $chan +v $nick
		break
		flushmode $chan
	}
}

putlog "bvzm.tcl -- LOADED"
