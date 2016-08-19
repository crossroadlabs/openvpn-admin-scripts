function check_email {
        echo $(echo "$1" | perl -e 'use Email::Valid; print Email::Valid->address(<>) ? "1" : "0"')
}

function send_email {
	if [ -n "$4" ] ; then
		echo "$3" | mutt -a "$4" -s "$2" -- "$1"
	else
		echo "$3" | mutt -s "$2" "$1"
	fi
	echo "$?"
}
