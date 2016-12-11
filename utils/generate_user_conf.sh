function generate_user_conf {
	DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
	source "$DIR/../config.sh"
	source "$OPENVPN_VARS"

	if [ -z "$TMP" ]; then
		TMP="/tmp"
	fi

	tmp=$(mktemp -d)

	if [ -f "$KEY_DIR/$1.crt" ] ; then
		sudo -u $OPENVPN_USER "$DIR/../binsudo/cat_key" "$1.key" > "$tmp/$1.key"
		sudo -u $OPENVPN_USER "$DIR/../binsudo/cat_key" "$1.crt" > "$tmp/$1.crt"
	elif [ "$2" == "yes" ] ; then
		sudo -u $OPENVPN_USER "$DIR/../binsudo/cat_backup_key" "$1.crt" > "$tmp/$1.crt"
		sudo -u $OPENVPN_USER "$DIR/../binsudo/cat_backup_key" "$1.key" > "$tmp/$1.key"
	else
		print_error "Key not found. Maybe it is backuped? Use notify then."
	fi

	sudo -u $OPENVPN_USER "$DIR/../binsudo/cat_key" "ca.crt" > "$tmp/ca.crt"

	otmp=$(mktemp -d)
	cp "$DIR/../$OPENVPN_CONF_TEMPLATE" "$otmp/"
	cname=$(basename "$OPENVPN_CONF_TEMPLATE")

	OLD_PWD=$(pwd)
	cd "$tmp"

	echo "<ca>" >> "$otmp/$cname"
	cat ca.crt >> "$otmp/$cname"
	echo "</ca>" >> "$otmp/$cname"

	echo "<cert>" >> "$otmp/$cname"
	openssl x509 -inform PEM -in "$1.crt" >> "$otmp/$cname"
	echo "</cert>" >> "$otmp/$cname"

	echo "<key>" >> "$otmp/$cname"
	cat "$1.key" >> "$otmp/$cname"
	echo "</key>" >> "$otmp/$cname"

	cd "$OLD_PWD"
	rm -rf "$tmp"

	echo "$otmp/$cname"
}
