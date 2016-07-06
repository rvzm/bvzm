namespace eval bvzm {
	namespace eval gen {
		variable pubtrig "@"
		variable controller "~"
		variable npass "placeholder"
	}
	namespace eval dcctcsettings {
		variable mode "1"
		variable chan1 "#chan1"
		variable chan2 "#chan2"
		variable chan3 "#chan3"
	}
	namespace eval flags {
		setudef flag bvzm
		setudef flag avoice
		setudef flag greet
		setudef flag tctl
	}
	namespace eval dirset {
		variable greet "gdata"
		variable tctl "data"
	}
	namespace eval tctlsettings {
		variable dir "data"
	}
}
