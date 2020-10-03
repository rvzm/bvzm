# ##################################################
# ### bvzm.tcl - bvzm tool file ####################
# ### Coded by rvzm             ####################  ###################
# ### ------------------------- ####################  ### DEV EDITION ###
# ### Version: 0.6              ####################  ###################
# ##################################################
putlog "bvzm:: Loading..."
if {[catch {source scripts/bvzm/bvzm-settings.tcl} err]} {
	putlog "bvzm:: Error loading settings."
}
namespace eval bvzm {
	namespace eval binds {
		# Main Commands
		bind pub - ${bvzm::settings::gen::pubtrig}bvzm bvzm::procs::bvzm:main
		bind pub - ${bvzm::settings::gen::pubtrig}help bvzm::procs::bvzm:help
		bind pub - ${bvzm::settings::gen::pubtrig}greet bvzm::greet::gtrig
		bind pub - ${bvzm::settings::gen::pubtrig}regme bvzm::procs::register
		bind pub - ${bvzm::settings::gen::pubtrig}fchk bvzm::procs::flagcheck
		bind pub - ${bvzm::settings::gen::pubtrig}whoami bvzm::procs::whoami
		bind pub - ${bvzm::settings::gen::pubtrig}version bvzm::procs::version
		bind pub - ${bvzm::settings::gen::pubtrig}pack bvzm::weed::pack
		# Friendly commands
		bind pub f ${bvzm::settings::gen::pubtrig}rollcall bvzm::procs::rollcall
		bind pub f ${bvzm::settings::gen::pubtrig}uptime bvzm::procs::uptime
		bind pub f ${bvzm::settings::gen::pubtrig}status bvzm::procs::status
		# bvzm::e
		bind pub o ${bvzm::settings::gen::pubtrig}e bvzm::procs::e
		# Owner Commands
		bind pub m ${bvzm::settings::gen::controller} bvzm::procs::control
		bind pub m ${bvzm::settings::gen::pubtrig}exec bvzm::procs::exec
		# dccts Commands
		bind pub - ${bvzm::settings::gen::pubtrig}dccts bvzm::dccts::pubm
		bind dcc - dccts bvzm::dccts::go
		# Autos
		bind join - * bvzm::procs::autovoice
		bind join - * bvzm::greet::chantrigger
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
				if {$v2 == "pack"} { putserv "PRIVMSG $chan :command help for 'pack' - options: \[duration\] | pack a bowl, optionally you may specify how long to wait"; return }
				}
			if {$v1 == "info"} {
				putserv "PRIVMSG $chan :bvzm.tcl (version $bvzm::settings::version) - bvzm tool file ~ Coded by rvzm"; return
			}
			if {$v1 == "commands"} {
				putserv "PRIVMSG $chan :bvzm commands | legend - \[flag\]command";
				putserv "PRIVMSG $chan :flags: - anyone, f friend, o chanop, m master"
				putserv "PRIVMSG $chan :\[-\]regme \[-\]greet \[-\]fchk \[-\]whoami \[f\]uptime"
				putserv "PRIVMSG $chan :\[-\]version \[-\]pack \[f\]rollcall \[-\]bvzm \[m\]e"
				if {[matchattr $hand n] == "1"} { putserv "NOTICE $nick :As an owner, you can also use the '${bvzm::settings::gen::controller}' control command"; }
			}
		}
		proc bvzm:help {nick uhost hand chan text} { putserv "PRIVMSG $chan :please use '${bvzm::settings::gen::pubtrig}bvzm help' for help."; return }
		proc rollcall {nick uhost hand chan text} {
			set rollcall [chanlist $chan]
			putserv "PRIVMSG $chan :Roll Call!"
			putserv "PRIVMSG $chan :$rollcall"
		}
		proc uptime {nick host hand chan arg} {
			global uptime
			set uu [unixtime]
			set tt [incr uu -$uptime]
			puthelp "privmsg $chan : :: $nick - My uptime is [duration $tt]."
		}
		proc register {nick uhost hand chan text} {
			if {[validuser $hand] == "1"} { putserv "PRIVMSG $chan :Sorry $nick, but you're already registered. :)"; return }
			if {[adduser $hand $uhost] == "1"} {
				putserv "PRIVMSG [bvzm::util::homechan] :*** Introduced user - $nick / $uhost"
				putlog "*** Introduced to user - $nick / $uhost"
				putserv "PRIVMSG $chan :Congradulations, $nick! you are now in my system! yay :)"
				} else { putserv "PRIVMSG $chan :Addition failed." }
			return
		}
		proc flagcheck {nick uhost hand chan text} {
			if {[validuser $hand] == "0"} { putserv "PRIVMSG $chan :Error - you're not in my userfile. use [bvzm::util::getTrigger]regme to register"; return }
			if {[matchattr $hand f] == "1"} { set chkf friend } else { set chkf user }
			if {[matchattr $hand D] == "1"} { set chkf $chkf,DCCTS }
			if {[matchattr $hand o] == "1"} { set chkf $chkf,globop }
			if {[matchattr $hand p] == "1"} { set chkf $chkf,partyline }
			if {[matchattr $hand t] == "1"} { set chkf $chkf,botnet }
			if {[matchattr $hand m] == "1"} { set chkf $chkf,master }
			if {[matchattr $hand n] == "1"} { set chkf $chkf,owner }
			putserv "PRIVMSG $chan :$nick your flags are $chkf"
			return
		}
		proc status {nick uhost hand chan text} {
			putserv "PRIVMSG $chan :incoming status update...";
			set hostname [exec hostname]
			set commandfound 0;
			set data [exec uptime]
			set output [split $data "\n"]
			foreach line $output {
				putserv "PRIVMSG $chan :${line}"
				}
			}
		proc exec {nick uhost hand chan text} {
			set fp [open "| $text"]
			set data [read $fp]
			if {[catch {close $fp} err]} {
			putserv "PRIVMSG $chan :Error executing..."
			} else {
				set output [split $data "\n"]
				foreach line $output {
				putserv "PRIVMSG $chan :${line}"
				}
			}
		}	
		proc whoami {nick uhost hand chan text} {
			putserv "PRIVMSG $chan :You are $nick \[$uhost\] - According to my system, your handle is $hand"; return
		}
		proc version {nick uhost hand chan text} {
			putserv "PRIVMSG $chan :bvzm -> version-[bvzm::util::getVersion] build [bvzm::util::getBuild]"
			putserv "PRIVMSG $chan :bvzm -> release: [bvzm::util::getRelease]"
			return
		}
		proc e {nick uhost hand chan arg} {
			set txt [split $arg]
			set cmd [string tolower [lindex $txt 0]]
			set msg [lrange $txt 1 end]
			if {$cmd == "op"} {
				if {$msg == ""} { putserv "MODE $chan +o $nick"; return } else { if {[onchan $msg $chan]} { putserv "MODE $chan +o $msg" } } 
				}
			if {$cmd == "deop"} {
				if {$msg == ""} { putserv "MODE $chan -o $nick"; return } else { if {[onchan $msg $chan]} { putserv "MODE $chan -o $msg" } }
				}
			if {$cmd == "voice"} {
				if {$msg == ""} { putserv "MODE $chan +v $nick"; return } else { if {[onchan $msg $chan]} { putserv "MODE $chan +v $msg" } }
				}
			if {$cmd == "devoice"} {
				if {$msg == ""} { putserv "MODE $chan -v $nick"; return } else { if {[onchan $msg $chan]} { putserv "MODE $chan -v $msg" } }
				}
			if {$cmd == "remove"} {
				if {![onchan $msg $chan]} { putserv "PRIVMSG $chan :Error - $msg not on chan"; return }
				putserv "PRIVMSG $chan :$msg - you have ${bvzm::settings::timers::eremove} seconds to leave, or you will be removed."
				global gchan knick
				set gchan $chan
				set knick $msg
				utimer ${bvzm::settings::timers::eremove} bvzm::procs::e:kick $chan $nick
			}
			if {$cmd == "mode"} { putserv "MODE $chan $msg"; return }
			if {$cmd == "invite"} { putserv "PRIVMSG $chan :Alerting $msg to your invite...";  putserv "NOTICE $msg :You have been invited to $chan by $nick :)"; return }
			if {$cmd == "topic"} { putserv "TOPIC $chan :$msg"; return }
			if {$cmd == "mvoice"} { bvzm::util::massvoice $chan; return }
			if {$cmd == "kick"} { e:kick $chan $msg; return }
			if {$cmd == "help"} {
				if {$msg == ""} { puthelp "PRIVMSG $chan :For commands, use \'[bvzm::util::getTrigger]e help commands\'"; return }
				if {$msg == "commands"} { puthelp "PRIVMSG $chan :Commands for bvzm e channel management system"; puthelp "PRIVMSG $chan :op deop voice devoice remove mode invite topic mvoice"; puthelp "PRIVMSG $chan :For help with a command, use '[bvzm::util::getTrigger]e  help <command>'"; return }
				if {$msg == "op"} { puthelp "PRIVMSG $chan :[bvzm::util::getTrigger]e op \[nick\] -  Op yourself or someone else"; return }
				if {$msg == "deop"} { puthelp "PRIVMSG $chan :[bvzm:util::getTrigger]e deop \[nick\]  - deop yourself or someone else"; return }
				if {$msg == "voice"} { puthelp "PRIVMSG $chan :[bvzm::util::getTrigger]e voice \[nick\] - voice yourself or someone else"; return }
				if {$msg == "devoice"} { puthelp "PRIVMSG $chan :[bvzm::util::getTrigger]e devoice \[nick\] - devoice yourself or someone else"; return }
				if {$msg == "remove"} { puthelp "PRIVMSG $chan :[bvzm::util::getTrigger]e remove \[nick\] - notify the channel that a user has 5 seconds to leave or be removed"; return }
				if {$msg == "invite"} { puthelp "PRIVMSG $chan :[bvzm::util::getTrigger]e invite \[nick\] - notify a user that you have invited them to join the channel"; return }
				if {$msg == "topic"} { puthelp "PRIVMSG $chan :[bvzm::util::getTrigger]e topic \[topic\] - set the channel topic"; return }
				if {$msg == "mvoice"} { puthelp "PRIVMSG $chan :[bvzm::util::getTrigger]e mvoice - mass voice the channel"; return }
				if {$msg == "kick"} { puthelp "PRIVMSG $chan :[bvzm::util::getTrigger]e kick \[nick\] - request a user be kicked"; return }
				puthelp "PRIVMSG $chan :Error - unknown subcommand"
				return
			}
		}
		proc e:kick {chan nick} {
			if {![onchan $nick $chan]} { return }
			putserv "KICK $chan $nick :Requested"
			return
		}
		# Controller command
		proc control {nick uhost hand chan text} {
			set v1 [lindex [split $text] 0]
			set v2 [lindex [split $text] 1]
			putcmdlog "*** bvzm controller $nick - $text"
			if {$v1 == "help"} {
				if {$v2 == "rehash"} { putserv "NOTICE $nick :bvzm command 'rehash' - rehashes bvzm conf and script files"; return }
				if {$v2 == "restart"} { putserv "NOTICE $nick :bvzm command 'restart' - restarts bvzm bot"; return }
				if {$v2 == "die"} { putserv "NOTICE $nick :bvzm command 'die' - forces bvzm bot to shut down"; return }
				if {$v2 == "info"} { putserv "NOTICE $nick :bvzm command 'info' - displays current version information to channel"; return }
				if {$v2 == "register"} { putserv "NOTICE $nick :bvzm command 'register' - registers bvzm with the 'npass' and 'email' settings to nickserv"; return }
				if {$v2 == "group"} { putserv "NOTICE $nick :bvzm command 'group' - uses nickserv to group bvzm with the nick provided in the 'gnick' setting"; return }
				if {$v2 == "nsauth"} { putserv "NOTICE $nick :bvzm command 'nsauth' - forces bvzm to identify with nickserv using the 'npass' setting"; return }
				if {$v2 == ""} {
					putserv "NOTICE $nick :bvzm controll commands - rehash restart die"
					putserv "NOTICE $nick :bvzm nickserv commands - nsauth group register"
					return
					}
				putcmdlog "*** bvzm controller $nick - help command error - no if statement triggered"
				}
			if {$v1 == "rehash"} {
				putserv "PRIVMSG $chan :Reloading configuration..."; 
				rehash;
				putserv "PRIVMSG $chan :Configuration file reloaded";
				return
				}
			if {$v1 == "restart"} { restart; return }
			if {$v1 == "die"} { die; return }
			if {$v1 == "info"} { putserv "PRIVMSG $chan :bvzm.tcl running version [bvzm::util::getVersion]"; return }
			### nickserv auth
			if {$v1 == "register"} { putserv "PRIVMSG NickServ :REGISTER [bvzm::util::getPass] [bvzm::util::getEmail]"; return }
			if {$v1 == "group"} {
				if {[bvzm::util::getGroupMethod] == "0"} { putserv "PRIVMSG $chan :\[bvzm\] Error: NickServ Grouping disabled."; return }
				if {[bvzm::util::getGroupMethod] == "1"} { putserv "PRIVMSG NickServ :GROUP [bvzm::util::getGroupNick] [bvzm::util::getPass]"; return }
				if {[bvzm::util::getGroupMethod] == "2"} { putserv "PRIVMSG NickServ :IDENTIFY [bvzm::util::getGroupNick] [bvzm::util::getPass]"; return }
				}
			if {$v1 == "nsauth"} {
				putserv "PRIVMSG NickServ :ID [bvzm::util::getPass]";
				putserv "PRIVMSG $chan :Authed to NickServ";
				return;
			}
		}
		# Autos procs
		proc autovoice {nick host hand chan} {
			if {[channel get $chan "avoice"]} {
				pushmode $chan +v $nick
				break
				flushmode $chan
			}
		}
	}
		# Greet System
	namespace eval greet {
		proc gtrig {nick uhost hand chan text} {
			if {$bvzm::settings::debug == "1"} { putlog "bvzm-debug\: greet command triggered" }
			set v1 [lindex [split $text] 0]
			set txt [split $text]
			set msg [lrange $txt 1 end]
			set gdb "[bvzm::util::greetdir]/$nick"
			if {$v1 == "set"} {
				if {$msg == ""} { putserv "PRIVMSG $chan :error - greet message cannot be empty"; return }
				bvzm::util::write_db $gdb $msg
				putserv "PRIVMSG $chan :Greet for $nick set";
			}
			if {$v1 == "remove"} {
				set gdb "[bvzm::util::greetdir]/$nick"
				set act [exec rm $gdb]
				if {[catch $act err]} { putserv "PRIVMSG $chan :error - removal failed"; return }
				putserv "PRIVMSG $chan :greet for $nick removed"
				return
			}
		}
		proc chantrigger {nick uhost hand chan} {
			if {$bvzm::settings::debug == "1"} { putlog "bvzm-debug\: greet join triggered on $chan" }
			if {![channel get $chan greet]} { return }
			if {![onchan $nick $chan]} { return }
			set file "[bvzm::util::greetdir]/$nick"
			if {[file exists $file]} { putserv "PRIVMSG $chan :\[$nick\] - [bvzm::util::read_db $file]"}
		}
	}
	namespace eval weed {
		proc pack {nick uhost hand chan text} {
				global wchan
				set wchan $chan
				if {[lindex [split $text] 0] != ""} {
					if {[scan $text "%d%1s" count type] != 2} {
						putserv "PRIVMSG $chan :\[bvzm\]error - '$text' is not a valid time delcaration."
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
				} else { set delay $bvzm::settings::timers::packdefault }
				putserv "PRIVMSG $chan \00303Pack your \00309bowls\00303! Chan-wide \00315\002Toke\002\00306-\00315\002out\002\00303 in\00311 $delay \00303seconds!\003"
				utimer $delay bvzm::weed::pack:go
			}
		proc pack:go {} {
			global wchan
			putserv "PRIVMSG $wchan :\00315::\003035\00315:";
			putserv "PRIVMSG $wchan :\00315::\003034\00315:";
			putserv "PRIVMSG $wchan :\00315::\003033\00315:";
			putserv "PRIVMSG $wchan :\00315::\003032\00315:";
			putserv "PRIVMSG $wchan :\00315::\003031\00315:";
			putserv "PRIVMSG $wchan :\00315::\00308\002SYNCRONIZED! \00304Fire Away!\002\00307!\00308\002!"; return
		}
	}
	# Utility procs
	namespace eval util {
		# massvoice
		proc massvoice { chan } {
			foreach whom [chanlist $chan] {
				if {![isvoice $whom $chan] && ![isbotnick $whom] && [onchan $whom $chan]} {
					pushmode $chan +v $whom
					}
				}
			flushmode $chan
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
		proc getVersion {} {
			global bvzm::settings::version
			return $bvzm::settings::version
		}
		proc getBuild {} {
			global bvzm::settings::build
			return $bvzm::settings::build
		}
		proc getRelease {} {
			global bvzm::settings::release
			return $bvzm::settings::release
		}
		proc getTrigger {} {
			global bvzm::settings::gen::pubtrig
			return $bvzm::settings::gen::pubtrig
		}
		proc getPass {} {
			global bvzm::settings::nickserv::npass
			return $bvzm::settings::nickserv::npass
		}
		proc getEmail {} {
			global bvzm::settings::nickserv::email
			return $bvzm::settings::nickserv::email
		}
		proc getGroupNick {} {
			global bvzm::settings::nickserv:gnick
			return $bvzm::settings::nickserv::gnick
		}
		proc getGroupPass {} {
			global bvzm::settings::nickserv::npass
			return $bvzm::settings::nickserv::npass
		}
		proc getGroupMethod {} {
			global bvzm::settings::nickserv::gmethod
			return $bvzm::settings::nickserv::gmethod
		}
		proc homechan {} {
			global bvzm::settings::gen::homechan
			return $bvzm::settings::gen::homechan
		}
		proc greetdir {} {
			global bvzm::settings::greet::dir
			return $bvzm::settings::greet::dir
		}
		proc act {chan text} { putserv "PRIVMSG $chan \01ACTION $text\01"; }
	}
	# dccts mechanism
	namespace eval dccts {
		proc pubm {nick uhost hand chan text} {
			set v1 [lindex [split $text] 0]
			set msg [string trim $text $v1]
			if {$v1 == "info"} {
				putserv "PRIVMSG $chan :bvzm tool file DCC-to-Server system";
				putserv "PRIVMSG $chan :currently at version $bvzm::settings::dccts::version";
				return;
			}
			if {$v1 == "check"} {
				unset dch
				if {$chan == [dccts1]} { set dch "1"; }
				if {$chan == [dccts2]} { set dch "2"; }
				if {$chan == [dccts3]} { set dch "3"; }
				if {$chan == [dccts4]} { set dch "4"; }
				if {$chan == [dccts5]} { set dch "5"; }
				if {$dch => "0"} { putserv "PRIVMSG $chan :\[DCCTS\] This channel is #$dch"; return }
				putserv "PRIVMSG $chan :\[DCCTS\] This channel is not in the system.";
				return;
			}
			if {$v1 == "send"} {
				putlog "DCCTS-| $nick\(@chan\) -> $msg"
				putserv "PRIVMSG $chan :\[DCCTS\] Message sent.";
				return;
			}
			if {$v1 == "help"} {
				putserv "PRIVMSG $chan :bvzm DCCTS:: bvzm version {$bvzm::settings::dccts::version}"
				putserv "PRIVMSG $chan :- check | see where the channel sits in the system"
				putserv "PRIVMSG $chan :- send  | send a message to the partyline"
				putserv "PRIVMSG $chan :- info  | see info about DCCTS"
			}
			putserv "PRIVMSG $chan :\[DCCTS\] Error. please use 'dccts help'"
		}
		proc go {hand idx text} {
			if {![matchattr $hand [reqflag]]} { putdcc $idx "You are not authorized to use dccts"; return}
			if {$bvzm::settings::dccts::mode == "0"} { putdcc $idx "dccts is currently disabled"; return }
			if {$bvzm::settings::dccts::mode == "1"} {
				if {[lindex [split $text] 0] == ""} { putlog "for help use 'dccts help'"; return }
				set v1 [lindex [split $text] 0]
					if {$v1 == "1"} { if {[dccts1] == "0"} { putdcc $idx "dccts channel 1 is disabled"; return } else { set chan [dccts1] } }
					if {$v1 == "2"} { if {[dccts2] == "0"} { putdcc $idx "dccts channel 2 is disabled"; return } else { set chan [dccts2] } }
					if {$v1 == "3"} { if {[dccts3] == "0"} { putdcc $idx "dccts channel 3 is disabled"; return } else { set chan [dccts3] } }
					if {$v1 == "4"} { if {[dccts4] == "0"} { putdcc $idx "dccts channel 4 is disabled"; return } else { set chan [dccts4] } }
					if {$v1 == "5"} { if {[dccts5] == "0"} { putdcc $idx "dccts channel 5 is disabled"; return } else { set chan [dccts5] } }
					if {$v1 == "help"} {
						putdcc $idx "Welcome to the dccts system.";
						putdcc $idx "To use, issue the command 'dccts \[#\] <text>'"
						putdcc $idx "where # is the channel number"
						putdcc $idx "For Channel list, use 'dccts chanlist'"
						return
					}
					if {$v1 == "chanlist"} {
						putdcc $idx "Channel List"
						if {[dccts1] == "0"} { putdcc $idx "Channel 1 - \[DISABLED\]"; } else { putdcc $idx "Channel 1 - [dccts1]" }
						if {[dccts2] == "0"} { putdcc $idx "Channel 2 - \[DISABLED\]"; } else { putdcc $idx "Channel 2 - [dccts2]" }
						if {[dccts3] == "0"} { putdcc $idx "Channel 3 - \[DISABLED\]"; } else { putdcc $idx "Channel 3 - [dccts3]" }
						if {[dccts4] == "0"} { putdcc $idx "Channel 4 - \[DISABLED\]"; } else { putdcc $idx "Channel 4 - [dccts4]" }
						if {[dccts5] == "0"} { putdcc $idx "Channel 5 - \[DISABLED\]"; } else { putdcc $idx "Channel 5 - [dccts5]" }
						return
					}
				set v2 [string trim $text $v1]
				putserv "PRIVMSG $chan :\[dccts\]\[$hand @ bvzm\] $v2";
				putlog "\[$hand->$chan\] $v2"
			} else { putdcc $idx "Error - Invalid dccts mode option" }
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
