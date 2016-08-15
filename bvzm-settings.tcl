namespace eval bvzm {
	namespace eval settings {
		variable version "0.4.2"
		namespace eval gen {
			variable pubtrig "@"
			variable controller "~bvzm"
			variable nick "bvzm"
			variable npass "placeholder"
			variable email "placeholder@example.com"
			variable homechan "#home"
		}
		namespace eval dccts {
			variable mode "1"
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
