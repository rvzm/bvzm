# bvzm -> lastfm.tcl
# last.fm now playing
# grabber for bvzm

namespace eval bvzm {
	namespace eval lastfm {
		namespace eval settings {
			variable trig "-";
		}
		package require http
		bind pub - ${bvzm::lastfm::settings::trig}np bvzm::lastfm::procs::np
		bind pub - ${bvzm::lastfm::settings::trig}set bvzm::lastfm::procs::set
		namespace eval procs {
			proc np {nick uhost hand chan text} {
				#putserv "PRIVMSG $chan :bvzm -> lastfm plugin unavailable."; return
				set arg2 1
				set arg1 recent
				set luser [bvzm::lastfm::procs::getUser $nick]
				set v1 [lindex [split $text] 0]
				if {$v1 !== ""} { set arg0 $v1 } else {
					if {$luser == ""} { putserv "PRIVMSG $chan :error - you need to specify or set your username"; return }
					set arg0 $luser;
				}
				set url "http://forum.teranetworks.de/lastfm2.php?user=$arg0&anzahl=$arg2&modus=$arg1"
				http::config -useragent "Mozilla/5.0"
				set incoming [http::data [http::geturl "$url"] ]
				http::cleanup $incoming
				putserv "PRIVMSG $chan :$arg0 last played: ${incoming}"
			}
			 proc set {nick uhost hand chan text} {
				set db "$nick.db"
				set luser [lindex [split $text] 0]
				bvzm::util::write_db $db $luser
				putserv "PRIVMSG $chan :bvzm -> lastfm username for $nick set to $luser"
			}
			proc getUser {nick} {
				set db "$nick.lfm"
				return [bvzm::util::read_db $db]
			}
		}
	}
	putlog "bvzm -> lastfm plugin loaded.";
}
