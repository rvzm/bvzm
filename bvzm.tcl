# ##################################################
# ### bvzm.tcl - bvzm tool file ####################
# ### Coded by rvzm             ####################
# ### ------------------------- ####################
# ### Version: 0.4              ####################
# ##################################################
if {[catch {source scripts/bvzm-settings.tcl} err]} {
	putlog "Error: Could not load 'scripts/bvzm-settings.tcl' file.";
}
namespace eval bvzm {
	namespace eval binds {
		# Main Commands
		bind pub - ${bvzm::settings::gen::pubtrig}bvzm bvzm::procs::bvzm:main
		bind pub - ${bvzm::settings::gen::pubtrig}greet bvzm::greet::greet:sys
		bind pub - ${bvzm::settings::gen::pubtrig}regme bvzm::procs::register
		bind pub - ${bvzm::settings::gen::pubtrig}fchk bvzm::procs::flagcheck
		bind pub - ${bvzm::settings::gen::pubtrig}slap bvzm::procs::slap
		bind pub - ${bvzm::settings::gen::pubtrig}bitchslap bvzm::procs::bitchslap
		# weed commands
		bind pub - ${bvzm::settings::gen::pubtrig}pack bvzm::weed::pack
		bind pub - ${bvzm::settings::gen::pubtrig}bong bvzm::weed::bong
		bind pub - ${bvzm::settings::gen::pubtrig}pipe bvzm::weed::pipe
		bind pub - ${bvzm::settings::gen::pubtrig}joint bvzm::weed::joint
		bind pub - ${bvzm::settings::gen::pubtrig}dab bvzm::weed::dab
		bind pub - ${bvzm::settings::gen::pubtrig}weed bvzm::weed::info
		# Friendly commands
		bind pub f ${bvzm::settings::gen::pubtrig}rollcall bvzm::procs::nicks:rollcall
		bind pub f ${bvzm::settings::gen::pubtrig}uptime bvzm::procs::hub:uptime
		bind pub f ${bvzm::settings::gen::pubtrig}addslap bvzm::procs::addslap
		# Op commands
		bind pub -|o ${bvzm::settings::gen::pubtrig}mvoice bvzm::procs::mass:voice
		bind pub -|o ${bvzm::settings::gen::pubtrig}topic bvzm::tcs::do:topic
		# Globop commands
		bind pub o ${bvzm::settings::gen::pubtrig}
		# Control Commands
		bind pub m ${bvzm::settings::gen::controller}bvzm bvzm::procs::hub:control
		# flood binds
		bind flud - pub bvzm::procs::flood
		# DCC Commands
		bind dcc - dccts bvzm::dccts::go
		bind dcc - nid bvzm::procs::nid
		# Autos
		bind join - * bvzm::procs::hub:autovoice
		bind join - * bvzm::greet::greet:join
	}
	namespace eval procs {
		# Main Command Procs
		proc bvzm:main {nick uhost hand chan text} {
			set v1 [lindex [split $text] 0]
			set v2 [lindex [split $text] 1]
			set v3 [lindex [split $text] 2]
			if {$v1 == ""} {
				puthelp "PRIVMSG $chan :\037ERROR\037: Incorrect Parameters. \037SYNTAX\037: [bvzm::util::getTrigger]bvzm help"; return
			}
			if {$v1 == "help"} {
				if {$v2 == ""} {
					puthelp "PRIVMSG $chan :\002Public Cmds\002: bvzm commands use [bvzm::util::getTrigger]";
					puthelp "PRIVMSG $chan :bvzm commands: info commands | use '[bvzm::util::getTrigger]bvzm help <command>' for help with that command";
					return
					}
				if {$v2 == "regme"} { putserv "PRIVMSG $chan :command help for 'regme' - this command will register you into my userfile. this allows for extra flags, such as friend, chanop, ect."; return }
				if {$v2 == "greet"} { putserv "PRIVMSG $chan :command help for 'greet' - options: set <greet> | set your greet"; return }
				if {$v2 == "fchk"} { putserv "PRIVMSG $chan :command help for 'fchk' - check what flags you have, or if you are registered with me"; return }
				if {$v2 == "rollcall"} { putserv "PRIVMSG $chan :command help for 'rollcall' - reqs: friend flag | does a roll call, listing all nicks in channel"; return }
				if {$v2 == "uptime"} { putserv "PRIVMSG $chan :command help for 'uptime' - reqs: friend flag | displays my current uptime"; return }
				if {$v2 == "bitchslap"} {putserv "PRIVMSG $chan :command help for 'bitchslap' - options: <nickname> | reqs: friend flag | slaps the given nickname"; return }
				if {$v2 == "mvoice"} { putserv "PRIVMSG $chan :command help for 'mvoice' - reqs: chanop flag | mass-voices the channel"; return }
				if {$v2 == "topic"} { putserv "PRIVMSG $chan :command help for 'topic' - options: t<1|2|3> <text> | reqs: chanop flag | set the topic section for t<num> to <text>"; return }
				# weed commands
				if {$v2 == "pack"} { putserv "PRIVMSG $chan :command help for 'pack' - options: \[duration\] | pack a bowl, optionally you may specify how long to wait"; return }
				if {$v2 == "bong"} { putserv "PRIVMSG $chan :command help for 'bong' - options: \[nick\] | pack a bong and pass it to either yourself or someone else"; return }
				if {$v2 == "pipe"} { putserv "PRIVMSG $chan :command help for 'pipe' - options: \[nick\] | pack a pipe and pass it to either yourself or someone else"; return }
				if {$v2 == "joint"} { putserv "PRIVMSG $chan :command help for 'joint' - options: \[nick\] | roll a joint and pass it to either yourself or someone else"; return }
				if {$v2 == "dab"} { putserv "PRIVMSG $chan :command help for 'dab' - otions: \[nick\] | prepare a dab for yourself or someone else"; return }
				if {$v2 == "weed"} { putserv "PRIVMSG $chan :command help for 'weed' - show information about the weed package"; return }
				}
			if {$v1 == "info"} {
				putserv "PRIVMSG $chan :bvzm.tcl (version $bvzm::settings::version) - bvzm tool file ~ Coded by rvzm"; return
			}
			if {$v1 == "commands"} {
				putserv "PRIVMSG $chan :bvzm commands | legend - \[flag\]command";
				putserv "PRIVMSG $chan :flags: - anyone, f friend, -|o chanop, m master"
				putserv "PRIVMSG $chan :\[-\]regme \[-\]greet \[-\]fchk \[f\]rollcall \[f\]uptime \[f\]bitchslap \[-|o\]mvoice \[-|o\]topic"
				putserv "PRIVMSG $chan :weed package \[-\] - pack, bong, pipe, joint, dab, weed"
			}
		}
		proc mass:voice {nick uhost hand chan text} {
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
		proc bitchslap {nick uhost hand chan text} {
			set v1 [lindex [split $text] 0]
			if {[onchan $v1 $chan] == "0"} { putserv "PRIVMSG $chan :Error! $v1 is not in the channel!"; return }
			set bslappy "slaps $v1 with [bvzm::util::getSlapBanzai]"
			putserv "PRIVMSG $chan \01ACTION $bslappy\01"
			return
		}
		proc slap {nick uhost hand chan text} {
			set v1 [lindex [split $text] 0]
			if {$v1 == ""} { putserv "PRIVMSG $chan \01ACTION slaps the shit out of $nick \01"; putserv "PRIVMSG $chan :thats what you get for not saying who! :P"; return }
			if {[onchan $v1 $chan] == "0"} { putserv "PRIVMSG $chan :Error! $v1 is not in the channel!"; return }
			set slappy "slaps $v1 with [bvzm::util::getSlap]"
			putserv "PRIVMSG $chan \01ACTION $slappy\01"
			return
		}
		proc addslap {nick uhost hand chan text} {
			global bvzm::settings::file::slapdata
			set v1 [lindex [split $text] 0]
			if {$v1 == ""} { putserv "PRIVMSG $chan :Please specify a slap item"; return}
			set file [open $bvzm::settings::file::slapdata a]
			set data $text
			puts -nonewline $file $data
			close $file
			putserv "PRIVMSG $chan :slap item added - $text"
			return
		}
		proc hub:uptime {nick host hand chan arg} {
			global uptime
			set uu [unixtime]
			set tt [incr uu -$uptime]
			puthelp "privmsg $chan : :: $nick - My uptime is [duration $tt]."
		}
		proc register {nick uhost hand chan text} {
			if {[validuser $nick] == "1"} { putserv "PRIVMSG $chan :Sorry $nick, but you're already registered. :)"; return }
			if {[adduser $nick $uhost] == "1"} {
				putserv "PRIVMSG [bvzm::util::homechan] :*** Introduced user - $nick / $uhost"
				putlog "*** Introduced to user - $nick / $uhost"
				putserv "PRIVMSG $chan :Congradulations, $nick! you are now in my system! yay :)"
				} else { putserv "PRIVMSG $chan :Addition failed." }
			return
		}
		proc flagcheck {nick uhost hand chan text} {
			if {[validuser $nick] == "0"} { putserv "PRIVMSG $chan :Error - you're not in my userfile. use [bvzm::util::getTrigger]regme to register"; return }
			if {[matchattr $nick f] == "1"} { set chkf friend } else { set chkf normal }
			if {[matchattr $nick o] == "1"} { set chkf $chkf,globop }
			if {[matchattr $nick p] == "1"} { set chkf $chkf,partyline }
			if {[matchattr $nick t] == "1"} { set chkf $chkf,botnet }
			if {[matchattr $nick m] == "1"} { set chkf $chkf,master }
			if {[matchattr $nick n] == "1"} { set chkf $chkf,owner }
			putserv "PRIVMSG $chan :$nick your flags are $chkf"
			return
		}
		proc flood {nick uhost hand type chan} {
			newignore $host System flood 30
			putlog "*** flood trigered by $nick"
		}
		proc nid {hand idx text} {
			global bvzm::settings::gen::nick
			putserv "NICK $bvzm::settings::gen::nick"
			putserv "PRIVMSG NickServ ID [bvzm::util::getPass]"
			putserv "PRIVMSG [bvzm::util::homechan] :Identified to services -- called by $hand (via DCC)"
			putlog "Identified to services - called by $hand"
			return
		}
		# Controller command
		proc hub:control {nick uhost hand chan text} {
			set v1 [lindex [split $text] 0]
			set v2 [lindex [split $text] 1]
			putcmdlog "*** bvzm controller - $nick has issued a command: $text"
			putserv "PRIVMSG [bvzm::util::homechan] :*** bvzm controller - $nick has issued a command: $text"
			if {$v1 == "rehash"} { rehash; putserv "PRIVMSG $chan :Rehashing configuration file"; return }
			if {$v1 == "restart"} { restart; return }
			if {$v1 == "die"} { die; return }
			if {$v1 == "register"} { putserv "PRIVMSG NickServ :REGISTER [bvzm::util::getPass] [bvzm::util::getEmail]"}
			if {$v1 == "nsauth"} {
				putserv "PRIVMSG NickServ :ID [bvzm::util::getPass]";
				putserv "PRIVMSG $chan :Authed to NickServ";
				return;
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
	}
	namespace eval util {
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
		proc getTrigger {} {
			global bvzm::settings::gen::pubtrig
			return $bvzm::settings::gen::pubtrig
		}
		proc getPass {} {
			global bvzm::settings::gen::npass
			return $bvzm::settings::gen::npass
		}
		proc getEmail {} {
			global bvzm::settings::gen::email
			return $bvzm::settings::gen::email
		}
		proc homechan {} {
			global bvzm::settings::gen::homechan
			return $bvzm::settings::gen::homechan
		}
		proc act {chan text} { putserv "PRIVMSG $chan \01ACTION $text\01"; }
		proc getSlap {} {
			global bvzm::settings::file::slapdata
			set file [open $bvzm::settings::file::slapdata r]
			set slap [read -nonewline $file]
			close $file
			set slap [split $slap \n]
			return [lindex $slap [rand [llength $slap]]]
		}
		proc getSlapBanzai {} {
			global bvzm::settings::file::slapbanzai
			set file [open $bvzm::settings::file::slapbanzai r]
			set slap [read -nonewline $file]
			close $file
			set slap [split $slap \n]
			return [lindex $slap [rand [llength $slap]]]
		}
	}
	# weed package
	namespace eval weed {
		proc pack {nick uhost hand chan text} {
			if {[utimerexists bvzm::util::floodchk] == ""} {
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
				} else { set delay $bvzm::settings::weed::packdefault }
				putserv "PRIVMSG $chan \00303Pack your \00309bowls\00303! Chan-wide \00304Toke\00311-\00304out\00303 in\00311 $delay \00303seconds!\003"
				utimer $delay bvzm::weed::pack:go
				utimer $delay bvzm::util::floodchk
			}
		}
		proc pack:go {} {
			global wchan
			putserv "PRIVMSG $wchan :\00303::\003045\00303:";
			putserv "PRIVMSG $wchan :\00303::\003044\00303:";
			putserv "PRIVMSG $wchan :\00303::\003043\00303:";
			putserv "PRIVMSG $wchan :\00303::\003042\00303:";
			putserv "PRIVMSG $wchan :\00303::\003041\00303:";
			putserv "PRIVMSG $wchan :\00303::\00311\002SYNCRONIZED!\002 \00304FIRE THEM BOWLS UP!!!"; return
		}
		proc bong {nick uhost hand chan text} {
			set v1 [lindex [split $text] 0]
			if {$v1 == ""} { putserv "PRIVMSG $chan :\01ACTION passes the bong to $nick\01" } else { if {[onchan $v1 $chan] == "0"} { putserv "PRIVMSG $chan :Error! $v1 is not in the channel!"; return } else { putserv "PRIVMSG $chan :\01ACTION passes the bong to $v1\01"} }
			putserv "PRIVMSG $chan :Lets make some bubbles!"
			return
		}
		proc pipe {nick uhost hand chan text} {
			set v1 [lindex [split $text] 0]
			if {$v1 == ""} { putserv "PRIVMSG $chan :\01ACTION passes the pipe to $nick\01" } else { if {[onchan $v1 $chan] == "0"} { putserv "PRIVMSG $chan :Error! $v1 is not in the channel!"; return } else { putserv "PRIVMSG $chan :\01ACTION passes the pipe to $v1\01"} }
			putserv "PRIVMSG $chan :Ride the Dragon bro!"
			return
		}
		proc joint {nick uhost hand chan text} {
			set v1 [lindex [split $text] 0]
			if {$v1 == ""} { putserv "PRIVMSG $chan :\01ACTION rolls a joint and passes to $nick\01" } else { if {[onchan $v1 $chan] == "0"} { putserv "PRIVMSG $chan :Error! $v1 is not in the channel!"; return } else { putserv "PRIVMSG $chan :\01ACTION rolls a joint and passes to $v1\01"} }
			putserv "PRIVMSG $chan :Puff Puff Pass!"
			return
		}
		proc dab {nick uhost hand chan text} {
			set v1 [lindex [split $text] 0]
			if {$v1 == ""} { putserv "PRIVMSG $chan :\01ACTION readies the nail and hands the rig to $nick\01" } else {  if {[onchan $v1 $chan] == "0"} { putserv "PRIVMSG $chan :Error! $v1 is not in the channel!"; return } else {putserv "PRIVMSG $chan :\01ACTION readies the nail and hands the rig to $v1\01"} }
			putserv "PRIVMSG $chan :Take a dab broski!"
			return
		}
		proc info {nick uhost hand chan text} {
			set v1 [lindex [split $text] 0]
			if {$v1 == ""} {
				putserv "PRIVMSG $chan :welcome to the bvzm weed package."
				putserv "PRIVMSG $chan :weed package ideas came from both LayneStaley and rvzm | code by rvzm | dab option brought to you by LayneStaley"
			}
		}
	}
	# Greet System
	namespace eval greet {
		if {![file exists $bvzm::settings::dir::greet]} {
			file mkdir $bvzm::settings::dir::greet
		}
		proc greet:sys {nick uhost hand chan arg} {
			set txt [split $arg]
			set cmd [string tolower [lindex $txt 0]]
			set msg [join [lrange $txt 1 end]]
			set gdb [string map {/ .} "$bvzm::settings::dir::greet/$nick"]
			if {$cmd == "set"} {
				bvzm::util::write_db $gdb $msg
				putserv "PRIVMSG $chan :Greet for $nick set";
			}
		}
		proc greet:join {nick uhost hand chan} {
			if {![channel get $chan greet]} {return}
			set file [string map {/ .} $bvzm::settings::dir::greet/$nick]
			if {[file exists $file]} { putserv "PRIVMSG $chan :\[$nick\] - [bvzm::util::read_db $file]"}
		}
	}
	# topic controller mechanism
	namespace eval tcs {
		if {![file exists $bvzm::settings::dir::tcs]} {
			file mkdir $bvzm::settings::dir::tcs
		}

		proc do:topic {nick uhost hand chan arg} {
			if {![channel get $chan tcs]} {return}
			if {![file exists "$bvzm::settings::dir::tcs/$chan"]} { file mkdir $bvzm::settings::dir::tcs/$chan }
			set cdir "$bvzm::settings::dir::tcs/$chan"
			global ctlchan top1 top2 top3
			set top1 "$cdir/top1.db"
			set top2 "$cdir/top2.db"
			set top3 "$cdir/top3.db"
			bvzm::util::create_db $top1 "null"
			bvzm::util::create_db $top2 "null"
			bvzm::util::create_db $top3 "null"
			set txt [split $arg]
			set cmd [string tolower [lindex $txt 0]]
			set msg [join [lrange $txt 1 end]]
			set ctlchan $chan
			if {$cmd == "t1"} {
				bvzm::util::write_db $top1 $msg
				change_topic
			}
			if {$cmd == "t2"} {
			bvzm::util::write_db $top2 $msg
			change_topic
			}
			if {$cmd == "t3"} {
				bvzm::util::write_db $top3 $msg
				change_topic
			}
		}
		proc change_topic { } {
			global ctlchan top1 top2 top3
			set top1 [bvzm::util::read_db $top1]
			set top2 [bvzm::util::read_db $top2]
			set top3 [bvzm::util::read_db $top3]
			putquick "TOPIC $ctlchan :$top1 | $top2 | $top3"
		}
	}
	# dccts mechanism
	namespace eval dccts {
		proc go {hand idx text} {
			if {$bvzm::settings::dccts::mode == "0"} { putdcc $idx "dcctc is currently disabled"; return }
			if {![matchattr $hand [reqflag]]} { putdcc $idx "You are not authorized to use dccts"; return}
			if {$bvzm::settings::dccts::mode == "1"} {
				if {[lindex [split $text] 0] == ""} { putlog "for help use \'dcctc help\'"; return }
				set v1 [lindex [split $text] 0]
					if {$v1 == "1"} { set chan [dccts1] }
					if {$v1 == "2"} { set chan [dccts2] }
					if {$v1 == "3"} { set chan [dccts3] }
					if {$v1 == "4"} { set chan [dccts4] }
					if {$v1 == "5"} { set chan [dccts5] }
					if {$v1 == "help"} {
						putdcc $idx "Welcome to the dcctc system.";
						putdcc $idx "To use, issue the command 'dccts \[#\] <text>'"
						putdcc $idx "where # is the channel number"
						putdcc $idx "For Channel list, use 'dccts chanlist'"
						return
					}
					if {$v1 == "chanlist"} {
						putdcc $idx "Channel List"
						putdcc $idx "Channel 1 - [dccts1]"
						putdcc $idx "Channel 2 - [dccts2]"
						putdcc $idx "Channel 3 - [dccts3]"
						putdcc $idx "Channel 4 - [dccts4]"
						putdcc $idx "Channel 5 - [dccts5]"
						return
					}
				set v2 [string trim $text $v1]
				putserv "PRIVMSG $chan :\[$hand @ bvzm\] $v2";
				putlog "\[$hand->$chan\] $v2"
			} else { putdcc $idx "Error - Invalid dcctc mode option" }
		}
		proc reqflag {} {
			global bvzm::settings::dccts::reqflag
			return $bvzm::settings::dccts::reqflag
		}
		proc dccts1 {} {
			global bvzm::settings::dccts::chan1
			return $bvzm::settings::dccts::chan1
		}
		proc dccts2 {} {
			global bvzm::settings::dccts::chan2
			return $bvzm::settings::dccts::chan2
		}
		proc dccts3 {} {
			global bvzm::settings::dccts::chan3
			return $bvzm::settings::dccts::chan3
		}
		proc dccts4 {} {
			global bvzm::settings::dccts::chan4
			return $bvzm::settings::dccts::chan4
		}
		proc dccts5 {} {
			global bvzm::settings::dccts::chan5
			return $bvzm::settings::dccts::chan5
		}
	}
	putlog "bvzm.tcl version $bvzm::settings::version -- LOADED"
}
