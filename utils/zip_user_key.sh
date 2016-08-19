function zip_user_key {
	DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
        source "$DIR/../config.sh"
        source "$OPENVPN_VARS"
	if [ -z "$TMP" ]; then
		TMP="/tmp"
	fi
	OUTPUT_FILE="$TMP/$1.zip"

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

	cp "$DIR/../$OPENVPN_CONF_TEMPLATE" "$tmp/"
	cname=$(basename "$OPENVPN_CONF_TEMPLATE")

	OLD_PWD=$(pwd)
	cd "$tmp"

	echo "<ca>" >> "$cname"
	cat ca.crt >> "$cname"
	echo "</ca>" >> "$cname"

	echo "<cert>" >> "$cname"
	openssl x509 -inform PEM -in "$1.crt" >> "$cname"
	echo "</cert>" >> "$cname"

	echo "<key>" >> "$cname"
	cat "$1.key" >> "$cname"
	echo "</key>" >> "$cname"

	if [ -n "$OPENVPN_OSX_CONF_BUNDLE" ] ; then
                mkdir "OSX"
                cp -r "$DIR/../$OPENVPN_OSX_CONF_BUNDLE" OSX/
                bname=$(basename "$OPENVPN_OSX_CONF_BUNDLE")
		cp ca.crt "OSX/$bname/Contents/Resources/"
		cp "$1.key" "OSX/$bname/Contents/Resources/"
		cp "$1.crt" "OSX/$bname/Contents/Resources/"
		echo "" >> "OSX/$bname/Contents/Resources/config.ovpn"
		echo "ca ca.crt" >> "OSX/$bname/Contents/Resources/config.ovpn"
		echo "cert $1.crt" >> "OSX/$bname/Contents/Resources/config.ovpn"
		echo "key $1.key" >> "OSX/$bname/Contents/Resources/config.ovpn"
		zip -q -r "$OUTPUT_FILE" "OSX" "$cname"
        else
		zip -q "$OUTPUT_FILE" "$cname"
        fi

	cd "$OLD_PWD"
	rm -rf "$tmp"

	echo "$OUTPUT_FILE"
}
