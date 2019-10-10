function generate_user_conf {
	DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
	source "$DIR/../config.sh"
	source "$DIR/bin.sh"

	if [ -z "$TMP" ]; then
		TMP="/tmp"
	fi

	tmp=$(mktemp -d)

	if [ "$(user_exists $name)" == "0" ] ; then
    print_error "User does not exist: $1"
    exit 1
  fi
	
  run_bin_command "cat_pki" "private/$1.key" > "$tmp/$1.key"
  run_bin_command "cat_pki" "issued/$1.crt" > "$tmp/$1.crt"
  run_bin_command "cat_pki" "ca.crt" > "$tmp/ca.crt"

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
