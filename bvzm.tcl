# ##################################################
# ### bvzm.tcl - bvzm tool file ####################
# ### Coded by rvzm             ####################
# ### ------------------------- ####################
# ### Edited: 05/31/2016        ####################
# ### Version: 0.3              ####################
# ##################################################
if {[catch {source scripts/bvzm-settings.tcl} err]} {
	putlog "Error: Could not load 'scripts/bvzm-settings.tcl' file.";
}
namespace eval bvzm {
	namespace eval gen {
		set pubtrig "@"
		set controller "~"
		set npass "placeholder"
	}
	namespace eval tcc {
		set chan1 "#xhan1"
		set chan2 "#chan2"
		set chan3 "#chan3"
	}
	namespace eval blob {
		# Main Commands
		bind pub - ${bvzm::gen::pubtrig}bvzm bvzm:main
		bind pub - ${bvzm::gen::pubtrig}boobies yus:boobies
		# Friendly commands
		bind pub f ${bvzm::gen::pubtrig}chk sym:check
		bind pub f ${bvzm::gen::pubtrig}rollcall nicks:rollcall
		bind pub - ${bvzm::gen::pubtrig}pack weed:pack
		bind pub f ${bvzm::gen::pubtrig}uptime uptime:pub
		# Op commands
		bind pub o ${bvzm::gen::pubtrig}mvoice hub:mvoice
		# Control Commands
		bind pub m ${bvzm::gen::controller}bvzm hub:control
		# TCC Commands
		bind dcc - tcc1 dcc:tcc1
		bind dcc - tcc2 dcc:tcc2
		bind dcc - tcc3 dcc:tcc3
		bind dcc - tcchelp tcc:help
		# Autos
		bind join - * hub:autovoice

		# Main Command Procs
		proc yus:boobies {nick uhost hand chan text} {
			putserv "PRIVMSG $chan :B00BIEZ";
			putlog "BOOBIEZ"
		}
		proc weed:pack {nick uhost hand chan text} {
			if {[utimerexists floodchk] == ""} {
				putserv "PRIVMSG $chan \00303Pack your \00309bowls\00303! Chan-wide \00304Toke\00311-\00304out\00303 in\00308 1 \00303Minute!\003"
				global wchan
				set wchan $chan
				if {[scan $text "%d%1s" count type] != 2} {
					return
				}
				switch -- $type {
					"s" { set delay $count }
					"m" { set delay [expr {$count * 60}] }
					"h" { set delay [expr {$count * 60 * 60}] }
					default {
						return
					}
				}
			utimer $delay weed:pack:go
			utimer 60 floodchk
			}
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
				puthelp "PRIVMSG $chan :bvzm commands: info";
			}
			if {[lindex [split $text] 0] == "info"} {
				putserv "PRIVMSG $chan :bvzm.tcl - bvzm tool file ~ Coded by rvzm"; return
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
		proc sym:check {nick uhost hand chan text} {
			putserv "PRIVMSG $chan :\[\u2714\] $text";
			return
		}
		proc uptime:pub {nick host handle chan arg} {
		global uptime
		set uu [unixtime]
		set tt [incr uu -$uptime]
		puthelp "privmsg $chan : :: $nick -|- My uptime is [duration $tt]."
		}
		proc dcc:tcc1 {hand idc text} {
			set chan [tcc1]
			set v1 $text
			putserv "PRIVMSG $chan :\[$hand @ bvzm\] $v1";
			putlog "$chan \[$hand\] $v1"
		}
		proc dcc:tcc2 {hand idx text} {
			set chan [tcc2]
			set v1 $text
			putserv "PRIVMSG $chan :\[$hand @ bvzm\] $v1";
			putlog "$chan -> \[$hand\] $v1"
			return
		}
		proc dcc:tcc3 {hand idx text} {
			set chan [tcc3]
			set v1 $text
			putserv "PRIVMSG $chan :\[$hand @ bvzm\] $v1";
			putlog "$chan -> \[$hand\] $v1"
			return
		}

		# Controller command
		proc hub:control {nick uhost hand chan text} {
			set v1 [lindex [split $text] 0]
			set v2 [lindex [split $text] 1]
			putcmdlog "*** bvzm controller - $nick has issued a command: $text"
			if {$v1 == "restart"} {
				restart;
				return
			}
			if {$v1 == "die"} {
				die;
			return
			}
			if {$v1 == "nsauth"} {
				putserv "NS ID [getPass]";
				putserv "PRIVMSG $chan Authed to NickServ";
				return;
			}
			if {$v1 == "config"} {
				if {$v2 == "reload"} { rehash; putserv "PRIVMSG $chan :Reloading Configuration File."; return }
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
		# Utility procs
		proc floodchk {} {
			return
		}
		proc getTrigger {} {
			global bvzm::gen::pubtrig
			return $bvzm::gen::pubtrig
		}
		proc getPass {} {
			global bvzm::gen::npass
			return $bvzm::gen::npass
		}
		proc tcc1 {} {
			global bvzm::tcc::chan1
			return $bvzm::tcc::chan1
		}
		proc tcc2 {} {
			global bvzm:tcc::chan2
			return $bvzm::tcc::chan2
		}
		proc tcc3 {} {
			global bvzm::tcc::chan3
			return $bvzm::tcc::chan3
		}
		proc tcc:help {} {
			putlog "Welcome to TCC - Telnet->Channel Command"
			putlog "-- Current TCC Settings --"
			putlog "Channel 1 (tcc1) - [tcc1]"
			putlog "Channel 2 (tcc2) - [tcc2]"
			putlog "Channel 3 (tcc3) - [tcc3]"
		}
	}
		putlog "bvzm.tcl version 0.3 -- LOADED"
}
