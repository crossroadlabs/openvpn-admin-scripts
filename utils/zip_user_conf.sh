function zip_user_conf {
	DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
	source "$DIR/generate_user_conf.sh"

	if [ -z "$TMP" ]; then
		TMP="/tmp"
	fi

	tmp=$(mktemp -d)
	OUTPUT_FILE="$tmp/$1.zip"

	cname=$(generate_user_conf "$1" "$2")
	zip -jq "$OUTPUT_FILE" "$cname"

	cd "$OLD_PWD"
	rm -rf "$(dirname "$cname")"
	echo "$OUTPUT_FILE"
}
