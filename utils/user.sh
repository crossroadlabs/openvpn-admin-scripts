function cleanup_username {
        echo $(echo "$1" | perl -ne 's|.*?([a-zA-Z0-9\.\-_]+)$|\1|; print "$1\n"')
}

function user_exists {
	DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
	source "$DIR/../config.sh"
	source "$OPENVPN_VARS"

	if [ -z "$1" ] ; then
		echo "0"
		return 0
	fi

	user_line=$(tac "$KEY_DIR/index.txt" | grep "$1" | tail -n 1)
	if [ -n "$user_line" ]; then
		user_info=($user_line)
		[[ "${user_info[0]}" == "V" ]] && echo "1" || echo  "0"
	else
		echo "0"
	fi
}

function user_email {
	DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
        source "$DIR/../config.sh"
        source "$OPENVPN_VARS"

	user_line=$(tac "$KEY_DIR/index.txt" | grep "$1" | tail -n 1)
        if [ -n "$user_line" ]; then
                user_info=($user_line)
                if [ "${user_info[0]}" == "V" ] ; then
			echo $(echo "$user_line" | perl -ne 's|.*?emailAddress=([a-zA-Z0-9\.\-]+@[a-zA-Z0-9\.\-]+)|\1|; print "$1"')
			return 0
		fi
        fi

	return 1
}
