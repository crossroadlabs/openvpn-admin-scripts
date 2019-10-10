function generate_user_conf {
	DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
	source "$DIR/../config.sh"
	source "$DIR/easyrsa.sh"

	if [ -z "$TMP" ]; then
		TMP="/tmp"
	fi

	PKI="$(easyrsa_pki_path)"

	tmp=$(mktemp -d)

	if [ -f "$PKI/issued/$1.crt" ] ; then
		sudo -u $OPENVPN_USER "$DIR/../binsudo/cat_key" "private/$1.key" > "$tmp/$1.key"
		sudo -u $OPENVPN_USER "$DIR/../binsudo/cat_key" "issued/$1.crt" > "$tmp/$1.crt"
	else
		print_error "Key not found."
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
