namespace eval bvzm {
	namespace eval settings {
		variable version "0.4.4"
		namespace eval gen {
			variable pubtrig "@"
			variable controller "~bvzm"
			variable nick "bvzm"
			variable npass "BALLSofFIRE223420*"
			variable email "bvzm-project@outlook.com"
			variable homechan "#bvzm"
		}
		namespace eval dccts {
			variable mode "0"
			variable reqflag "Df"
			variable chan1 "#chan1"
			variable chan2 "#chan2"
			variable chan3 "#chan3"
			variable chan4 "#chan4"
			variable chan5 "#chan5"
		}
		namespace eval weed {
			variable packdefault "60"
		}
		namespace eval dir {
			variable greet "gdata"
			variable tcs "data"
		}
		namespace eval file {
			variable slapdata "slapdata/slaps.txt"
			variable slapbanzai "slapdata/banzai.txt"
		}
		namespace eval flags {
			setudef flag bvzm
			setudef flag avoice
			setudef flag greet
			setudef flag tcs
		}
	}
}
