
function easyrsa_pki_path() {
  info="$(easyrsa_call)"
  echo $(echo "$info" | grep -oP "PKI: \K(.*)")
  return $?
}

function easyrsa_call() {
  DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
	source "$DIR/../config.sh"
  echo $(cd "$OPENVPN_CA_DIR" && "./easyrsa" $@)
  return $?
}