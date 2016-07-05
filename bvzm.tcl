# ##################################################
# ### bvzm.tcl - bvzm tool file ####################
# ### Coded by rvzm             ####################
# ### ------------------------- ####################
# ### Version: 0.3              ####################
# ##################################################

namespace eval bvzm {
	namespace eval gen {
		variable pubtrig "@"
		variable controller "~"
		variable npass "placeholder"
	}
	namespace eval flags {
		setudef flag bvzm
		setudef flag avoice
	}
	namespace eval tctlsettings {
		variable dir "data"
	}
	namespace eval dcctcsettings {
		variable chan1 "#chan1"
		variable chan2 "#chan2"
		variable chan3 "#chan3"
	}
	namespace eval binds {
		# Main Commands
		bind pub - ${bvzm::gen::pubtrig}bvzm bvzm::procs::bvzm:main
		bind pub - ${bvzm::gen::pubtrig}pack bvzm::procs::weed:pack
		bind pub - ${bvzm::gen::pubtrig}greet bvzm::greet::greet:sys
		# Friendly commands
		bind pub f ${bvzm::gen::pubtrig}rollcall bvzm::procs::nicks:rollcall
		bind pub f ${bvzm::gen::pubtrig}uptime bvzm::procs::hub:uptime
		# Op commands
		bind pub o ${bvzm::gen::pubtrig}mvoice bvzm::procs::hub:mvoice
		bind pub o ${bvzm::gen::pubtrig}topic bvzm::tctl::do:topic
		# Control Commands
		bind pub m ${bvzm::gen::controller}bvzm bvzm::procs::hub:control
		# dcctc Commands
		bind dcc - dcctc bvzm::dcctc::dcc:dcctc
		# Autos
		bind join - * bvzm::procs::hub:autovoice
		bind join - * bvzm::greet::greet:join
	}
	namespace eval procs {
		# Main Command Procs
		proc weed:pack {nick uhost hand chan text} {
			if {[utimerexists bvzm::procs::floodchk] == ""} {
				global wchan
				set wchan $chan
				if {[lindex [split $text] 0] != ""} {
					if {[scan $text "%d%1s" count type] != 2} {
						putserv "PRIVMSG $chan :error - pack"
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
				} else { set delay 60 }
				putserv "PRIVMSG $chan \00303Pack your \00309bowls\00303! Chan-wide \00304Toke\00311-\00304out\00303 in\00308 $delay \00303seconds!\003"
				utimer $delay bvzm::procs::weed:pack:go
				utimer $delay bvzm::procs::floodchk
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
		proc hub:uptime {nick host handle chan arg} {
			global uptime
			set uu [unixtime]
			set tt [incr uu -$uptime]
			puthelp "privmsg $chan : :: $nick - My uptime is [duration $tt]."
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
				putserv "PRIVMSG NickServ ID [getPass]";
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
	}
	# Greet System

	namespace eval greet {
		setudef flag greet
		if {![file exists gdata]} {
			file mkdir gdata
		}
		# write to *.db files
		proc write_db { w_db w_info } {
			set fs_write [open $w_db w]
			puts $fs_write "$w_info"
			close $fs_write
		}
		# read from *.db files
		proc read_db { r_db } {
			set fs_open [open $r_db r]
			gets $fs_open db_out
			close $fs_open
			return $db_out
		}
		# create *.db files, servers names files
		proc create_db { bdb db_info } {
			if {[file exists $bdb] == 0} {
				set crtdb [open $bdb a+]
				puts $crtdb "$db_info"
				close $crtdb
			}
		}
		proc greet:sys {nick uhost hand chan arg} {
			set txt [split $arg]
			set cmd [string tolower [lindex $txt 0]]
			set msg [join [lrange $txt 1 end]]
			set gdb "gdata/$nick"
			if {$cmd == "set"} {
				write_db $gdb $msg
				putserv "PRIVMSG $chan :Greet for $nick set";
			}
		}
		proc greet:join {nick uhost hand chan} {
			if {![channel get $chan greet]} {return}
			if {[file exists gdata/$nick]} { putserv "PRIVMSG $chan :\[$nick\] - [read_db gdata/$nick]"}
		}
	}
	# topic controller mechanism
	namespace eval tctl {
		if {![file exists $bvzm::tctlsettings::dir]} {
			file mkdir $bvzm::tctlsettings::dir
		}
		# write to *.db files
		proc write_db { w_db w_info } {
			set fs_write [open $w_db w]
			puts $fs_write "$w_info"
			close $fs_write
		}
		# read from *.db files
		proc read_db { r_db } {
			set fs_open [open $r_db r]
			gets $fs_open db_out
			close $fs_open
			return $db_out
		}
		# create *.db files, servers names files
		proc create_db { bdb db_info } {
			if {[file exists $bdb] == 0} {
				set crtdb [open $bdb a+]
				puts $crtdb "$db_info"
				close $crtdb
			}
		}
		setudef flag tctl
		proc do:topic {nick uhost hand chan arg} {
			if {![channel get $chan tctl]} {return}
			if {![file exists "$bvzm::tctlsettings::dir/$chan"]} { file mkdir $bvzm::tctlsettings::dir/$chan }
			set cdir "$bvzm::tctlsettings::dir/$chan"
			global ctlchan top1 top2 top3
			set top1 "$cdir/top1.db"
			set top2 "$cdir/top2.db"
			set top3 "$cdir/top3.db"
			create_db $top1 "null"
			create_db $top2 "null"
			create_db $top3 "null"
			set txt [split $arg]
			set cmd [string tolower [lindex $txt 0]]
			set msg [join [lrange $txt 1 end]]
			set ctlchan $chan
			if {$cmd == "t1"} {
				write_db $top1 $msg
				change_topic
			}
			if {$cmd == "t2"} {
			write_db $top1 $msg
			change_topic
			}
			if {$cmd == "t3"} {
				write_db $top3 $msg
				change_topic
			}
		}
		proc change_topic { } {
			global ctlchan top1 top2 top3
			set top1 [read_db $top1]
			set top2 [read_db $top2]
			set top3 [read_db $top3]
			putquick "TOPIC $ctlchan :$top1 | $top2 | $top3"
		}
	}
	# dcctc mechanism
	namespace eval dcctc {
		proc dcc:dcctc {hand idx text} {
			if {[lindex [split $text] 0] == ""} { putlog "for help use \'dcctc help\'"; return }
			set v1 [lindex [split $text] 0]
				if {$v1 == "1"} { set chan [dcctc1] }
				if {$v1 == "2"} { set chan [dcctc2] }
				if {$v1 == "3"} { set chan [dcctc3] }
				if {$v1 == "help"} {
					putdcc $idx "Welcome to the dcctc system.";
					putdcc $idx "To use, issue the command 'dcctc \[#\] <text>'";
					putdcc $idx "where # is the channel number"
					return
				}
				if {$v1 == "chanlist"} {
					putdcc $idx "Channel List"
					putdcc $idx "Channel 1 - [dcctc1]"
					putdcc $idx "Channel 2 - [dcctc2]"
					putdcc $idx "Channel 3 - [dcctc3]"
					return
				}
			set v2 [string trim $text $v1]
			putserv "PRIVMSG $chan :\[$hand @ bvzm\] $v2";
			putlog "$chan \[$hand\] $v2"
		}
		proc dcctc1 {} {
			global bvzm::dcctcsettings::chan1
			return $bvzm::dcctcsettings::chan1
		}
		proc dcctc2 {} {
			global bvzm::dcctcsettings::chan2
			return $bvzm::dcctcsettings::chan2
		}
		proc dcctc3 {} {
			global bvzm::dcctcsettings::chan3
			return $bvzm::dcctcsettings::chan3
		}
	}
	putlog "bvzm.tcl version 0.3 -- LOADED"
}
