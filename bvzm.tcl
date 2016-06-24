# ##################################################
# ### bvzm.tcl - bvzm tool file ####################
# ### Coded by rvzm             ####################
# ### ------------------------- ####################
# ### Edited: 05/31/2016        ####################
# ### Version: 0.2              ####################
# ##################################################

set pubtrig "@"
set controller "~"
set bvzm_dir "bvzm_db"
set controlchan "#logs"
# some flags
setudef flag bvzm
setudef flag avoice

proc getTrigger {} {
  global pubtrig
  return $pubtrig
}

# Main Commands
bind pub - ${pubtrig}bvzm bvzm:main
bind pub - ${pubtrig}boobies yus:boobies
# Friendly commands
bind pub f ${pubtrig}chk sym:check
bind pub f ${pubtrig}rollcall nicks:rollcall
bind pub f ${pubtrig}pack weed:pack
# Op commands
bind pub o ${pubtrig}mvoice hub:mvoice
# Control Commands
bind pub m ${controller}bvzm hub:control
# In-progress Commands
bind pub m ${controller}status bvzm:status

# Autos
bind join - * hub:autovoice

# DB stuff
if {![file exists $bvzm_dir]} {
	file mkdir $bvzm_dir
}
proc concw_db { w_db w_info } {
	global bvzm_dir
	set fs_write [open $bvzm_dir/$w_db w]
	puts $fs_write "$w_info"
	close $fs_write
}
proc conn_db { r_db } {
	global bvzm_dir
	set fs_open [open $bvzm_dir/$r_db r]
	gets $fs_open db_out
	close $fs_open
	return $db_out
}
proc connc_db { bdb db_info } {
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
	global packed
	if {$packed == "yes"} { return }
	putserv "PRIVMSG $chan \00303Pack your bowls! Chan-wide Toke-out in 1 Minute!\003"
	global wchan
	set wchan
	set packed yes
	utimer 60 weed:pack:go
}
proc weed:pack:go {} {
	global wchan packed
	putserv "PRIVMSG $wchan :\00303::\003045\00303:";
	putserv "PRIVMSG $wchan :\00303::\003044\00303:";
	putserv "PRIVMSG $wchan :\00303::\003043\00303:";
	putserv "PRIVMSG $wchan :\00303::\003042\00303:";
	putserv "PRIVMSG $wchan :\00303::\003041\00303:";
	putserv "PRIVMSG $wchan :\00303::\00311\002SYNCRONIZED!\002 \00304FIRE THEM BOWLS UP!!!"; return
	set packed no
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
	if {[lindex [split $text] 0] == "quote"} {
		puthelp "PRIVMSG $chan :Quote Commands (<required> \[optional\])"
		puthelp "PRIVMSG $chan :!addquote <quote> (adds a quote)"
		puthelp "PRIVMSG $chan :!delquote <quote id> (deletes a quote)"
		puthelp "PRIVMSG $chan :!quote \[quote id\] (gets a specific or random quote)"
		puthelp "PRIVMSG $chan :!findquote <regexp string> (find quotes matching regexp string)"
		puthelp "PRIVMSG $chan :!lastquote (get the last quote added to the database)"
		puthelp "PRIVMSG $chan :!quoteauth <nick> (find quotes added by nick)"
		puthelp "PRIVMSG $chan :!quotechan <#chan> (find quotes added in #chan)"
	}
}
proc hub:mvoice {nick uhost hand chan text} {
  if {![channel get $chan bvzm]} {return}
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
  if {![channel get $chan bvzm]} {return}
   set rollcall [chanlist $chan]
   putserv "PRIVMSG $chan :Roll Call!"
   putserv "PRIVMSG $chan :$rollcall"
}
proc sym:rekt {nick uhost hand chan text} {
	putserv "PRIVMSG $chan :\[\u2714\] rekt";
	return
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

# --- IN-PROGRESS PROCS ---
proc bvzm:status {nick uhost hand chan text} {
	set ulvl [chattr get $nick]
	set ulvl [chattr get [lindex [split $text] 0]]
	putlog "user flag query: $nick -> $ulvl"
	putserv "PRIVMSG $chan user flag query -> $ulvl"
}
# --- END IN-PROGRESS PROCS ---

putlog "bvzm.tcl version 0.2 -- LOADED"
